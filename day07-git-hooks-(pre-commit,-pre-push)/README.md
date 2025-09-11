# Day 7 — Git Hooks (pre-commit, pre-push)

## 📖 Overview
Today’s focus: **Git Hooks (pre-commit, pre-push)**.  
We’ll automate checks and actions using Git’s built-in hook system to enforce standards before commits and pushes.

---

## 🎯 Learning Goals
- Understand what Git hooks are and how they are used.  
- Create a **pre-commit hook** to enforce coding standards (linting, formatting, or tests).  
- Create a **pre-push hook** to block pushes if tests fail.  
- Learn how to share hooks across a team using `core.hooksPath`.  

---

## 🛠️ Lab Setup & Tasks

```text
1. Initialize a Git repo
   git init git-hooks-lab && cd git-hooks-lab

2. Pre-commit hook
   .git/hooks/pre-commit
   ✔ Run shell script to check for trailing spaces or run `black --check` on Python files.

3. Pre-push hook
   .git/hooks/pre-push
   ✔ Run unit tests before allowing push; block push if tests fail.

4. Make hooks executable
   chmod +x .git/hooks/pre-commit .git/hooks/pre-push

5. Test the workflow
   - Try committing a file with trailing spaces (should be blocked).
   - Fix and re-commit (should pass).
   - Push with failing tests (blocked).
   - Push with passing tests (success).
```

---

## 💡 Challenge
- Add a hook to **reject commits to `main` directly** (force using feature branches).  
- Integrate `gitleaks` in pre-commit to block accidental secret commits.  
- Share hooks across projects by setting a global hooks directory:
  ```bash
  git config --global core.hooksPath ~/.git-hooks
  ```

---

## 📌 Commit
Once complete, commit your progress:
```bash
git add day07-git-hooks
git commit -m "day07: Git hooks — pre-commit linting & pre-push testing"
git push
```
