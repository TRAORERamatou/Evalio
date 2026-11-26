# Evalio - Team Charter

**Course:** Advanced Mobile Development, Year 3 - Instructor: Dr Lebian Wilfried NIKIEMA
**Topic:** T17 - QuizArena (class quizzes)
**Repository:** https://github.com/TRAORERamatou/Evalio
**Version:** 0.1 (draft, takes effect once signed by all members)

## 1. Members and roles

| Member | Role | Accountable for |
|---|---|---|
| Ramatou TRAORE | Team Lead | Planning, issue board, meeting notes, final integration, contact with the instructor |
| Israël Wa Nzambi NKUNA | API Lead | API design, data model, security review, API tests |
| Zangafigué Mathias TRAORE | App Lead | App architecture, navigation, shared core, code reviews |
| KABORE Tegwende Odiane Elia Aziliz | Quality Lead | CI pipeline, lints, test strategy, release builds |
| OUEDRAOGO Bowend-yaam Esther | Product / UX Lead | User journeys, wireframes, empty and error states, accessibility |

A role means responsibility, not exclusive ownership. **Every member writes code in both `api/` and `app/`** and must be able to explain the whole project.

## 2. Commitments
1. Each member announces their availability for the coming week at the weekly meeting.
2. Each member merges at least one reviewed pull request per week, in addition to reviewing others.
3. A blocker lasting more than 24 hours is reported to the group.
4. A member who cannot deliver a task says so at least 48 hours before its due date.
5. Nobody merges code they cannot explain, including code produced with AI assistants. AI usage is noted for the final report.
6. Code is never shared with other groups.

## 3. Communication and meetings
| Item | Proposed rule |
|---|---|
| Daily channel | Group chat; reply within 24 h |
| Weekly meeting | 45 min, day and time to be agreed |
| Short sync | 15 min, twice a week during weeks 3 to 7 |
| Minutes | `docs/meetings/YYYY-MM-DD.md`, written by the Team Lead or a delegate |
| Tasks | GitHub Issues and Projects are the single source of truth |

## 4. Git rules
- No direct push to `main` after Milestone 1.
- Branches: `feat/<issue>-<slug>`, `fix/...`, `docs/...`, `test/...`.
- Commits follow Conventional Commits (`feat(api): ...`).
- Every pull request: linked issue, green CI, **one approval from another member**, ideally under 400 changed lines.
- Reviews are done within 24 h.
- No secret, real student data or grade file is ever committed.

## 5. Definition of Done
- Acceptance criteria met.
- Tests written (success and failure paths) and passing.
- Authorization tested for any new endpoint.
- Loading, empty, error and content states handled on any new data screen.
- Lint, format and type check clean.
- Documentation updated.

## 6. Decisions and conflicts
1. Seek consensus.
2. Otherwise the lead of the affected area decides and records the reason.
3. If still contested, majority vote.
4. An unresolved conflict or a repeatedly absent member is raised with the instructor early, by the Team Lead, after the member has been informed.

## 7. Missed commitments
First time: discussion and new date. Second time: task reassigned and noted in the minutes. Third time: the instructor is informed. Contributions are visible in the Git history and feed the peer evaluation honestly.

## 8. Ownership after the course
The code belongs jointly to the five members. **Any deployment at the school, publication or commercial use requires a separate written agreement** covering ownership, roles and revenue.

## 9. Signatures

| Member | Date | Signature |
|---|---|---|
| Ramatou TRAORE | | |
| Israël Wa Nzambi NKUNA | | |
| Zangafigué Mathias TRAORE | | |
| KABORE Tegwende Odiane Elia Aziliz | | |
| OUEDRAOGO Bowend-yaam Esther | | |
