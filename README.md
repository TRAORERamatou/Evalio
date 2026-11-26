# Evalio

Evalio is an Android platform for class quizzes and online assignments (topic T17 - QuizArena). Teachers assess with timed, server-enforced quizzes, grade them and deliver traceable results.

**Status:** design phase.

## Team
| Member | Role |
|---|---|
| Ramatou TRAORE | Team Lead |
| Israël Wa Nzambi NKUNA | API Lead |
| Zangafigué Mathias TRAORE | App Lead |
| KABORE Tegwende Odiane Elia Aziliz | Quality Lead |
| OUEDRAOGO Bowend-yaam Esther | Product / UX Lead |

## Links
Deployed API, release APK and demo video: to come. [Documentation](docs/README.md)

## Run locally
Needs Node.js 24, MongoDB (local or Atlas) and Flutter stable.
```bash
cd api && cp .env.example .env   # fill in the values
npm ci && npm run dev
# second terminal, Android emulator
cd app && flutter pub get && flutter run
```
On a real phone, pass `--dart-define=API_URL=<reachable API URL>`. Use HTTPS (release builds block plain HTTP).

### With Docker (API + MongoDB, no local install)
```bash
cp .env.docker.example .env      # set JWT_ACCESS_SECRET
docker compose up --build        # API on http://localhost:3000/api/v1/health
docker compose down -v           # stop and wipe the database
```
Source changes in `api/src` reload automatically. MongoDB runs as a single-node replica set (transactions). From a tool on your machine (Compass, mongosh) use `mongodb://127.0.0.1:27017/?directConnection=true`. The Flutter app still runs on the host or an emulator; the Android emulator reaches the API at `http://10.0.2.2:3000`.

Production image: `docker build --target runtime -t evalio-api api` (non-root, built-in health check, reads the same environment variables as `.env.example`).

## Endpoints
See the [API contract](docs/06-api-contract.md).

## Test accounts and known limitations
To come with the seed script (one account per role: student, teacher, admin, super administrator). Software cannot prevent the use of a second device.
