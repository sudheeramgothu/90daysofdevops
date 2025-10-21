# Day 39 — Parallel Stages

## 📖 Overview
Run lint, unit, integration, and e2e tests in **parallel** in a Jenkins Declarative Pipeline. Publish JUnit, stash/unstash workspace, and optionally guard deploy with a **lock**.

## 🎯 Learning Goals
- Build parallel branches with `parallel {}`
- Aggregate JUnit across branches
- Use `stash/unstash` to share files
- (Optional) Serialize shared env with `lock`

## 📌 Commit
git add day39-parallel-stages
git commit -m "day39: Jenkins parallel stages with junit aggregation and optional lock"
git push
