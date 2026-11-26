# Evalio - Test Strategy and CI

## 1. Levels
| Level | Tools (proposed) | Scope |
|---|---|---|
| API unit | Vitest | Deadline, grading, focus decision, scale lookup |
| API integration | Vitest, supertest, in-memory MongoDB replica set | Every module, authorization |
| Bloc | bloc_test, mocktail | Every bloc and cubit with logic, success and failure |
| Widget (bonus) | flutter_test | Attempt and warning screens |
| Device | Manual checklist | Focus, screenshots, calls, network cuts |
| Load | k6 or Artillery | 50 live participants |

## 2. Priority tests (write first)
| ID | Test |
|---|---|
| T01 | No response to a student contains `correctOptionIds` before it is allowed |
| T02 | Save after deadline refused |
| T03 | Concurrent starts create one attempt |
| T04 | Attempt limit enforced; grant adds one |
| T05 | Exit modes: strict, warning (3rd), observe; duplicate event counted once |
| T06 | Expiry finalises and grades once |
| T07 | Older `clientSeq` does not overwrite |
| T08 | User B cannot access user A's objects (one per resource) |
| T09 | Deliberation refused with ungraded answers |
| T10 | Grade change writes a revision |
| T11 | Live: late and second answers refused |
| T12 | Refresh token reuse revokes the family |
| T13 | Grade sheet example: 16, 16, 14, 15 with weights 15/15/30/40 gives 15.00, B+ |
| T14 | Appeal after deadline refused |

## 3. Device checklist
Incoming call, notification shade, battery alert, split screen, picture-in-picture, home and recent buttons, screen lock, app killed, airplane mode, low-end phone, at least two Android versions.

## 4. CI pipeline (every pull request)
| Job | Steps |
|---|---|
| api | `npm ci`, lint, `tsc --noEmit`, tests |
| app | `flutter pub get`, `dart format --set-exit-if-changed .`, `flutter analyze`, `flutter test` |
| docker | build the API image (`runtime` target), validate `docker-compose.yml` |
| secrets | secret scanner over the history |
| release (tag) | build APK, attach to release |

`main` is protected: green CI and one approval.

## 5. Targets
Every server rule has a test that fails when the rule is removed. Coverage is observed, not used as a goal in itself.
