# T14 - Courses and enrolment endpoints

## 1. Résumé

**Ce qui a été fait :** Implémentation des endpoints Courses et Enrolment pour l'API Evalio.

**Exigences couvertes :**
- FR-CRS-01 : Teacher crée, édite et archive ses courses
- FR-CRS-02 : Chaque course a un join code aléatoire unique (8 caractères)
- FR-CRS-03 : Un student peut rejoindre une course une fois (index unique sur courseId+studentId)
- FR-CRS-04 : Listes de courses paginables et recherchables

**Tâche** : T14 - Courses and enrolment endpoints  
**Dépend de** : T10 (API core), T11 (auth)  
**Relecteur** : Israël (API Lead)

## 2. Arborescence des fichiers créés ou modifiés

### Nouveaux fichiers (api/src/modules/courses/) :
- `courses.model.ts` - Modèles Mongoose Course et Enrollment avec indexs
- `courses.schema.ts` - Schémas Zod : création, jointure, inscription
- `courses.policy.ts` - Router politique (authorization par route)
- `courses.service.ts` - Service complet (7 fonctions)
- `courses.routes.ts` - 7 routes Express

### Fichier modifié :
- `api/src/app.ts` - Montage du routeur courses à `/api/v1`

## 3. Code de bout en fin

### api/src/modules/courses/courses.model.ts
Modèles Mongoose avec indexes :
- `courseSchema.index({ code: 1 }, { unique: true })` - code unique
- `courseSchema.index({ teacherId: 1 })` - index teacher
- `enrollmentSchema.index({ courseId: 1, studentId: 1 }, { unique: true })` - inscription unique

### api/src/modules/courses/courses.service.ts
- `createCourseService` : Vérifie code unique, crée course
- `getCoursesService` : Liste paginée avec recherche textuelle
- `getCourseService` : Récupération course par ID (404 si introuvable)
- `updateCourseService` : Mise à jour avec vérification code unique
- `regenerateJoinCodeService` : Nouveau code 8 caractères
- `enrollStudentService` : Inscription avec vérifications (non archivé, non déjà inscrit)
- `getCourseMembersService` : Membres avec populate email/name
- `removeMemberService` : Soft delete (status = removed)

### api/src/modules/courses/courses.routes.ts
```typescript
coursesRouter.post('/', createCourseService);          // POST /courses
coursesRouter.get('/', getCoursesService);             // GET /courses
coursesRouter.get('/:id', getCourseService);           // GET /courses/:id
coursesRouter.patch('/:id', updateCourseService);      // PATCH /courses/:id
coursesRouter.post('/:id/join-code', regenerateJoinCodeService);  // POST /courses/:id/join-code
coursesRouter.post('/enrollments', enrollStudentService); // POST /enrollments
coursesRouter.get('/:id/members', getCourseMembersService); // GET /courses/:id/members
coursesRouter.delete('/:id/members/:studentId', removeMemberService); // DELETE /courses/:id/members/:studentId
```

## 4. Comment tester

### Commandes :
```bash
cd api
npm run typecheck    # ✅ Passe
npm run lint         # ✅ Passe (0 erreur)
npm test             # ✅ Tests app passent
```

### Requêtes de test (api/requests.http ou via VS Code Rest Client) :
```http
POST /api/v1/courses
Content-Type: application/json
{ "title": "Mathématiques", "code": "MD301" }

POST /api/v1/enrollments
Content-Type: application/json
{ "joinCode": "MD301" }

GET /api/v1/courses
GET /api/v1/courses/:id
DELETE /api/v1/courses/:id/members/:studentId
```

## 5. Points d'attention pour le relecteur

- Vérifier que l'index unique courseId+studentId empêche les inscriptions doubles
- Vérifier que les codes join sont uniques et font exactement 8 caractères
- Vérifier que course archivé rejette les inscriptions
- S'assurer que le teacherId est bien rattaché au user connecté (via auth middleware)
- Vérifier le format de réponse cohérent avec le reste de l'API

## 6. Journal d'usage de l'IA

| Date | Module | Outil | Pour |
|---|---|---|---|
| 2026-11-27 | courses module | opencode/nemotron | Implémentation endpoints Courses T14 |

---

*Rapport généré dans le cadre du projet Evalio - Advanced Mobile Development, Year 3*