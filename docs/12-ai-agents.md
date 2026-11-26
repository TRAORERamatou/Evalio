# Evalio - Using AI Agents to Generate Screens

The Project Book allows AI assistants. Each author stays **fully responsible**: understand, test and be able to change every line live. Usage is logged in [ai-usage.md](ai-usage.md). Agent rules are in [AGENTS.md](../AGENTS.md).

## 1. Preconditions
Do not generate screens before:
1. app core exists (T12): router, DI, network, failures;
2. theme and shared state widgets exist (T16);
3. the screen wireframe and its endpoints are validated.

Until then, agents may help with wireframes and tests only.

## 2. Workflow (one screen or flow per branch)
| Step | Action | Gate |
|---|---|---|
| 1 | Create the issue and branch | Owner assigned |
| 2 | Ask the agent for a **plan only**: files, states, events, tests | Owner approves |
| 3 | Domain: entities, repository contract, use cases | No Flutter or Dio import |
| 4 | Bloc or Cubit with `bloc_test` | Success and failure tests pass |
| 5 | Data layer: DTOs, remote and local sources | Matches API contract |
| 6 | UI with four states, shared widgets and theme | Runs on a phone |
| 7 | Owner reads the whole diff and breaks one test on purpose | Test turns red |
| 8 | Pull request, human review | CI green, one approval |

Do not run two agents on the same files. Changes to `core/` go in a separate pull request reviewed by the App Lead.

## 3. Prompt template
```
Context: read AGENTS.md, docs/07-ux.md, docs/06-api-contract.md and the SRS items listed below.
Task: <issue ID and screen name>.
Scope: only app/lib/features/<feature>/ and app/test/features/<feature>/.
Requirements: <FR IDs>.
Endpoints: <method and path>.
States: loading, empty, error with retry, content; plus <specific states>.
Events and transformer: <from docs/07-ux.md>.
Constraints: reuse core widgets and theme; no new dependency; no hard-coded API URL or secret.
Step 1: propose a plan (files, states, tests) and wait for my approval.
Finish by running format, analyze and test, then list assumptions and what you did not verify.
```

## 4. Screen inventory
| Screen | Task | Owner | Requirements | Watch for |
|---|---|---|---|---|
| Login, Register | T13 | Israël | FR-AUTH-01..04 | 422 errors next to fields; droppable submit |
| Courses, Join | T15 | Ramatou | FR-CRS-03, 04 | Cache then network; debounce; paging |
| Quiz list, Quiz editor, Question editor | T21 | Esther | FR-QZ-01..05 | Frozen quiz; field errors |
| Rules, Attempt, Submitted | T23 | Mathias | FR-ATT-01..09, FR-FOC-08 | Server deadline; rollback; pending answers |
| Warning and ejection | T25 | Mathias | FR-FOC-01..09 | Device testing; server decides |
| Attempts list, Grading, Release | T27 | Odiane | FR-GRD-01..04, 08 | Reason after deliberation |
| Result, Statistics, Leaderboard | T29 | Esther | FR-GRD-05..07 | Not-released state |
| Live host | T41 | Ramatou | FR-LIV-01, 03, 06 | Reconnection |
| Live player | T42 | Odiane | FR-LIV-02..07 | Solution only after close |
| Admin and super admin screens (AD-*, SA-*) | SHOULD backlog | to assign | FR-ADM-*, FR-SUP-* | `/super` never shows grades or answers; role guard |

For any screen, use the wireframe with the same ID in [14-ui-design.md](14-ui-design.md).

## 5. Review checklist for generated screens
- [ ] Layers respected; nothing business-related in widgets
- [ ] No invented endpoint, field or rule
- [ ] No unused or unexplained package
- [ ] All states reachable and tested
- [ ] Controllers, timers, streams and sockets disposed
- [ ] 48 dp targets, labels, large text does not overflow
- [ ] No token, answer or personal data logged
- [ ] Author can explain bloc, transformer and error mapping

## 6. Never give an agent
Real student files or grades, `.env` values, signing keys, tokens, or another group's code.
