# Evalio - Security

## 1. Assets
Questions and solutions before submission, answers, grades and their history, personal data, tokens.

## 2. OWASP API Security Top 10 (2023) mapping
| Risk | Defence |
|---|---|
| API1 Broken object level authorization | Policy check on every object; ownership or enrolment in the query; 404 when not visible; tests |
| API2 Broken authentication | Argon2id, short access token, rotation with reuse detection, rate limit |
| API3 Broken object property level authorization | Response mappers per role; solutions `select:false`; unknown input fields stripped (role, score cannot be set) |
| API4 Unrestricted resource consumption | Page cap, body limit, answer length limit (10 000 characters), capped arrays, socket event rate limit |
| API5 Broken function level authorization | Role middleware on every route; `/admin` routes scoped to own school; `/super` routes for `super_admin` only |
| API6 Unrestricted access to sensitive business flows | Server rules for attempts and timer; rate limits on join code and PIN |
| API7 Server side request forgery | No user-supplied URL is fetched |
| API8 Security misconfiguration | helmet, validated environment, HTTPS only, no stack traces in production |
| API9 Improper inventory management | Versioned base path, this contract kept up to date, no debug routes |
| API10 Unsafe consumption of APIs | Third-party responses (mail provider) validated and time-limited |

## 3. Cheating threat model
| Threat | Control | Residual risk |
|---|---|---|
| Reading solutions in traffic | Never sent before allowed | Student who finished may tell others: show answers after close |
| Changing phone clock | Server timer | None for the deadline |
| Leaving the app | Exit detection, three modes | Modified or rooted app can hide events |
| Blocking exit reports | Queued reports, heartbeat gaps shown | Teacher judgement needed |
| Screenshots | `FLAG_SECURE` | Second camera |
| Second phone, neighbour | Shuffling, short window | **Not preventable by software** |
| Impersonation | Personal accounts | Shared credentials |
| Replayed requests | Idempotency, `clientSeq`, unique indexes | - |
| Fake student joining | Join code, member list, removal | Self-declared identity until roster matching |

Product wording: Evalio **deters and records** cheating; it does not guarantee its absence. An ejection can be reviewed and a new attempt granted.

## 4. Platform administration
| Threat | Control |
|---|---|
| Stolen super administrator account | Seed-only creation, strong password, shorter session (access 10 min), stricter rate limit, second factor (COULD) |
| Privilege escalation to `super_admin` | Role never accepted from input; no creation endpoint; test that every other role gets 403 on `/super` |
| Super administrator reads student data | Least privilege: `/super` has no access to quizzes, answers, grades; tested |
| Silent abuse of power | Append-only audit log of every action; log entries hold identifiers, not personal content |
| Lockout of a whole school by mistake | Suspension is reversible and audited; sessions revoked, data kept |

## 5. Secrets and data
- Secrets only in environment variables or CI secrets; `.env` ignored; secret scan in CI.
- Signing keystore never committed.
- Only fictitious data in tests, seeds and screenshots.
- Shared result lists are visible only to members of the class, the teacher and the administration.
- Before a real pilot: define retention periods, consent and information notices, and check legal obligations.
- Account deletion must preserve grade records the school is required to keep.
