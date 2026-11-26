# Evalio - Software Requirements Specification (SRS)

**Version:** 0.1 - Related: [PRD](01-prd.md), [API](06-api-contract.md), [Schema](05-database-schema.md)

## 1. Scope and environment
Android application (Flutter, BLoC) and REST + WebSocket API (Node.js 24, Express 5, TypeScript, MongoDB). All times are stored in UTC and displayed in device local time.

## 2. Roles
`student`, `teacher`, `admin` (school administrator), `super_admin` (platform operator). Platform role is set at account creation: self-registration always creates a `student`; teacher accounts come from an invitation (or the seed script until the administration module exists); school administrators come from a super administrator's invitation; the first super administrator is created by the seed script or a one-off command, never through the API. A `super_admin` belongs to no school.

## 3. Functional requirements

### 3.1 Authentication (MUST)
| ID | Requirement |
|---|---|
| FR-AUTH-01 | Register with name, email, password (10 characters minimum) and optional student ID. |
| FR-AUTH-02 | Sign in returns a 15-minute access token and a 30-day rotating refresh token. |
| FR-AUTH-03 | Refresh invalidates the previous token; reuse of an old token revokes the whole session family. |
| FR-AUTH-04 | Sign out revokes the session. |

### 3.2 Courses (MUST)
| ID | Requirement |
|---|---|
| FR-CRS-01 | A teacher creates, edits and archives own courses. |
| FR-CRS-02 | Each course has a unique random join code that the teacher can regenerate. |
| FR-CRS-03 | A student joins once per course; the teacher can remove a member. |
| FR-CRS-04 | Course lists are paginated and searchable. |

### 3.3 Quizzes and questions (MUST)
| ID | Requirement |
|---|---|
| FR-QZ-01 | Question types: single choice, multiple choice, written. |
| FR-QZ-02 | Each question has points greater than 0. Choice questions have 2 to 8 options and at least one correct option. |
| FR-QZ-03 | Status: `draft`, `published`, `closed`, `deliberated`, `released`. "Open" is derived from `published` and the time window. |
| FR-QZ-04 | Questions and rules are frozen once the first attempt starts. |
| FR-QZ-05 | Publishing requires at least one question, a duration and a valid window (`opensAt < closesAt`). |

### 3.4 Attempts (MUST)
| ID | Requirement |
|---|---|
| FR-ATT-01 | Start is allowed only for an enrolled student, inside the window, with attempts remaining. |
| FR-ATT-02 | `deadline = min(startedAt + duration + extraTime, closesAt)`, computed by the server. |
| FR-ATT-03 | Questions sent to students never contain correct options or grading notes. |
| FR-ATT-04 | Each answer is saved individually and idempotently. |
| FR-ATT-05 | A save received after `deadline + 5 s` is rejected and logged. |
| FR-ATT-06 | The server finalises expired attempts without any client request. |
| FR-ATT-07 | An attempt ends with a reason: `submitted`, `timeout`, `ejected`. |
| FR-ATT-08 | A teacher may grant a new attempt to one student with a recorded reason. |
| FR-ATT-09 | An in-progress attempt can be resumed after a restart, without extending the deadline. |

### 3.5 Focus protection (MUST)
| ID | Requirement |
|---|---|
| FR-FOC-01 | The attempt screen is immersive full screen and blocks screenshots (`FLAG_SECURE`). |
| FR-FOC-02 | The app reports each exit (leaving the app or losing window focus) with its duration. |
| FR-FOC-03 | `strict`: the first exit ejects. |
| FR-FOC-04 | `warning` (default): exits 1 and 2 warn, exit 3 ejects (threshold configurable). An absence longer than the maximum ejects. |
| FR-FOC-05 | `observe`: exits are only logged. |
| FR-FOC-06 | The server, not the app, counts exits and decides ejection. |
| FR-FOC-07 | A network loss alone is never counted as an exit. Heartbeat gaps are shown to the teacher. |
| FR-FOC-08 | The rules are shown to the student, who confirms them, before starting. |
| FR-FOC-09 | If the app is killed during an attempt, reopening it counts one exit. |

### 3.6 Grading, deliberation and results (MUST)
| ID | Requirement |
|---|---|
| FR-GRD-01 | Single choice: full points or zero. Multiple choice: exact set required (partial credit is a later option). |
| FR-GRD-02 | Written answers are graded manually between 0 and the question points, with optional comment. |
| FR-GRD-03 | Deliberation is refused while any written answer is ungraded or any attempt is in progress. |
| FR-GRD-04 | Immediate release is allowed only for choice-only quizzes. |
| FR-GRD-05 | A student reads only own copy, only after release rules allow it. |
| FR-GRD-06 | Results per question and per student are available to the course teacher. |
| FR-GRD-07 | Leaderboard ranks by score, then by shorter duration; it shows names and scores only. |
| FR-GRD-08 | Every grade change appends a revision (old value, new value, author, date, reason). |

### 3.7 Live quiz (MUST, advanced feature)
| ID | Requirement |
|---|---|
| FR-LIV-01 | The teacher opens a live session from a choice-only quiz and shares a PIN. |
| FR-LIV-02 | Only enrolled students join. |
| FR-LIV-03 | The server pushes one question at a time with its closing time. |
| FR-LIV-04 | One answer per student per question; late answers are rejected. |
| FR-LIV-05 | The correct option is sent only after the question closes. |
| FR-LIV-06 | Distribution and leaderboard update on all devices without refresh. |
| FR-LIV-07 | A reconnecting client receives the current state. |

### 3.8 Administration (SHOULD)
| ID | Requirement |
|---|---|
| FR-ADM-01 | Manage programmes, cohorts and classes of a school. |
| FR-ADM-02 | Invite teachers by email with a single-use token expiring after 7 days. |
| FR-ADM-03 | Assign a teacher to several course/class pairs across programmes. |
| FR-ADM-04 | Define the grading scale and pass mark. |
| FR-ADM-05 | Receive each transmitted grade sheet and every new version. |
| FR-ADM-06 | (COULD) Import teachers from Excel with preview and per-row errors. |

### 3.9 Grade sheet and appeals (SHOULD)
| ID | Requirement |
|---|---|
| FR-SHT-01 | A course defines weighted components (quiz-based or manual, such as attendance) totalling 100%. |
| FR-SHT-02 | Each cell is `graded`, `pending`, `absent` (counts 0) or `excused`. |
| FR-SHT-03 | The final average (out of 20) is computed only when no weighted cell is `pending`. Excused weights are redistributed proportionally (to validate with the school). |
| FR-SHT-04 | The published list shows number, student ID, last name, first names, component grades, weights, final average, international grade and pass/fail. |
| FR-SHT-05 | A transmitted sheet is an immutable snapshot with a version number and its own copy of weights and scale. |
| FR-SHT-06 | Export as PDF. |
| FR-APL-01 | At release, the teacher sets the appeal deadline and the date answers will be available. |
| FR-APL-02 | A student files an appeal, per assessment or question, with a reason, before the deadline. |
| FR-APL-03 | After the deadline filing is refused with a message to contact the teacher personally. |
| FR-APL-04 | States: `submitted`, `under_review`, `accepted`, `rejected`. |
| FR-APL-05 | The teacher may still revise a grade after the deadline, with a mandatory reason. |
| FR-APL-06 | A revision affecting a transmitted sheet marks it outdated; sending creates the next version. |

### 3.8b Platform administration (SHOULD)
| ID | Requirement |
|---|---|
| FR-SUP-01 | A super administrator creates, renames and suspends schools. A suspended school's users cannot sign in or refresh tokens. |
| FR-SUP-02 | A super administrator invites a school administrator (single-use token, 7 days) for a given school. |
| FR-SUP-03 | A super administrator searches all accounts and activates or deactivates any account except another super administrator; deactivation revokes all its sessions. |
| FR-SUP-04 | Platform counters (schools, users by role, courses, attempts per day) are available without any grade, answer or student-identifying content. |
| FR-SUP-05 | Every super administrator action is written to an append-only audit log (actor, action, target, time). The log can be read and filtered, never edited. |
| FR-SUP-06 | A super administrator cannot read quizzes, answers, grades or grade sheets. Support access to such data requires the school's administrator. |
| FR-SUP-07 | There is no endpoint to create a super administrator, and a super administrator cannot be created by role escalation. |

## 4. Non-functional requirements
| ID | Requirement |
|---|---|
| NFR-01 | 95% of ordinary API requests answer within 800 ms on the deployed service, excluding cold start. |
| NFR-02 | A live session works with 50 simultaneous students (load-tested). |
| NFR-03 | A live question reaches connected devices within 2 s on a normal connection. |
| NFR-04 | The course list is visible offline from cache. |
| NFR-05 | Touch targets at least 48 dp; text scales; state is never conveyed by colour alone. |
| NFR-06 | Supported Android: API 26 and later (proposed). |
| NFR-07 | Logs contain no password, token or answer text. |
| NFR-08 | Collect only the personal data listed in the schema. |

## 5. Project Book traceability
| Req. | How it is met |
|---|---|
| A1 | Node 24, Express 5, Mongoose, TypeScript `tsc --noEmit` in CI |
| A2 | `routes / controllers / services / models`, one module per resource |
| A3 | Zod-validated environment at start-up; `.env.example`; secret scanning |
| A4 | Zod schemas on body, query, params; unknown fields stripped |
| A5 | Single error envelope |
| A6 | Argon2id, rotating hashed refresh tokens, revocation |
| A7 | Policy checks in services; roles student/teacher/admin/super_admin |
| A8 | courses, quizzes, questions, attempts (and more) |
| A9 | Paginated lists, limit capped at 50; search on courses |
| A10 | Indexes listed in the schema |
| A11 | helmet, auth rate limit, 100 kB body limit |
| A12 | Integration tests with one authorization test per resource |
| A13 | Endpoint table and `requests.http` |
| A14 | MongoDB Atlas and HTTPS hosting |
| F1-F4 | Feature-first Clean Architecture, flutter_bloc, Result/Failure, get_it |
| F5 | go_router with auth guard |
| F6 | flutter_secure_storage; single-flight refresh |
| F7 | Four states on every data screen |
| F8 | Optimistic answer saving with rollback; debounced search; droppable submit |
| F9 | Cache then network on course list |
| F10 | Client validation and 422 field errors |
| F11 | bloc_test for every logic bloc and cubit |
| F12-F14 | flutter_lints, `--dart-define`, signed release APK on a real phone |
| P1-P5 | Monorepo, reviewed PRs, CI, issue board, continuous contributions |

## 6. Key acceptance scenarios
1. A student's API responses during an attempt contain no correct-answer field.
2. A save after the deadline is refused even if the phone clock is changed.
3. Two simultaneous start requests create only one attempt.
4. In warning mode the third exit ends the attempt and keeps saved answers.
5. Student B cannot read student A's attempt; teacher B cannot grade teacher A's course.
6. A revised grade keeps its previous value in history.

## Annex - Default grading scale (from the school grading sheet example)
| From (out of 20) | Grade | Result |
|---|---|---|
| 0 | F | Fail |
| 10 | D | Pass |
| 10.5 | C- | Pass |
| 11 | C | Pass |
| 12 | C+ | Pass |
| 13 | B- | Pass |
| 14 | B | Pass |
| 15 | B+ | Pass |
| 16 | A- | Pass |
| 17 | A | Pass |
| 19 | A+ | Pass |

Each threshold applies up to the next one. Averages are rounded to 2 decimals before lookup (to confirm with the school). Example component weights: attendance 15, participation 15, test 1 30, test 2 40.
