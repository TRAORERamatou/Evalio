# Evalio - API Contract

Base URL: `https://<host>/api/v1`. JSON only. Auth: `Authorization: Bearer <accessToken>`.

## 1. Conventions
Success: `{ "data": ... }`; lists add `"meta": { "page", "limit", "total" }` with `?page=1&limit=20` (maximum 50).

Error (single format):
```json
{ "error": { "code": "VALIDATION_ERROR", "message": "Invalid input",
  "details": [{ "field": "email", "message": "Invalid email" }], "requestId": "..." } }
```
| Status | Meaning |
|---|---|
| 400 | Malformed request |
| 401 | Missing or expired token |
| 403 | Role not allowed |
| 404 | Not found, or not visible to this user |
| 409 | State conflict |
| 413 | Body too large |
| 422 | Validation error |
| 429 | Rate limited |

Common errors on protected routes: 401, 403, 404, 422. Roles: P public, S student, T teacher, A school administrator, SA super administrator.
**Own** = teacher owns the course; **Enr** = student actively enrolled; **Self** = resource belongs to the caller.

## 2. MUST endpoints
| Method | Path | Role / rule | OK | Main errors |
|---|---|---|---|---|
| POST | /auth/register | P | 201 | 409, 422, 429 |
| POST | /auth/login | P | 200 | 401, 429 |
| POST | /auth/refresh | P (refresh token) | 200 | 401, 429 |
| POST | /auth/logout | Self | 204 | 401 |
| GET | /me | any | 200 | 401 |
| GET | /courses?search= | S: Enr, T: Own | 200 | 401 |
| POST | /courses | T | 201 | 422 |
| GET | /courses/{courseId} | Own or Enr | 200 | 404 |
| PATCH | /courses/{courseId} | Own (includes archive) | 200 | 404, 422 |
| POST | /courses/{courseId}/join-code | Own, regenerate | 200 | 404 |
| POST | /enrollments | S, body `joinCode` | 201 | 404, 409, 429 |
| GET | /courses/{courseId}/members | Own | 200 | 404 |
| DELETE | /courses/{courseId}/members/{studentId} | Own | 204 | 404 |
| GET | /courses/{courseId}/quizzes | Own (all), Enr (non-draft) | 200 | 404 |
| POST | /courses/{courseId}/quizzes | Own | 201 | 422 |
| GET | /quizzes/{quizId} | Own or Enr (no questions for S) | 200 | 404 |
| PATCH | /quizzes/{quizId} | Own, not frozen | 200 | 409, 422 |
| DELETE | /quizzes/{quizId} | Own, draft only | 204 | 409 |
| POST | /quizzes/{quizId}/publish | Own | 200 | 409, 422 |
| POST | /quizzes/{quizId}/unpublish | Own, no attempt | 200 | 409 |
| POST | /quizzes/{quizId}/close | Own | 200 | 409 |
| GET | /quizzes/{quizId}/questions | Own | 200 | 404 |
| POST | /quizzes/{quizId}/questions | Own, not frozen | 201 | 409, 422 |
| PATCH | /questions/{questionId} | Own, not frozen | 200 | 409, 422 |
| DELETE | /questions/{questionId} | Own, not frozen | 204 | 409 |
| POST | /quizzes/{quizId}/attempts | Enr; creates or resumes | 201 / 200 | 409 `WINDOW_CLOSED`, `NO_ATTEMPT_LEFT` |
| GET | /attempts/{attemptId} | Self or Own | 200 | 404 |
| PUT | /attempts/{attemptId}/answers/{questionId} | Self, in progress | 200 | 409 `DEADLINE_PASSED`, `ATTEMPT_ENDED` |
| POST | /attempts/{attemptId}/exits | Self, idempotent by `clientEventId` | 200 | 409 |
| POST | /attempts/{attemptId}/heartbeat | Self | 200 | 409 |
| POST | /attempts/{attemptId}/submit | Self, idempotent | 200 | 404 |
| GET | /quizzes/{quizId}/attempts | Own | 200 | 404 |
| POST | /quizzes/{quizId}/grants | Own | 201 | 422 |
| PATCH | /attempts/{attemptId}/grades/{questionId} | Own; `reason` required after deliberation | 200 | 409, 422 |
| GET | /attempts/{attemptId}/revisions | Own | 200 | 404 |
| POST | /quizzes/{quizId}/deliberate | Own | 200 | 409 `UNGRADED`, `IN_PROGRESS` |
| POST | /quizzes/{quizId}/release | Own | 200 | 409 |
| GET | /attempts/{attemptId}/result | Self when released, or Own | 200 | 403 `NOT_RELEASED` |
| GET | /quizzes/{quizId}/stats | Own, per question and student | 200 | 404 |
| GET | /quizzes/{quizId}/leaderboard | Own; Enr if enabled and released | 200 | 403 |
| POST | /quizzes/{quizId}/live-sessions | Own, choice only | 201 | 409 |
| POST | /live-sessions/join | Enr, body `pin` | 200 | 404, 429 |
| GET | /live-sessions/{sessionId} | host or participant | 200 | 404 |

## 3. SHOULD endpoints
All `/admin` routes are limited to the administrator's own school. `/super` routes are limited to `super_admin` and never return quizzes, answers, grades or sheets.

| Method | Path | Role / rule | OK |
|---|---|---|---|
| GET, POST | /admin/programmes, /admin/cohorts, /admin/classes | A | 200 / 201 |
| PATCH, DELETE | /admin/{resource}/{id} | A | 200 / 204 |
| PUT | /admin/grading-scale | A | 200 |
| POST, GET | /admin/invitations | A | 201 / 200 |
| POST | /invitations/accept | P, single-use token | 201 |
| PUT | /admin/teachers/{teacherId}/assignments | A | 200 |
| GET, PUT | /courses/{courseId}/gradebook | Own | 200 |
| PUT | /courses/{courseId}/components/{componentId}/grades/{studentId} | Own | 200 |
| GET | /courses/{courseId}/grade-sheet | Own, draft view | 200 |
| POST | /courses/{courseId}/grade-sheets | Own, transmit new version | 201 |
| GET | /grade-sheets/{sheetId} | Own, A, Enr (published list) | 200 |
| GET | /grade-sheets/{sheetId}/pdf | same | 200 |
| GET | /admin/grade-sheets | A | 200 |
| GET, POST | /super/schools | SA | 200 / 201 |
| PATCH | /super/schools/{schoolId} | SA, rename, `status` active or suspended | 200 |
| POST | /super/schools/{schoolId}/admins | SA, invite a school administrator | 201 |
| GET | /super/users?search=&role=&schoolId= | SA | 200 |
| PATCH | /super/users/{userId} | SA, `isActive`; not for another SA | 200 |
| GET | /super/stats | SA, counters only | 200 |
| GET | /super/audit-logs?actorId=&action=&from=&to= | SA, read-only | 200 |
| POST | /attempts/{attemptId}/appeals | Self, before deadline | 201 |
| GET | /appeals | S: Self, T: Own | 200 |
| PATCH | /appeals/{appealId} | Own | 200 |

## 4. Key payloads
Start attempt response:
```json
{ "data": { "id": "a1", "deadline": "2026-12-10T09:30:00Z", "serverTime": "2026-12-10T09:00:00Z",
  "focus": { "mode": "warning", "maxExits": 3, "maxAbsenceSec": 10 }, "exitCount": 0,
  "questions": [ { "id": "q1", "type": "single", "text": "...", "points": 200,
    "options": [ { "id": "o1", "text": "..." } ] } ],
  "answers": [] } }
```
Save answer: `{ "selectedOptionIds": ["o1"], "clientSeq": 4 }` or `{ "text": "...", "clientSeq": 5 }`.
Report exit: `{ "clientEventId": "uuid", "leftAt": "...", "durationMs": 4200 }` returns `{ "data": { "exitCount": 2, "remaining": 1, "ejected": false } }`.

## 5. WebSocket events (namespace `/live`)
Handshake requires a valid access token; the server checks membership on every event.

| Direction | Event | Payload |
|---|---|---|
| client to server | `session:join` | sessionId |
| host to server | `session:next`, `session:end` | sessionId |
| student to server | `answer:submit` (acknowledged) | sessionId, questionId, selectedOptionIds |
| server to all | `session:state` | status, participants count, current question |
| server to all | `question:open` | question without solution, closesAt |
| server to host | `answer:count` | number received |
| server to all | `question:closed` | correctOptionIds, distribution |
| server to all | `leaderboard:update` | ranking |
| server to caller | `error` | code, message |
