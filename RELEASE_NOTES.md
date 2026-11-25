# PostgreSQL 18.7 — ReadyStack release `18.7-CE-ubuntu24.04-r1`

Generated 2026-11-12 from this release's build records and strategy. Statements that come from a single record name it in brackets; the others come from this release's strategy and build log.

## Release

- **Image:** `readystack/postgresql:18.7-CE-ubuntu24.04-r1` (linux/amd64). Index digest `sha256:2dc03b128eae31a00087966c4640f5b97d95f76380ac96d5c0e577442efbb9e6` [`docs/provenance/LOCKED_DIGEST.txt`].
- **Image manifest digest:** `sha256:bdae6da0f98801629d04c33a4da257a6041af05c7590f7a032688f220b0207a6` [`TARGET_DIGEST.txt`].
- **Upstream:** PostgreSQL 18.7 built from source at `REL_18_7` of https://github.com/postgres/postgres — upstream notes: https://github.com/postgres/postgres/releases/tag/REL_18_7 [`docs/provenance/BUILD_RECIPE.json`].
- **Base image:** none (`FROM scratch`): a chiselled Ubuntu 24.04 runtime, the files Canonical's chisel cut from Ubuntu's own packages (`vendored/chisel/slices.txt`, `vendored/chisel/packages.tsv`); runtime user `postgres`.
- **Build:** `source-rebuild-c`, compiled offline with `--network=none`.
- **Supersedes:** ReadyStack release `18.6-CE-ubuntu24.04-r7`.

## What changed in this release

- Upstream version 18.6 → 18.7.
- This release moves PostgreSQL from 18.6 to 18.7, a newer release of upstream's 18.x line. Upstream's release notes list what changed: https://github.com/postgres/postgres/releases/tag/REL_18_7

## Security status at release (measured 2026-11-12)

- **Docker Scout:** 0 fixable critical/high vulnerabilities; runs as `postgres` (non-root); SBOM + provenance attestations present (SPDX SBOM + SLSA v1) [`docs/provenance/SCOUT_VERDICT.json`].
- **OSV cross-check:** no fixable critical/high vulnerability beyond Docker Scout's findings.
- **Signature:** cosign signature verified by ReadyStack's release gate before publishing; check it yourself with `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/postgresql:18.7-CE-ubuntu24.04-r1` (signatures are recorded in the public Sigstore transparency log).
- **ReadyStack release check at release:** passed (ReadyStack's own test, not a Docker Scout grade). Vulnerabilities are disclosed every day and the image never changes, so it is re-checked daily, beside Docker Scout's own dated grade, at https://readystack.dev/queue.
- **Before exposing this service:** Never use POSTGRES_HOST_AUTH_METHOD=trust on a reachable network: it disables password checks for every TCP connection.
- **Before exposing this service:** Connections are not encrypted: the image has no server certificate configured, so keep port 5432 on a private network or configure ssl with your own certificate.

## Reproducibility

Rebuilds offline from this archive to the identical image digest `sha256:bdae6da0f98801629d04c33a4da257a6041af05c7590f7a032688f220b0207a6`: run `./BUILD_OFFLINE.sh`, then `./VERIFY_OFFLINE.sh` (add `--online` to confirm the Docker Hub tag holds the same digest). Before publishing, ReadyStack rebuilt the kit with `./BUILD_OFFLINE.sh` and compared the result with the published digest [`docs/provenance/REPRO_VERIFICATION.json`], then ran `./BUILD_OFFLINE.sh` and `./VERIFY_OFFLINE.sh` from this archive (without `--online`).

## Validation

- 6 of 6 use cases passed (6 authored) against the running image [`docs/validation/test-results.json`].

## Known issues

- **low** (ReadyStack package): Seed data records: The archive's seed-data file says PostgreSQL has no SQL database and keeps its state in 'configuration / Kubernetes resources'. [`RSD-postgresql-5e2114c4c5`] (carried from `18.6-CE-ubuntu24.04-r1`, recorded there as `RSD-postgresql-033455999c`)

## Verify this archive

```
sha256sum -c CHECKSUMS.sha256
./BUILD_OFFLINE.sh && ./VERIFY_OFFLINE.sh --online
cosign verify --key https://readystack.dev/keys/cosign.pub readystack/postgresql:18.7-CE-ubuntu24.04-r1
```

ReadyStack records every signature in the public Sigstore transparency log (Rekor), so the command needs no extra flags.

