# Evalio - Backend Schema (MongoDB / Mongoose)

Every document has `_id`, `createdAt`, `updatedAt`. `Ref` is an ObjectId. Grades and points are integers in hundredths (`1550` = 15.50).

## 1. Core collections (MUST)

### users
| Field | Type | Rules |
|---|---|---|
| email | String | required, lowercase, unique |
| passwordHash | String | Argon2id, never returned |
| lastName, firstNames | String | required |
| role | `student` \| `teacher` \| `admin` \| `super_admin` | server-set; `super_admin` has no `schoolId` |
| studentId | String? | e.g. school matricule |
| schoolId | Ref? | |
| isActive | Boolean | default true |

Indexes: `{email:1}` unique; `{schoolId:1, studentId:1}` unique, partial (studentId exists).

### sessions
`userId`, `familyId`, `refreshTokenHash`, `expiresAt`, `revokedAt?`, `replacedBy?`
Indexes: `{refreshTokenHash:1}` unique; `{userId:1}`; `{familyId:1}`; TTL on `expiresAt`.

### courses
`title`, `code`, `description?`, `teacherId`, `classGroupId?`, `joinCode` (random, 8 characters), `isArchived`
Indexes: `{joinCode:1}` unique; `{teacherId:1, createdAt:-1}`; text on `title, code`.

### enrollments
`courseId`, `studentId`, `status: active|removed`, `joinedAt`
Indexes: `{courseId:1, studentId:1}` unique; `{studentId:1, status:1}`.

### quizzes
| Field | Type |
|---|---|
| courseId, authorId | Ref |
| title, instructions | String |
| status | `draft|published|closed|deliberated|released` |
| opensAt, closesAt | Date |
| durationSec | Number |
| settings | embedded (below) |
| appealDeadline, appealAnswersAt | Date? |
| firstAttemptAt | Date? (freezes content) |

`settings`: `maxAttempts=1`, `focus {mode: warning|strict|observe = warning, maxExits=3, maxAbsenceSec=10}`, `release: immediate|after_deliberation`, `showAnswers: after_close|never`, `leaderboard: Boolean`, `shuffleQuestions`, `shuffleOptions`.
Indexes: `{courseId:1, status:1, opensAt:-1}`; `{status:1, closesAt:1}`.

### questions
`quizId`, `position`, `type: single|multiple|written`, `text`, `points`, `options [{ id, text }]`, `correctOptionIds [String]` (`select:false`), `gradingNotes?` (`select:false`), `timeLimitSec?`
Indexes: `{quizId:1, position:1}` unique.

### attempts
| Field | Type |
|---|---|
| quizId, courseId, studentId | Ref |
| number | Number |
| status | `in_progress|pending_grading|graded` |
| startedAt, deadline, endedAt | Date |
| endReason | `submitted|timeout|ejected` |
| questionOrder | [Ref] |
| answers | embedded `[{questionId, selectedOptionIds, text, savedAt, clientSeq, awarded?, comment?}]` |
| exits | embedded `[{clientEventId, leftAt, durationMs, receivedAt}]`, capped at 100 |
| exitCount | Number |
| lastHeartbeatAt | Date |
| rejectedSaves | embedded, capped at 50 |
| score, maxScore | Number |

Indexes: `{quizId:1, studentId:1, number:1}` unique; `{quizId:1, studentId:1}` unique partial where `status = in_progress`; `{status:1, deadline:1}`; `{quizId:1, score:-1}`.

### attemptGrants
`quizId`, `studentId`, `grantedBy`, `reason`, `extraAttempts`, `extraTimeSec`
Index: `{quizId:1, studentId:1}`.

### gradeRevisions (append-only)
`attemptId`, `questionId?`, `oldValue`, `newValue`, `authorId`, `reason`, `appealId?`
Index: `{attemptId:1, createdAt:1}`.

### liveSessions
`quizId`, `hostId`, `pin`, `status: lobby|question|review|ended`, `currentIndex`, `questionClosesAt?`, `participants [{studentId, score, joinedAt}]`. Responses are stored in **liveAnswers**.
Indexes: `{pin:1}` unique partial where status is not `ended`.

### liveAnswers
`sessionId`, `questionId`, `studentId`, `selectedOptionIds`, `receivedAt`, `points`
Index: `{sessionId:1, questionId:1, studentId:1}` unique.

## 2. Extended collections (SHOULD)
| Collection | Main fields | Indexes |
|---|---|---|
| schools | name, status `active\|suspended`, suspendedAt?, createdBy, gradingScale[{min, grade, passed}] | name unique |
| auditLogs (append-only) | actorId, actorRole, action, targetType, targetId, schoolId?, meta (no personal content), at | `{at:-1}`; `{actorId:1, at:-1}`; `{schoolId:1, at:-1}` |
| programmes | schoolId, name, code | `{schoolId, code}` unique |
| cohorts | schoolId, name, year | `{schoolId, name}` unique |
| classGroups | schoolId, programmeId, cohortId, name | `{schoolId, name}` unique |
| invitations | schoolId, email, role (`teacher` or `admin`), invitedBy, tokenHash, expiresAt, usedAt, assignments | tokenHash unique |
| gradebooks | courseId, components[{id, label, weightPct, source: quiz\|manual, quizId?}] | courseId unique |
| manualGrades | courseId, componentId, studentId, status, value, history[] | `{courseId, componentId, studentId}` unique |
| gradeSheets | courseId, version, weights, scale, rows[], transmittedAt, transmittedBy, isOutdated | `{courseId, version}` unique |
| appeals | attemptId, studentId, courseId, questionId?, reason, status, reply, decidedBy, decidedAt | `{courseId, status}`; `{attemptId, questionId}` unique while open |

## 3. Embed or reference
| Data | Choice | Reason |
|---|---|---|
| Options | Embed in question | Always read together, small |
| Questions | Reference quiz | Edited and paginated individually, secrecy easier |
| Answers, exits | Embed in attempt | Bounded, atomic finalisation |
| Enrolments | Reference | Unbounded, queried both ways |
| Grade revisions | Separate collection | Append-only audit trail |
| Sheet rows | Embed snapshot | Must not change after transmission |

## 4. Integrity rules
- Starting an attempt relies on the unique indexes to survive concurrent requests.
- Finalisation is a conditional update from `in_progress`, so it happens once.
- An answer is replaced only if its `clientSeq` is greater than the stored one.
- Rows of `gradeRevisions`, `gradeSheets` and `auditLogs` are never updated, except the `isOutdated` flag.
- Suspending a school or deactivating a user revokes the matching `sessions` in the same operation.
