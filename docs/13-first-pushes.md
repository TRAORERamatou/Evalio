# Evalio - First Pushes

For Mathias (task T01). The repository `TRAORERamatou/Evalio` was empty on 26 November 2026.

## 1. Before you start
- [ ] You have write access to the repository (the owner, Ramatou, adds collaborators).
- [ ] Installed: Git, Node.js 24, Flutter stable with Android toolchain; optionally GitHub CLI (`gh`).
- [ ] `git config user.name` and `user.email` match your GitHub account.
- [ ] With an HTTPS token, it may write workflows (`workflow` scope, or the Workflows permission).

## 2. Prepare
```bash
git clone https://github.com/TRAORERamatou/Evalio.git
unzip evalio-starter.zip                 # creates evalio-starter/
cp -a evalio-starter/. Evalio/
cd Evalio
(cd api && npm ci && npm run typecheck && npm run lint && npm test)
bash scripts/bootstrap-app.sh            # creates app/, then formats, analyzes, tests
git status                               # check: no .env, node_modules, build or spreadsheet
```
Stop and fix any failure before committing.

## 3. Commit and push
```bash
git switch -c main 2>/dev/null || git switch main

git add .gitignore .gitattributes .editorconfig .nvmrc README.md
git commit -m "chore: initialise repository"

git add docs
git commit -m "docs: add project documentation v0.1"

git add api
git commit -m "chore(api): add Express and TypeScript skeleton with health check"

git add app
git commit -m "chore(app): add Flutter skeleton"

git add .github scripts AGENTS.md CLAUDE.md
git commit -m "ci: add pipeline, templates, scripts and agent rules"

git status                               # must be clean
git push -u origin main
```

## 4. Repository settings (owner)
1. Check that the CI jobs `api`, `app` and `secrets` are green in **Actions**.
2. **Settings > Collaborators:** add the four other members and the instructor (email given in the Project Book).
3. **Settings > Branches or Rules**, for `main`: require a pull request, 1 approval, status checks `api`, `app`, `secrets`; block force pushes. Availability on private repositories depends on the GitHub plan.
4. Create a Project board with columns Todo, In progress, In review, Done.

The Project Book forbids direct pushes to `main` after milestone 1; protecting it now builds the habit.

## 5. Issues and tag
```bash
gh auth login
bash scripts/create-issues.sh            # once only
git tag -a m0 -m "Milestone 0: team and topic"
git push origin m0
```
Add the issues to the board and put its link in `docs/10-project-plan.md` through your first pull request. Post the short progress note (done, late, blocked).

## 6. Right after
- Each member clones, runs both test suites and opens a first small pull request (for example signing the charter or completing meeting notes). The history must show **everyone** over the whole period.
- Add `.github/CODEOWNERS` once all GitHub usernames are known.

## 7. If something goes wrong
| Problem | Action |
|---|---|
| Push rejected, remote has commits | `git pull --rebase`, check, push again |
| Secret committed | Revoke it immediately; removing the file is not enough |
| `app` job fails on format | `cd app && dart format .`, commit |
