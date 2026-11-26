#!/usr/bin/env bash
# Creates one GitHub issue per task. Requires: gh auth login. Run ONCE.
set -euo pipefail
cd "$(dirname "$0")/.."
for l in API App Repo Docs; do gh label create "$l" --force >/dev/null; done
gh issue create --title 'T01 - First pushes, repository settings, issue board' --label Repo --body 'Owner: Mathias
Reviewer: Ramatou
Week: 1
Size: 2
Depends on: -

See docs/11-task-distribution.md'
gh issue create --title 'T02 - Documentation review, design.pdf assembly, tag m1' --label Docs --body 'Owner: Ramatou
Reviewer: Esther
Week: 1-2
Size: 3
Depends on: -

See docs/11-task-distribution.md'
gh issue create --title 'T03 - Wireframes of main screens and design tokens' --label App --body 'Owner: Esther
Reviewer: Mathias
Week: 2
Size: 3
Depends on: -

See docs/11-task-distribution.md'
gh issue create --title 'T04 - Spike: focus detection and FLAG_SECURE on real phones' --label App --body 'Owner: Mathias
Reviewer: Odiane
Week: 2
Size: 3
Depends on: T01

See docs/11-task-distribution.md'
gh issue create --title 'T05 - CI verification, branch protection, test conventions' --label Repo --body 'Owner: Odiane
Reviewer: Israël
Week: 2
Size: 2
Depends on: T01

See docs/11-task-distribution.md'
gh issue create --title 'T06 - Data model and API contract review' --label API --body 'Owner: Israël
Reviewer: Ramatou
Week: 2
Size: 2
Depends on: -

See docs/11-task-distribution.md'
gh issue create --title 'T10 - API core: database, validation, auth middleware, rate limit' --label API --body 'Owner: Israël
Reviewer: Odiane
Week: 3
Size: 3
Depends on: T06

See docs/11-task-distribution.md'
gh issue create --title 'T11 - Authentication endpoints and tests' --label API --body 'Owner: Israël
Reviewer: Mathias
Week: 3-4
Size: 5
Depends on: T10

See docs/11-task-distribution.md'
gh issue create --title 'T12 - App core: DI, router guard, Dio, secure storage, token refresh, failures' --label App --body 'Owner: Mathias
Reviewer: Israël
Week: 3
Size: 5
Depends on: T01

See docs/11-task-distribution.md'
gh issue create --title 'T13 - Login and register screens with blocs' --label App --body 'Owner: Israël
Reviewer: Mathias
Week: 3-4
Size: 3
Depends on: T11, T12

See docs/11-task-distribution.md'
gh issue create --title 'T14 - Courses and enrolment endpoints' --label API --body 'Owner: Ramatou
Reviewer: Israël
Week: 3-4
Size: 3
Depends on: T10

See docs/11-task-distribution.md'
gh issue create --title 'T15 - Course list (cache, search, pages) and join screen' --label App --body 'Owner: Ramatou
Reviewer: Esther
Week: 4
Size: 3
Depends on: T12, T14

See docs/11-task-distribution.md'
gh issue create --title 'T16 - Theme and shared state widgets' --label App --body 'Owner: Esther
Reviewer: Ramatou
Week: 3
Size: 2
Depends on: T03, T01

See docs/11-task-distribution.md'
gh issue create --title 'T17 - Deploy API and Atlas with a health route' --label API --body 'Owner: Odiane
Reviewer: Israël
Week: 3
Size: 2
Depends on: T01

See docs/11-task-distribution.md'
gh issue create --title 'T20 - Quiz and question endpoints' --label API --body 'Owner: Esther
Reviewer: Israël
Week: 5
Size: 3
Depends on: T14

See docs/11-task-distribution.md'
gh issue create --title 'T21 - Quiz list and quiz editor' --label App --body 'Owner: Esther
Reviewer: Odiane
Week: 5-6
Size: 5
Depends on: T16, T20

See docs/11-task-distribution.md'
gh issue create --title 'T22 - Attempts, timer, answers, expiry job' --label API --body 'Owner: Israël
Reviewer: Ramatou
Week: 5
Size: 5
Depends on: T20

See docs/11-task-distribution.md'
gh issue create --title 'T23 - Rules and attempt screens, optimistic saves, outbox' --label App --body 'Owner: Mathias
Reviewer: Esther
Week: 5-6
Size: 5
Depends on: T22

See docs/11-task-distribution.md'
gh issue create --title 'T24 - Exits, heartbeat and focus decision' --label API --body 'Owner: Mathias
Reviewer: Israël
Week: 5
Size: 3
Depends on: T22

See docs/11-task-distribution.md'
gh issue create --title 'T25 - Focus guard: native channel and warnings' --label App --body 'Owner: Mathias
Reviewer: Odiane
Week: 6
Size: 3
Depends on: T04, T23, T24

See docs/11-task-distribution.md'
gh issue create --title 'T26 - Grading, deliberation, release, grade revisions' --label API --body 'Owner: Odiane
Reviewer: Israël
Week: 5-6
Size: 5
Depends on: T22

See docs/11-task-distribution.md'
gh issue create --title 'T27 - Grading and deliberation screens' --label App --body 'Owner: Odiane
Reviewer: Ramatou
Week: 6
Size: 3
Depends on: T26

See docs/11-task-distribution.md'
gh issue create --title 'T28 - Results, statistics, leaderboard' --label API --body 'Owner: Ramatou
Reviewer: Odiane
Week: 6
Size: 3
Depends on: T26

See docs/11-task-distribution.md'
gh issue create --title 'T29 - Result, statistics and leaderboard screens' --label App --body 'Owner: Esther
Reviewer: Ramatou
Week: 6
Size: 3
Depends on: T28

See docs/11-task-distribution.md'
gh issue create --title 'T30 - Seed script with fictitious demo data and accounts' --label API --body 'Owner: Esther
Reviewer: Odiane
Week: 5
Size: 2
Depends on: T20

See docs/11-task-distribution.md'
gh issue create --title 'T40 - Live quiz gateway (spike in week 4)' --label API --body 'Owner: Israël
Reviewer: Mathias
Week: 4-6
Size: 5
Depends on: T20

See docs/11-task-distribution.md'
gh issue create --title 'T41 - Live host screen' --label App --body 'Owner: Ramatou
Reviewer: Israël
Week: 6-7
Size: 3
Depends on: T40

See docs/11-task-distribution.md'
gh issue create --title 'T42 - Live player screen' --label App --body 'Owner: Odiane
Reviewer: Mathias
Week: 6-7
Size: 3
Depends on: T40

See docs/11-task-distribution.md'
gh issue create --title 'T50 - Signed release APK, release v1.0.0' --label Repo --body 'Owner: Odiane
Reviewer: Mathias
Week: 7
Size: 2
Depends on: all

See docs/11-task-distribution.md'
gh issue create --title 'T51 - Accessibility, empty and error states pass' --label App --body 'Owner: Esther
Reviewer: Mathias
Week: 7
Size: 2
Depends on: T21, T29

See docs/11-task-distribution.md'
gh issue create --title 'T52 - Final report, slides, demo video (all contribute)' --label Docs --body 'Owner: Ramatou
Reviewer: Esther
Week: 7
Size: 5
Depends on: all

See docs/11-task-distribution.md'
gh issue create --title 'T53 - Security review and live load test' --label API --body 'Owner: Odiane
Reviewer: Israël
Week: 7
Size: 2
Depends on: T40

See docs/11-task-distribution.md'
