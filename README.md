# PostgreSQL: ReadyStack build kit

The offline build kit for the Docker image `readystack/postgresql:18.7-CE-ubuntu24.04-r1`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [18.7-CE-ubuntu24.04-r1](https://github.com/readystack-dev/postgresql/releases/tag/18.7-CE-ubuntu24.04-r1)
- Image: [`docker.io/readystack/postgresql:18.7-CE-ubuntu24.04-r1`](https://hub.docker.com/r/readystack/postgresql/tags), manifest digest `sha256:bdae6da0f98801629d04c33a4da257a6041af05c7590f7a032688f220b0207a6`
- Product page: https://readystack.dev/products/postgresql
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=postgresql

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

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/postgresql/recipe. The complete kit is the release download. Each release is a tag here.
