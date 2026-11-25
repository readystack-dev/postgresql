# Provenance — PostgreSQL (`18.7-CE-ubuntu24.04-r1`)

Every item below is copied from a record in this archive; the record is named in brackets.

## Source

- Upstream repository: https://github.com/postgres/postgres
- Revision built: `REL_18_7` (commit `f5c41f6681c910b3f69951bf6fb97c6d74605d25`)
- Source tree: `0ed1d466cd2e03b9799e59833fc5b40f4d1f72a9100c46738a047751b9e41df3` over 7352 files [`docs/provenance/SOURCE_TREE_HASH.json`]
- Community Edition only: enterprise code is removed or refused before the build (CE audit at acquire).

## Build

- Method: `source-rebuild-c`; base image `scratch + a chiselled Ubuntu 24.04 runtime (vendored/chisel/slices.txt, packages.tsv)`
- Compiled with `--network=none` from vendored source, dependencies and base images; BuildKit pinned to `moby/buildkit:v0.31.2` (shipped in `toolchain/`).
- SOURCE_DATE_EPOCH: `1794522143` [`SOURCE_DATE_EPOCH.txt`]
- Frozen inputs: [`docs/provenance/FREEZE_MANIFEST.json`], build recipe: [`docs/provenance/BUILD_RECIPE.json`].

## Output

- Published image: `readystack/postgresql:18.7-CE-ubuntu24.04-r1` — index digest `sha256:2dc03b128eae31a00087966c4640f5b97d95f76380ac96d5c0e577442efbb9e6` [`docs/provenance/LOCKED_DIGEST.txt`]
- linux/amd64 image digest `sha256:bdae6da0f98801629d04c33a4da257a6041af05c7590f7a032688f220b0207a6` — reproduced from this archive before publishing [`docs/provenance/REPRO_VERIFICATION.json`].

## Attestations and signature

- SBOM + SLSA provenance attached to the image: attached: an SPDX SBOM and SLSA v1 provenance [`docs/provenance/SCOUT_VERDICT.json`]
- cosign signature by the ReadyStack release key: verified before publishing. Check it: `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/postgresql:18.7-CE-ubuntu24.04-r1`

## Pinned inputs, and why

- 21 pinned inputs, each with where it came from, why this one, how it was checked and when it was decided: `docs/PINS.md` [`docs/provenance/PINS.json`] (upstream source 2, base and build images 3, image digests 2, dependency versions readystack sets 1, pins in the kit's dockerfiles 5, readystack's build engine 6, dependencies upstream chose 2).

## Build trail

- How this release passed through the ReadyStack harness, record by record (every chain, drive, stage, review round, defect and check, each naming the record it is copied from): `ReadyStack-postgresql-18.7-CE-ubuntu24.04-r1.trail.json`, published beside this archive and signed with the release key (`ReadyStack-postgresql-18.7-CE-ubuntu24.04-r1.trail.json.sigstore`), and readable at https://readystack.dev/products/postgresql/trail/18.7-CE-ubuntu24.04-r1.

