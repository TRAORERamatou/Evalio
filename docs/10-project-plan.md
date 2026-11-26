# Evalio - Project Plan

Weeks are counted from the publication of the Project Book. **Exact dates: to be filled from the instructor's announcement.** Assignments are in [11-task-distribution.md](11-task-distribution.md).

## 1. Milestones
| When | Tag | Must exist | Team content |
|---|---|---|---|
| Week 1 | m0 | Members, topic, repository, instructor invited | Charter signed |
| End week 2 | m1 | `docs/design.pdf` (6-10 pages) | Validate these documents, device spike on focus detection |
| End week 4 | m2 | Auth end to end, one resource listed, CI, API deployed | Courses and enrolment |
| End week 6 | m3 | All required features and main tests | Quizzes, attempts, focus, grading, deliberation, results |
| End week 7 | m4 | Advanced feature, release build, report, slides, video; **code freeze** | Live quiz finished; SHOULD items only if MUST is done |
| Week 8 | v1.0.0 | Defence | Rehearsal on real phone |

The live quiz is required for m4, but its technical spike starts in week 4 to reduce risk.

## 2. Work breakdown
| Epic | Stories | Priority | Depends on | Size |
|---|---|---|---|---|
| E0 Repository, CI, skeletons | - | MUST | - | M |
| E1 Authentication | US01 | MUST | E0 | M |
| E2 Courses and enrolment | US02, US03 | MUST | E1 | M |
| E3 Quiz authoring | US04, US05 | MUST | E2 | L |
| E4 Attempts and timer | US07, US08 | MUST | E3 | L |
| E5 Focus protection | US06 | MUST | E4 | M |
| E6 Grading, deliberation, results | US09-US12 | MUST | E4 | L |
| E7 Live quiz | US13 | MUST | E3 | L |
| E8 Release and documents | - | MUST | all | M |
| E9 Administration | US14, US15 | SHOULD | E2 | L |
| E9b Super administration | US21-US24 | SHOULD | E9 | M |
| E10 Appeals | US16, US17 | SHOULD | E6 | M |
| E11 Grade sheet and export | US18 | SHOULD | E6 | M |
| E12 Extra rules | US19 | SHOULD | E4 | S |
| E13 Comfort features | US20 | COULD | - | - |

## 3. Risks
| Risk | Likelihood | Impact | Response |
|---|---|---|---|
| Scope overrun | High | High | Cut COULD then SHOULD; never cut core or tests |
| Focus detection unreliable | Medium | High | Spike in week 2; tolerant default |
| Live mode difficulties | Medium | High | Spike in week 4 |
| Late deployment | Medium | High | Deploy a health route in week 3 |
| Hosting sleep during demo | Medium | Medium | Warm up; backup video |
| Uneven contribution | Medium | High | Weekly review of pull requests |
| Weak shared understanding | Medium | High | Rotate API and app tasks; weekly walkthrough |
| Power or internet cuts | Medium | Medium | Small frequent pushes; local environment |

## 4. Before milestone 1
- [ ] Charter signed
- [ ] Open questions answered (PRD section 10)
- [ ] Issue board created and linked here
- [ ] Task distribution validated and issues created
- [ ] `docs/design.pdf` assembled and tagged `m1`
