#!/usr/bin/env bash
set -Eeuo pipefail
export PGDATA="${PGDATA:-/var/lib/postgresql/data}"
export PATH="/usr/local/pgsql/bin:$PATH"
PGUSER_NAME="${POSTGRES_USER:-postgres}"

# An existing cluster elsewhere on the volume is never answered with a new, empty one (upgrade path, 2026-10-27). The
# Docker Official Image keeps PostgreSQL 18 and later in /var/lib/postgresql/<major>/docker (its volume at
# /var/lib/postgresql) and earlier releases in /var/lib/postgresql/data; a volume mounted one level away from $PGDATA
# puts its cluster above or below it. The entrypoint refuses and names the fix, never switches PGDATA itself: the
# container's PGDATA would then differ from the directory the server runs on, for every docker exec.
existing_clusters() {
  local c seen=" "
  for c in /var/lib/postgresql/data /var/lib/postgresql/*/docker "$PGDATA"/*/docker "$PGDATA"/data "$(dirname "$PGDATA")"; do
    case "$seen" in *" $c "*) continue ;; esac
    seen="$seen$c "
    if [ "$c" != "$PGDATA" ] && [ -s "$c/PG_VERSION" ]; then printf '%s\n' "$c"; fi
  done
  return 0
}

# First boot: initialize the cluster (runs as the non-root postgres user).
if [ ! -s "$PGDATA/PG_VERSION" ]; then
  mapfile -t others < <(existing_clusters)
  if [ "${#others[@]}" -gt 0 ]; then
    server_major="$(postgres -V)"; server_major="${server_major##* }"; server_major="${server_major%%.*}"
    other_major="$(head -n1 "${others[0]}/PG_VERSION")"
    echo >&2 "ERROR: there is no database cluster in PGDATA ($PGDATA), but this container's volumes hold one:"
    for c in "${others[@]}"; do echo >&2 "         $c (PostgreSQL $(head -n1 "$c/PG_VERSION"))"; done
    echo >&2 "       Nothing was initialised: a new, empty cluster here would hide that data."
    echo >&2 "       To run this image on it, keep the volume mounted where it is and set PGDATA to that directory:"
    echo >&2 "         docker run ... -e PGDATA=${others[0]} ...   (compose: environment: PGDATA: ${others[0]})"
    echo >&2 "       The Docker Official Image keeps PostgreSQL 18 and later in /var/lib/postgresql/<major>/docker"
    echo >&2 "       (its volume at /var/lib/postgresql); this image's default PGDATA is /var/lib/postgresql/data."
    if [ "$other_major" != "$server_major" ]; then
      echo >&2 "       That cluster was written by PostgreSQL $other_major and this image runs PostgreSQL $server_major,"
      echo >&2 "       which cannot open it: upgrade it first (pg_upgrade, or a dump and restore)."
    fi
    exit 1
  fi
  if [ -z "${POSTGRES_PASSWORD:-}" ] && [ "${POSTGRES_HOST_AUTH_METHOD:-}" != "trust" ]; then
    echo >&2 "ERROR: POSTGRES_PASSWORD is not set and POSTGRES_HOST_AUTH_METHOD is not 'trust'."
    echo >&2 "       You must specify POSTGRES_PASSWORD for a non-empty superuser password,"
    echo >&2 "       or set POSTGRES_HOST_AUTH_METHOD=trust for an insecure (dev-only) cluster."
    exit 1
  fi
  mkdir -p "$PGDATA"
  # Local socket ALWAYS trust (the entrypoint init psql + in-container ops go via the socket; the
  # container runs only as postgres). Host/TCP auth = POSTGRES_HOST_AUTH_METHOD (trust for the dev image;
  # production customers override to scram-sha-256 + a real POSTGRES_PASSWORD). This makes pg_hba's default
  # localhost rule match trust FIRST (a trailing appended trust line would never be reached).
  initdb_args=( --username="$PGUSER_NAME" --encoding=UTF8 --auth-local=trust --auth-host="${POSTGRES_HOST_AUTH_METHOD:-scram-sha-256}" )
  pwfile=""
  if [ -n "${POSTGRES_PASSWORD:-}" ]; then
    pwfile="$(mktemp)"; printf '%s' "$POSTGRES_PASSWORD" > "$pwfile"
    initdb_args+=( --pwfile="$pwfile" )
  fi
  # shellcheck disable=SC2086
  initdb "${initdb_args[@]}" ${POSTGRES_INITDB_ARGS:-}
  [ -n "$pwfile" ] && rm -f "$pwfile"
  echo "host all all all ${POSTGRES_HOST_AUTH_METHOD:-scram-sha-256}" >> "$PGDATA/pg_hba.conf"
  # The init psql connects to the temp server over the local socket; when initdb set a
  # scram password on local auth, psql needs it -> pass it via PGPASSWORD (empty under trust).
  export PGPASSWORD="${POSTGRES_PASSWORD:-}"
  # Bootstrap a local-only server to create the DB + run init scripts.
  pg_ctl -D "$PGDATA" -o "-c listen_addresses=''" -w start
  if [ -n "${POSTGRES_DB:-}" ] && [ "${POSTGRES_DB}" != "$PGUSER_NAME" ]; then
    psql -v ON_ERROR_STOP=1 --username "$PGUSER_NAME" --dbname postgres -c "CREATE DATABASE \"${POSTGRES_DB}\";"
  fi
  for f in /docker-entrypoint-initdb.d/*; do
    [ -e "$f" ] || continue
    case "$f" in
      *.sh)  echo "running $f"; . "$f" ;;
      *.sql) echo "running $f"; psql -v ON_ERROR_STOP=1 --username "$PGUSER_NAME" --dbname "${POSTGRES_DB:-postgres}" -f "$f" ;;
    esac
  done
  pg_ctl -D "$PGDATA" -m fast -w stop
  unset PGPASSWORD
fi

exec postgres -D "$PGDATA" -c listen_addresses='*'
