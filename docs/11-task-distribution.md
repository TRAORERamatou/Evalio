# Evalio - Task Distribution

**Status:** proposal, to be validated by the team. Weeks are relative to the Project Book publication.

Sizes are relative points (2 small, 3 medium, 5 large), not hours. Each task includes its tests and documentation.

## 1. Balance

| Member | Role | Total | API | App | Repo and docs | Reviews |
|---|---|---|---|---|---|---|
| Ramatou | Team Lead | 20 | 6 | 6 | 8 | 6 |
| Israël | API Lead | 23 | 20 | 3 | 0 | 9 |
| Mathias | App Lead | 21 | 3 | 16 | 2 | 7 |
| Odiane | Quality Lead | 19 | 9 | 6 | 4 | 6 |
| Esther | Product / UX Lead | 20 | 5 | 15 | 0 | 4 |

Every member has tasks in both `api/` and `app/`.

## 2. Milestones 0 and 1 (weeks 1-2)

| ID | Week | Side | Task | Owner | Reviewer | Pts | Depends on |
|---|---|---|---|---|---|---|---|
| T01 | 1 | Repo | First pushes, repository settings, issue board | Mathias | Ramatou | 2 | - |
| T02 | 1-2 | Docs | Documentation review, design.pdf assembly, tag m1 | Ramatou | Esther | 3 | - |
| T03 | 2 | App | Wireframes of main screens and design tokens | Esther | Mathias | 3 | - |
| T04 | 2 | App | Spike: focus detection and FLAG_SECURE on real phones | Mathias | Odiane | 3 | T01 |
| T05 | 2 | Repo | CI verification, branch protection, test conventions | Odiane | Israël | 2 | T01 |
| T06 | 2 | API | Data model and API contract review | Israël | Ramatou | 2 | - |

## 3. Milestone 2 (weeks 3-4)

| ID | Week | Side | Task | Owner | Reviewer | Pts | Depends on |
|---|---|---|---|---|---|---|---|
| T10 | 3 | API | API core: database, validation, auth middleware, rate limit | Israël | Odiane | 3 | T06 |
| T11 | 3-4 | API | Authentication endpoints and tests | Israël | Mathias | 5 | T10 |
| T12 | 3 | App | App core: DI, router guard, Dio, secure storage, token refresh, failures | Mathias | Israël | 5 | T01 |
| T13 | 3-4 | App | Login and register screens with blocs | Israël | Mathias | 3 | T11, T12 |
| T14 | 3-4 | API | Courses and enrolment endpoints | Ramatou | Israël | 3 | T10 |
| T15 | 4 | App | Course list (cache, search, pages) and join screen | Ramatou | Esther | 3 | T12, T14 |
| T16 | 3 | App | Theme and shared state widgets | Esther | Ramatou | 2 | T03, T01 |
| T17 | 3 | API | Deploy API and Atlas with a health route | Odiane | Israël | 2 | T01 |

## 4. Milestone 3 (weeks 5-6)

| ID | Week | Side | Task | Owner | Reviewer | Pts | Depends on |
|---|---|---|---|---|---|---|---|
| T20 | 5 | API | Quiz and question endpoints | Esther | Israël | 3 | T14 |
| T21 | 5-6 | App | Quiz list and quiz editor | Esther | Odiane | 5 | T16, T20 |
| T22 | 5 | API | Attempts, timer, answers, expiry job | Israël | Ramatou | 5 | T20 |
| T23 | 5-6 | App | Rules and attempt screens, optimistic saves, outbox | Mathias | Esther | 5 | T22 |
| T24 | 5 | API | Exits, heartbeat and focus decision | Mathias | Israël | 3 | T22 |
| T25 | 6 | App | Focus guard: native channel and warnings | Mathias | Odiane | 3 | T04, T23, T24 |
| T26 | 5-6 | API | Grading, deliberation, release, grade revisions | Odiane | Israël | 5 | T22 |
| T27 | 6 | App | Grading and deliberation screens | Odiane | Ramatou | 3 | T26 |
| T28 | 6 | API | Results, statistics, leaderboard | Ramatou | Odiane | 3 | T26 |
| T29 | 6 | App | Result, statistics and leaderboard screens | Esther | Ramatou | 3 | T28 |
| T30 | 5 | API | Seed script with fictitious demo data and accounts | Esther | Odiane | 2 | T20 |

## 5. Live quiz and release (weeks 4-7)

| ID | Week | Side | Task | Owner | Reviewer | Pts | Depends on |
|---|---|---|---|---|---|---|---|
| T40 | 4-6 | API | Live quiz gateway (spike in week 4) | Israël | Mathias | 5 | T20 |
| T41 | 6-7 | App | Live host screen | Ramatou | Israël | 3 | T40 |
| T42 | 6-7 | App | Live player screen | Odiane | Mathias | 3 | T40 |
| T50 | 7 | Repo | Signed release APK, release v1.0.0 | Odiane | Mathias | 2 | all |
| T51 | 7 | App | Accessibility, empty and error states pass | Esther | Mathias | 2 | T21, T29 |
| T52 | 7 | Docs | Final report, slides, demo video (all contribute) | Ramatou | Esther | 5 | all |
| T53 | 7 | API | Security review and live load test | Odiane | Israël | 2 | T40 |

## 6. SHOULD backlog (not assigned)
Taken only once every MUST task is done and tested: administration (US14, US15), super administration (US21-US24), appeals (US16, US17), grade sheet and PDF (US18), extra rules (US19). COULD items (US20) come after.

## 7. Standing responsibilities
| Who | Every week |
|---|---|
| Ramatou | Meeting, board, progress note at each milestone |
| Israël | API contract and security review |
| Mathias | App architecture review |
| Odiane | CI health and test review |
| Esther | UX review of each new screen |

## 8. Adjusting
A member may swap tasks of equal size with agreement of both and the Team Lead, provided everyone keeps API and app work. A task blocked for more than 24 hours is raised.
