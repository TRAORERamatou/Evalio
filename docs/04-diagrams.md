# Evalio - Diagrams

## 1. Use cases
```mermaid
flowchart LR
  S([Student])
  T([Teacher])
  A([Administrator])
  SA([Super administrator])
  S --> J(Join course)
  S --> TQ(Take assessment)
  S --> LV(Play live quiz)
  S --> VR(View result)
  S --> AP(Appeal grade)
  T --> CC(Manage course and quiz)
  T --> HL(Host live quiz)
  T --> GR(Grade and deliberate)
  T --> HA(Handle appeals)
  T --> GS(Publish and transmit grade sheet)
  A --> ST(Manage structure and scale)
  A --> IV(Invite and assign teachers)
  A --> RC(Receive sheet versions)
  SA --> SC(Create and suspend schools)
  SA --> AI(Invite school administrators)
  SA --> AU(Deactivate accounts and read audit log)
```

## 2. Entity relationships
```mermaid
erDiagram
  SCHOOL ||--o{ PROGRAMME : has
  SCHOOL ||--o{ COHORT : has
  PROGRAMME ||--o{ CLASSGROUP : groups
  COHORT ||--o{ CLASSGROUP : groups
  SCHOOL ||--o{ USER : employs_or_enrols
  USER ||--o{ AUDITLOG : acts_in
  USER ||--o{ SESSION : owns
  USER ||--o{ COURSE : teaches
  CLASSGROUP |o--o{ COURSE : attends
  COURSE ||--o{ ENROLLMENT : has
  USER ||--o{ ENROLLMENT : joins
  COURSE ||--o{ QUIZ : contains
  QUIZ ||--o{ QUESTION : contains
  QUIZ ||--o{ ATTEMPT : receives
  USER ||--o{ ATTEMPT : makes
  ATTEMPT ||--o{ GRADEREVISION : history
  QUIZ ||--o{ LIVESESSION : runs
  ATTEMPT ||--o{ APPEAL : disputed_by
  COURSE ||--o| GRADEBOOK : defines
  COURSE ||--o{ GRADESHEET : publishes
```

## 3. Taking an assessment
```mermaid
sequenceDiagram
  actor S as Student
  participant A as App
  participant API
  participant DB
  S->>A: Accept rules and start
  A->>API: POST /quizzes/{id}/attempts
  API->>DB: check enrolment, window, attempts
  API-->>A: attempt, deadline, questions without solutions
  loop each answer
    S->>A: answer
    A->>A: show pending
    A->>API: PUT /attempts/{id}/answers/{questionId}
    API-->>A: saved, or refused then rollback
  end
  opt leaves the screen
    A->>API: POST /attempts/{id}/exits
    API-->>A: warning count or ejected
  end
  S->>A: submit
  A->>API: POST /attempts/{id}/submit
  API->>DB: finalise and auto-grade
  API-->>A: status and result if allowed
```

## 4. Attempt states
```mermaid
stateDiagram-v2
  [*] --> in_progress
  in_progress --> pending_grading: ends, has written answers
  in_progress --> graded: ends, choice only
  pending_grading --> graded: all written graded
  graded --> graded: revision
  graded --> [*]
```

## 5. Assessment states
```mermaid
stateDiagram-v2
  [*] --> draft
  draft --> published: publish
  published --> draft: unpublish if no attempt
  published --> closed: closesAt or manual close
  closed --> deliberated: all graded
  deliberated --> released: release, set appeal dates
  closed --> released: choice only, automatic
  released --> [*]
```
With immediate release, a student of a choice-only quiz sees their own score at submission, while the quiz stays `published`.

## 6. Focus decision
```mermaid
flowchart TD
  E[Exit reported] --> M{Mode}
  M -->|observe| L[Log only]
  M -->|strict| X[Eject]
  M -->|warning| C{Count reached limit or absence too long}
  C -->|yes| X
  C -->|no| W[Warn and show count]
  X --> F[Finalise with saved answers]
```

## 7. Live quiz
```mermaid
sequenceDiagram
  actor T as Teacher
  participant G as Server
  actor S as Students
  T->>G: create session
  G-->>T: PIN
  S->>G: join with PIN
  loop each question
    T->>G: next
    G-->>S: question and closing time
    S->>G: answer
    G-->>T: answer count
    G-->>S: correct option, distribution, ranking after close
  end
  T->>G: end
  G-->>S: final leaderboard
```

## 8. Grade appeal and revision
```mermaid
sequenceDiagram
  actor S as Student
  participant API
  actor T as Teacher
  actor A as Administration
  T->>API: release with appeal deadline and answer date
  S->>API: file appeal
  alt before deadline
    API-->>S: submitted
    T->>API: accept or reject, with reply
    opt accepted
      API->>API: append grade revision, mark sheet outdated
      T->>API: transmit new version
      API-->>A: sheet version n+1
    end
  else after deadline
    API-->>S: refused, contact the teacher
  end
```
