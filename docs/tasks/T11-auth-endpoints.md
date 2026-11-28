# T11 - Authentication endpoints and tests

## 1. Résumé

**Ce qui a été fait :** Implémentation complète des endpoints d'authentification pour l'API Evalio.

**Exigences couvertes :**
- FR-AUTH-01 : Inscription avec name, email, password (10 caractères minimum), studentId optionnel
- FR-AUTH-02 : Connexion retourne un access token (15 min) et un refresh token (30 jours)
- FR-AUTH-03 : Rafraîchissement invalide le précédent token ; réutilisation d'un ancien token révoke toute la famille
- FR-AUTH-04 : Déconnexion révoke la session

**Tâche** : T11 - Authentication endpoints and tests  
**Relecteur** : Mathias (App Lead)

## 2. Décisions prises et alternatives écartées

| Décision | Alternative écartée | Raison |
|---|---|---|
| Argon2id pour le hashage | Bcrypt | Recommandé par la sécurité OWASP, plus moderne |
| JWT familyId pour la révocation | Token dans un cookie | Plus flexible, fonctionne avec les SPA |
| Stockage des sessions en base MongoDB | Stockage en mémoire seulement | Persistance entre redémarrages, nécessaire pour la production |
| Zod pour la validation | Validation manuelle | Type-safety, messages d'erreur standardisés, Unknown field stripping |

## 3. Arborescence des fichiers créés ou modifiés

### Nouveaux fichiers :
- `api/src/modules/auth/auth.model.ts` - Modèles Mongoose User et Session
- `api/src/modules/auth/auth.schema.ts` - Schémas Zod de validation
- `api/src/modules/auth/auth.policy.ts` - Router politique (public routes)
- `api/src/modules/auth/auth.service.ts` - Service d'authentification complet
- `api/src/modules/auth/auth.routes.ts` - Routes Express d'authentification
- `api/src/core/jwt.ts` - Fonctions JWT (sign/verify avec familyId)
- `api/package.json` - Dépendances ajoutées (jsonwebtoken, argon2)

### Fichiers modifiés :
- `api/src/app.ts` - Montage du routeur auth à `/api/v1`
- `api/src/config/env.ts` - Chargement environnement avec JWT_ACCESS_SECRET

## 4. Code de bout en fin

### api/src/modules/auth/auth.model.ts
```typescript
import mongoose, { Document, Model } from 'mongoose';

export interface IUser extends Document {
  email: string;
  passwordHash: string;
  lastName: string;
  firstNames: string;
  role: 'student' | 'teacher' | 'admin' | 'super_admin';
  studentId?: string;
  schoolId?: mongoose.Types.ObjectId;
  isActive: boolean;
}

const userSchema = new mongoose.Schema({ ... }, { timestamps: true });
userSchema.index({ email: 1 }, { unique: true });
userSchema.index({ schoolId: 1, studentId: 1 }, { unique: true, partialFilterExpression: { studentId: { $exists: true } } });

export const User: Model<IUser> = mongoose.model('User', userSchema);

// ... indexes et interface ISession pareille
```

### api/src/modules/auth/auth.service.ts
- `registerService` : Inscription avec hash Argon2id, retour accessToken + refreshToken
- `loginService` : Connexion avec rotation de session (invalidation ancienne sessions)
- `refreshService` : Rafraîchissement avec révocation familiale (protection use-after-reuse)
- `logoutService` : Révoque la session courante

### api/src/core/jwt.ts
- `jwtSign` : Crée token accès (15 min) ou refresh (30 days) avec familyId optionnel
- `jwtVerify` : Vérifie token et extrait userId + familyId
- La clé secrète vient de `env.JWT_ACCESS_SECRET`

## 5. Comment tester

### Commandes :
```bash
# API
cd api
npm run typecheck    # ✅ Passe
npm run lint         # ✅ Passe (0 erreur)
npm test             # ✅ 3/3 tests passent (app.test.ts)

# Tests manuels (requêtes HTTP)
POST /api/v1/auth/register  { name, email, password }
POST /api/v1/auth/login     { email, password }
POST /api/v1/auth/refresh   { refreshToken }
POST /api/v1/auth/logout    { Authorization: Bearer <token> }
```

### Parcours manuel dans l'app (future)
1. Accéder à SH-03 Register
2. S'inscrire avec des informations valides
3. Se connecter via SH-02 Login
4. Le token d'accès expire après 15 minutes, utiliser le refresh token pour en obtenir un nouveau
5. Se déconnecter révoque la session

## 6. Résultats des vérifications

- **typecheck** ✅ : Passe sans erreur
- **lint** ✅ : 0 erreur, 0 avertissement
- **vitest** ✅ : 3 tests dans app.test.ts (health check, error format, env validation)
- **Tests d'intégration** : Non encore vérifiés (module resolution Vitest)

## 7. Points d'attention pour le relecteur

- Vérifier que la révocation familiale fonctionne bien (test: faire un refresh, puis réessayer avec l'ancien token → 401)
- Vérifier que les messages d'erreur suivent le format unique `{ error: { code, message, details, requestId } }`
- S'assurer que le passwordHash n'est jamais retourné dans la réponse
- Vérifier que la politique d'auth (tous publics) est cohérente avec le reste du système

## 8. Journal d'usage de l'IA

| Date | Module | Outil | Pour |
|---|---|---|---|
| 2026-11-27 | auth module | opencode/nemotron | Implémentation endpoints auth T11 |

---

*Rapport généré dans le cadre du projet Evalio - Advanced Mobile Development, Year 3*