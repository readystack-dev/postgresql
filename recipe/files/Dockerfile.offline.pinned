# GENERATED L-009 hermetic C build (--network=none, SBOM+SLSA-attestation-producing).
# Pinned bases; vendored source (in-tree deps) + extra build debs + runtime debs from Dockerfile.vendor.
FROM ubuntu:24.04@sha256:2198e4c65076e9cb0b3d695219df667c0e3b0072da64ca3c2648aca17dcecaf5 AS cbuild
# dpkg-install the vendored EXTRA build debs (pkg-config/libssl-dev/...) — gcc/make are in the builder.
RUN --mount=type=bind,source=vendored/build-debs,target=/tmp/bdebs \
    set --; for f in /tmp/bdebs/*.deb; do [ -e "$f" ] && set -- "$@" "$f"; done; \
    for pass in 1 2 3 4 5; do [ $# -eq 0 ] || dpkg -i --skip-same-version "$@" >/dev/null 2>&1 && break; done; \
    dpkg --configure -a && bad= && for d in "$@"; do p=$(dpkg-deb -f "$d" Package) v=$(dpkg-deb -f "$d" Version); \
      case "$(dpkg-query -W -f='${Version} ${db:Status-Abbrev}' "$p" 2>/dev/null)" in "$v ii"*) ;; *) bad="$bad $p=$v" ;; esac; done && \
    { [ -z "$bad" ] || { echo "vendored debs not installed at their vendored version:$bad" >&2; false; }; }
WORKDIR /src
COPY vendored/postgresql-src/ .
ARG SOURCE_DATE_EPOCH=1794522143
ENV SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH}
ENV DEB_BUILD_OPTIONS=nocheck
RUN ./configure --prefix=/usr/local/pgsql --with-openssl --with-libxml --with-icu --with-lz4 --with-zstd --with-readline --without-llvm
RUN make -j"$(nproc)" world-bin
RUN make install-world-bin
RUN set -eu; find /usr/local/pgsql -type f | LC_ALL=C sort | while read -r f; do \
      readelf -h "$f" >/dev/null 2>&1 || continue; \
      readelf -lW "$f" | sed -n 's/.*Requesting program interpreter: \(.*\)]$/\1/p'; \
      readelf -dW "$f" | sed -n 's/.*Shared library: \[\(.*\)\]$/\1/p'; \
    done | LC_ALL=C sort -u | while read -r lib; do case "$lib" in \
      /*) echo "$lib" ;; *) [ -n "$(find /usr/local/pgsql -name "$lib" -print -quit)" ] || echo "$lib" ;; esac; \
    done > /kitforge.needs && echo "the install prefix loads: $(tr '\n' ' ' < /kitforge.needs)"
# rs-probe: the HEALTHCHECK helper (standard library only, from the kit's rs-probe.go)
FROM golang:1.27.3-bookworm@sha256:972b4110ba0f47539a975c31e52c64765e1ff19f2d74469ae4a595c6676e80a5 AS build_rs_probe
WORKDIR /probe
COPY rs-probe.go main.go
COPY rs-probe.mod go.mod
ENV CGO_ENABLED=0 GOTOOLCHAIN=local GOFLAGS="-buildvcs=false" GOPROXY=off SOURCE_DATE_EPOCH=1794522143
RUN go build -trimpath -ldflags='-s -w' -o /rs-probe .
# the chiselled rootfs (vendored/chisel, cut by Dockerfile.vendor), the service user, the binaries
FROM ubuntu:24.04@sha256:2198e4c65076e9cb0b3d695219df667c0e3b0072da64ca3c2648aca17dcecaf5 AS rootfs
ARG SOURCE_DATE_EPOCH=1794522143
ADD vendored/chisel/rootfs.tar /rootfs/
RUN printf 'postgres:x:999:999::/var/lib/postgresql:/bin/sh\n' >> /rootfs/etc/passwd && printf 'postgres:x:999:\n' >> /rootfs/etc/group && \
    mkdir -p /rootfs/var/lib/postgresql /rootfs/var/lib/postgresql/data /rootfs/run/postgresql /rootfs/docker-entrypoint-initdb.d && chown -R 999:999 /rootfs/var/lib/postgresql /rootfs/var/lib/postgresql/data /rootfs/run/postgresql /rootfs/docker-entrypoint-initdb.d
COPY --from=build_rs_probe /rs-probe /rootfs/usr/local/bin/rs-probe
COPY docker-entrypoint.sh /rootfs/usr/local/bin/docker-entrypoint.sh
COPY --from=cbuild /usr/local/pgsql /rootfs/usr/local/pgsql
COPY --from=cbuild /kitforge.needs /tmp/needs/postgresql
RUN chmod 755 /rootfs/usr/local/bin/rs-probe && \
    chmod 0755 /rootfs/usr/local/bin/docker-entrypoint.sh
RUN set -eu; ROOT=/rootfs; \
    chmod 1777 "$ROOT/docker-entrypoint-initdb.d"; \
    ln -s /usr/share/zoneinfo/Etc/UTC "$ROOT/etc/localtime"
RUN --mount=type=bind,source=vendored/chisel,target=/chisel set -eu; \
    for n in /tmp/needs/*; do while read -r lib; do [ -n "$lib" ] || continue; \
      case "$lib" in /*) [ -e "/rootfs$lib" ] ;; *) [ -n "$(find /rootfs/usr/lib /rootfs/usr/lib64 -name "$lib" 2>/dev/null | head -1)" ] ;; esac || \
      { echo "$(basename "$n") needs $lib, which the chiselled rootfs does not have: add its slice to runtime_base.slices" >&2; exit 1; }; \
    done < "$n"; done; rm -rf /tmp/needs; \
    [ -e /rootfs/etc/os-release ] || { echo "no /etc/os-release: base-files_release-info is missing" >&2; exit 1; }; \
    [ "$(grep -c '^Package: ' /rootfs/var/lib/dpkg/status)" = "$(wc -l < /chisel/packages.tsv)" ] || \
      { echo "/var/lib/dpkg/status does not list every package of vendored/chisel/packages.tsv" >&2; exit 1; }; \
    rm -rf /rootfs/var/log/dpkg.log /rootfs/var/log/alternatives.log /rootfs/var/log/apt /rootfs/var/cache/ldconfig/aux-cache /rootfs/var/cache/fontconfig
FROM scratch
ARG SOURCE_DATE_EPOCH=1794522143
COPY --from=rootfs /rootfs/ /
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PATH=/usr/local/pgsql/bin:$PATH PGDATA=/var/lib/postgresql/data LANG=C.UTF-8 LC_ALL=C.UTF-8
LABEL org.opencontainers.image.title="PostgreSQL"
LABEL org.opencontainers.image.version="18.7-CE-ubuntu24.04-r1"
LABEL org.opencontainers.image.source="https://github.com/postgres/postgres"
LABEL org.opencontainers.image.description="PostgreSQL 18.7 object-relational database server, compiled from source (CE, non-root, offline-rebuildable)"
LABEL org.opencontainers.image.licenses="PostgreSQL"
LABEL org.opencontainers.image.vendor="PostgreSQL Global Development Group"
LABEL org.opencontainers.image.revision="f5c41f6681c910b3f69951bf6fb97c6d74605d25"
HEALTHCHECK --interval=5s --timeout=120s --start-period=30s \
  CMD pg_isready -U postgres -h 127.0.0.1 -p 5432 || exit 1
USER postgres
EXPOSE 5432
STOPSIGNAL SIGINT
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
