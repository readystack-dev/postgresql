[![ReadyStack](https://readystack.dev/logo.svg)](https://readystack.dev)

**Stable, Open-source Releases, Automated** · [readystack.dev](https://readystack.dev)

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-readystack%2Fpostgresql-2496ED?logo=docker&logoColor=white)](https://hub.docker.com/r/readystack/postgresql) [![Docker pulls](https://img.shields.io/docker/pulls/readystack/postgresql)](https://hub.docker.com/r/readystack/postgresql) [![Grade at release](https://img.shields.io/badge/grade%20at%20release-A%20%2894%25%29-2ea44f)](https://readystack.dev/products/postgresql) [![Signed: cosign](https://img.shields.io/badge/signed-cosign-2ea44f)](https://readystack.dev/keys/cosign.pub) ![SBOM: SPDX](https://img.shields.io/badge/SBOM-SPDX-2ea44f) ![Provenance: SLSA v1](https://img.shields.io/badge/provenance-SLSA%20v1-2ea44f) ![Offline rebuild: verified](https://img.shields.io/badge/offline%20rebuild-verified-2ea44f)

# PostgreSQL: ReadyStack build kit

The offline build kit for the Docker image `readystack/postgresql:18.7-CE-ubuntu24.04-r1`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [18.7-CE-ubuntu24.04-r1](https://github.com/readystack-dev/postgresql/releases/tag/18.7-CE-ubuntu24.04-r1)
- Image: [`docker.io/readystack/postgresql:18.7-CE-ubuntu24.04-r1`](https://hub.docker.com/r/readystack/postgresql/tags), manifest digest `sha256:bdae6da0f98801629d04c33a4da257a6041af05c7590f7a032688f220b0207a6`
- Product page: https://readystack.dev/products/postgresql
- Source and build recipe: https://readystack.dev/products/postgresql/recipe
- Build trail: https://readystack.dev/products/postgresql/trail/18.7-CE-ubuntu24.04-r1
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=postgresql

## The image

Single container. A self-contained PostgreSQL 18.7 object-relational database server, compiled from source (./configure && make world-bin && make install-world-bin). The image IS the complete running instance — PostgreSQL itself IS the database, so there is NO external database and NO sidecar. On first boot the entrypoint runs initdb to create the cluster under PGDATA (/var/lib/postgresql/data), then runs `postgres` in the foreground. Runs fully NON-ROOT as the postgres user.

## Who uses PostgreSQL and why

Developers and database administrators who need a reliable relational database for applications of any size.

PostgreSQL is an open-source object-relational database that uses and extends SQL, known for reliability, data integrity and extensibility, with add-ons such as geospatial extensions.

A typical use: A team builds a booking application in which double bookings must never happen. PostgreSQL's transactions make each booking all-or-nothing, an exclusion constraint rejects overlapping bookings, and the same database stores flexible JSON details and answers the reporting queries.

From the upstream project's own description: https://www.postgresql.org/about/.

## This release

- Docker Scout policy grade at release: **A** (94%), graded 2026-11-12 with `docker scout policy` (CLI 1.26.0, docker-default configuration).
  - Docker Scout counts 21 packages with copyleft licences (GPL, LGPL, MPL), all of them operating-system packages (it counts only packages whose licence it can read; the SBOM lists every component).
- Signed with ReadyStack's release key (fingerprint `04daa92344a52dbc`): https://readystack.dev/keys/cosign.pub.
- Runs as a non-root user (`postgres`).
- Attestations on the image: an SPDX SBOM and SLSA provenance v1.
- Rebuilt from this kit with network egress blocked on 2026-11-12; the rebuilt image digest is the published one.
- Base: Ubuntu 24.04.

The current grade, measured again every day, is on https://readystack.dev/products/postgresql.

PostgreSQL is distributed under its upstream licence (PostgreSQL); the kit contains upstream's source under that licence, and each vendored component under its own.

## Download

From the [18.7-CE-ubuntu24.04-r1 release](https://github.com/readystack-dev/postgresql/releases/tag/18.7-CE-ubuntu24.04-r1): `ReadyStack-postgresql-18.7-CE-ubuntu24.04-r1.tar.gz` (641.4 MB), SHA-256 `4e503267bf606d84f93baa8bf31c6630a8e7670943981d2b1ba4f457ed8fe711`.

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

## Verify and rebuild

The rebuild statement is signed with the ReadyStack release key. Check the signature before you rely on it:

```sh
cosign verify-blob --key https://readystack.dev/keys/cosign.pub \
  --bundle ReadyStack-postgresql-18.7-CE-ubuntu24.04-r1.rebuild.json.sigstore ReadyStack-postgresql-18.7-CE-ubuntu24.04-r1.rebuild.json
```

Unpack with `-p` so file modes are kept, then follow the kit's own README.md and docs/REBUILD.md:

```sh
tar -xpzf ReadyStack-postgresql-18.7-CE-ubuntu24.04-r1.tar.gz
cd 18.7-CE-ubuntu24.04-r1
less README.md docs/REBUILD.md
```

The build trail (`ReadyStack-postgresql-18.7-CE-ubuntu24.04-r1.trail.json`, signed the same way, and its Markdown copy) records how this release was built and checked.

## This repository

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/postgresql/recipe. The complete kit is the release download. Each release is a tag here. How to report a vulnerability: [SECURITY.md](SECURITY.md).

## About ReadyStack

**Stable, Open-source Releases, Automated.** ReadyStack releases popular open-source apps every week with every available critical and high security fix applied, plus full documentation, reference data, tests and a build recipe that recreates each release bit-for-bit. Each release is rebuilt from its pinned inputs with the network off, checked against its published digest, signed, and scanned and graded again every day. The images and build kits are free, and ReadyStack is soon to be a nonprofit.

[readystack.dev](https://readystack.dev) · [All products](https://readystack.dev/products.html) · [Build kits on GitHub](https://github.com/readystack-dev) · [Defect log](https://readystack.dev/defects.html) · contact@readystack.dev

— ReadyStack · https://readystack.dev
