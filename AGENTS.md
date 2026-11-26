# Instructions for AI coding agents

Evalio: Android assessment app. `app/` Flutter + BLoC, `api/` Node 24 + Express 5 + TypeScript + MongoDB.

## Read first
`docs/02-srs.md`, `docs/06-api-contract.md`, `docs/05-database-schema.md`, `docs/07-ux.md`, `docs/03-architecture.md`.
If code and documents disagree, stop and report it. Do not invent endpoints, fields or rules.

## Non-negotiable rules
- Server decides time, attempts, exits, grades. Correct answers never reach a student before allowed.
- Authorization is checked on every object in the API.
- Validate every body, query and params with Zod; strip unknown fields; one error format.
- App: feature-first `domain` / `data` / `presentation`. `domain` imports neither Flutter nor Dio.
- State with BLoC or Cubit only. No business logic in widgets. Dependencies registered in get_it only.
- Every data screen: loading, empty, error with retry, content.
- No Firebase, Supabase or Appwrite for core data.
- Never write secrets or real personal data. Fictitious data only.
- Do not add a dependency without saying why.
- Do not edit files outside the current task. Do not push, merge or change CI unless asked.

## Checks before finishing
API: `npm run typecheck && npm run lint && npm test`
App: `dart format . && flutter analyze && flutter test`

Report what was done, what was not verified, and any assumption made.
