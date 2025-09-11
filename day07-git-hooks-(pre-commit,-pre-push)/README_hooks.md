# Git Hooks Scripts

- `pre-commit`: Blocks commits with trailing spaces or badly formatted Python code (uses black if installed).
- `pre-push`: Runs pytest before pushing; blocks push if tests fail.
- `challenge-pre-commit`: Optional hook that blocks direct commits to `main`/`master`.

## Install

Copy scripts into `.git/hooks/` inside your repo:

```bash
cp pre-commit .git/hooks/pre-commit
cp pre-push .git/hooks/pre-push
chmod +x .git/hooks/pre-commit .git/hooks/pre-push
```

For the challenge branch restriction:

```bash
cp challenge-pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```
