# ADR-001 - Docker for the API image and the local stack

## Status
Accepted

## Date
2026-11-26

## Context
Five members work on Windows, macOS or Linux and must run the same API and database. The API needs MongoDB as a replica set because attempts and grading rely on transactions (tests T03, T10). Deployment (task T17) needs a reproducible artefact, and Render-like hosts accept container images. The Flutter app targets Android and does not benefit from containers.

## Decision
- `api/Dockerfile` is multi-stage with three targets: `dev` (hot reload), `build`, and `runtime` (production: non-root, production dependencies only, health check on `/api/v1/health`).
- `docker-compose.yml` starts the API and a single-node MongoDB replica set for local development. It is optional: running Node and MongoDB directly still works.
- CI builds the `runtime` image and validates the compose file on every pull request.
- Production database stays MongoDB Atlas. The compose database is for development only.
- The app is not containerised.

## Alternatives considered
- **Local installs only**: no extra tool, but versions drift between members and a replica set is tedious to configure by hand. Kept as a fallback.
- **Atlas for everyone in development**: no local setup, but needs network, shared or per-member clusters, and risks mixing test data with demo data.
- **Hosting without a container (buildpack)**: less to maintain, but the deployed environment would differ from CI and local runs.

## Consequences
- Positive: one command to start the stack, same Node 24 runtime everywhere, a deployable image.
- Negative: members need Docker Desktop; file watching on Windows and macOS can be slower; a CI job and a Dockerfile to maintain.
- Follow-up: T17 deploys the `runtime` image; secrets are injected as environment variables, never baked into the image; keep `.nvmrc` and the `NODE_VERSION` build argument aligned.
