# Evalio - Product Requirements Document (PRD)

**Version:** 0.1 - 26 November 2026

## 1. Vision
Evalio is an Android assessment platform that lets schools run quizzes and online assignments, grade them, and deliver traceable results.

## 2. Problem
- Paper assessments cost printing and manual grading time.
- Instant feedback in class is hard to obtain.
- Grade sheets are assembled by hand and corrections are hard to trace.
- Existing platforms are priced in foreign currency (Testportal's pricing page showed USD 35 per month for 30 results when consulted on 26 November 2026; verify before reuse).
- Unstable networks can ruin an online attempt.

## 3. Goals
| ID | Goal | Measure at the defence |
|---|---|---|
| G1 | Cover every core feature of T17 | 100% of the topic card demonstrated |
| G2 | Server-enforced fairness | Automated tests prove answer secrecy, timer and attempt limits |
| G3 | Deter cheating on the phone | Three focus-loss modes demonstrated on a real device |
| G4 | Survive short network cuts | Saved answers survive an app restart |
| G5 | Support written answers | Manual grading and deliberation work end to end |

Long-term goal (after the course): a lower-cost alternative adapted to the local context, piloted at our school.

## 4. Non-goals for this project
Room management and invigilator planning, payments, webcam proctoring, iOS, web client, guaranteed prevention of cheating.

## 5. Users
| Actor | Needs |
|---|---|
| Student | Join a course, take assessments reliably, see results, appeal a grade |
| Teacher | Build quizzes, set rules, follow attempts, grade, deliberate, handle appeals |
| School administrator (SHOULD) | Define the academic structure, invite teachers, receive results and revisions |
| Super administrator (SHOULD) | Operate the platform: create schools, appoint school administrators, suspend accounts, read the audit log. Cannot read answers or grades |

## 6. Product principles
1. The server is the source of truth for time, attempts, answers and grades.
2. What can reasonably be a choice is configurable, with safe defaults.
3. A network cut is not treated as cheating.
4. A published or transmitted grade is never silently overwritten.
5. Students see only their own copy; shared result lists follow the school format.

## 7. User stories

### MUST
| ID | Story |
|---|---|
| US01 | As a user, I want to register, sign in and sign out so that my data is protected. |
| US02 | As a teacher, I want to create a course and share a join code so that my students can enrol. |
| US03 | As a student, I want to join a course with a code so that I can access its assessments. |
| US04 | As a teacher, I want to create timed quizzes with multiple-choice and written questions so that I can assess in depth. |
| US05 | As a teacher, I want to set duration, opening window and allowed attempts so that the rules fit the assessment. |
| US06 | As a teacher, I want to choose strict, warning or observation mode so that I control the reaction to leaving the screen. |
| US07 | As a student, I want each answer saved as I go so that a cut or ejection does not erase my work. |
| US08 | As a student, I want my multiple-choice answers graded automatically so that I get quick results. |
| US09 | As a teacher, I want to grade written answers with comments so that students are assessed fairly. |
| US10 | As a teacher, I want to deliberate before releasing grades so that I can check them first. |
| US11 | As a student, I want to view my result and copy once released so that I understand my mistakes. |
| US12 | As a teacher, I want results per question and per student and a leaderboard so that I can see what was understood. |
| US13 | As a teacher, I want to host a live quiz so that my class answers together in real time. |

### SHOULD
| ID | Story |
|---|---|
| US14 | As an administrator, I want to define programmes, cohorts and classes so that results are organised. |
| US15 | As an administrator, I want to invite teachers by email and assign them to classes so that only real staff teach. |
| US16 | As a student, I want to appeal a grade before the deadline so that errors can be corrected. |
| US17 | As a teacher, I want to answer appeals and revise grades with a reason so that changes are traceable. |
| US18 | As a teacher, I want a weighted grade sheet, exportable as PDF, so that I can publish and transmit results. |
| US19 | As a teacher, I want question shuffling, per-question timers and extra time so that rules fit each situation. |

### SHOULD - platform administration
| ID | Story |
|---|---|
| US21 | As a super administrator, I want to create and suspend schools so that each institution is isolated and onboarded deliberately. |
| US22 | As a super administrator, I want to invite a school administrator by email so that a school can start without developer help. |
| US23 | As a super administrator, I want to deactivate any account and revoke its sessions so that I can handle abuse or a lost phone. |
| US24 | As a super administrator, I want platform counters and an audit log so that I can supervise usage without seeing grades or answers. |

### COULD
| ID | Story |
|---|---|
| US20 | As a teacher, I want email delivery, Excel import, a question bank, live time extension and French/English so that I save time. |

## 8. Scope summary
| Priority | Content |
|---|---|
| MUST (Project Book) | Mandatory technical requirements, T17 core features and server rules, real-time live quiz |
| MUST (team) | Full screen with three modes, answer saving, duration and window, written questions and grading, deliberation |
| SHOULD | Administration, super administration (US21-US24), grade history screens, appeals, weighted grade sheet, PDF export, shuffling, per-question timer, extra time |
| COULD | Email delivery, Excel import, question bank, live extension, question import, internationalisation |
| Later | Payments, multi-school operations, iOS, webcam proctoring |

**Release rule:** no SHOULD item starts before the MUST scope is complete and tested.

## 9. Configurable settings and defaults
| Setting | Default | Set by |
|---|---|---|
| Focus mode | `warning` | Quiz author |
| Exit that ejects (warning mode) | 3rd | Quiz author |
| Maximum single absence | 10 s (proposed, to validate on devices) | Quiz author |
| Attempts | 1 | Quiz author |
| Result release | Immediate for MCQ-only; after deliberation if any written question | Quiz author |
| Correct answers shown | After the assessment closes | Quiz author |
| Leaderboard | Off for assignments, on for live quizzes (proposed) | Quiz author |
| Component weights | Must total 100% | Teacher |
| Grading scale and pass mark | School scale (see SRS annex) | Administrator |
| Appeal window and answer date | None until set at release | Teacher |

Not configurable: answer secrecy before submission, server-side timer and attempt control, grade history, authorization checks.

## 10. Risks and open questions
| Item | Note |
|---|---|
| Scope too large for 8 weeks | Strict priority order; weekly scope review |
| Android cannot fully lock a user in | Presented as deterrence and detection |
| False ejections (calls, notifications) | Device tests; warning mode by default |
| Real use needs school approval and data-protection review | Before any pilot, check obligations with the national data protection authority |
| Name "Evalio" already used by other assessment projects | Check again before any public release |
| Open | Value of maximum absence; leaderboard defaults; who may impose weights |
