# Day 9 — Makefiles for DevOps Automation

## 📖 Overview
Today’s focus: **Makefiles for DevOps Automation**.  
We’ll learn how to use `make` to automate repetitive DevOps tasks such as builds, tests, and deployments.

---

## 🎯 Learning Goals
- Understand Makefile syntax: targets, prerequisites, and recipes.  
- Automate builds, tests, and cleanup tasks.  
- Use variables and `.PHONY` targets.  
- Integrate with Docker and Python for DevOps workflows.  
- Learn how Makefiles improve reproducibility in CI/CD pipelines.  

---

## 🛠️ Lab Setup & Tasks

```text
1. View available targets
   make help

2. Run code linting (flake8)
   make lint

3. Run unit tests with pytest
   make test

4. Build and run Docker container
   make build
   make run

5. Cleanup generated files and containers
   make clean
```

---

## 💡 Challenge
- Extend the Makefile with a `deploy` target that simulates deployment (e.g., `echo "Deploying to staging"`).  
- Add a `coverage` target to run tests with coverage reporting.  
- Create environment-specific variables (`ENV=dev` vs `ENV=prod`).  

---



## 📌 Commit
Once complete, commit your progress:
```bash
git add day09-makefiles-devops-automation
git commit -m "day09: Makefiles for DevOps automation — lint, test, docker, cleanup"
git push
```
