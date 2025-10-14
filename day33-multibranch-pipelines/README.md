
# Day 33 — Jenkins Multibranch Pipelines

## 📖 Overview
Today’s focus: **Jenkins Multibranch Pipelines** — automatic discovery of branches & PRs and per‑branch Jenkinsfile execution.  
You’ll set up a multibranch job, add branch/PR conditions, and use small helper scripts for build/test/package. Works great with GitHub and Bitbucket.

---

## 🎯 Learning Goals
- Configure a **Multibranch Pipeline** that scans your Git repo.
- Use **branch & PR conditions** with `when {}` and `changeRequest()`.
- Build different behaviors for **feature branches**, **PRs**, **main**, and **tags**.
- Generate jobs via **Job DSL seed** (repeatable Jenkins configuration).

---

## 🛠️ Tasks

1) **Create a Multibranch Pipeline job**
   - Jenkins → *New Item* → **Multibranch Pipeline** → Name: `90daysofdevops`
   - *Branch Sources*: Git → Repository URL: `https://github.com/<your-org>/<repo>.git`
   - Credentials: (if private)
   - *Build Configuration*: by Jenkinsfile (default path: `Jenkinsfile`)
   - *Scan Multibranch Pipeline Triggers*: every 1–5 minutes (demo) or cron.
   - Save. Jenkins will discover branches & PRs and run the right Jenkinsfile logic.

2) **Use the provided Jenkinsfiles**
   - `Jenkinsfile` — single file with smart `when` rules: 
     - **PRs**: run lint/test only
     - **Branches**: build + test + optionally image tag `branch-SHORTSHA`
     - **main**: full build + image push + deploy (simulated)
     - **tags (v*)**: release build (e.g., `v1.2.3`)
   - (Optional) Use `Jenkinsfile.pr.groovy` / `Jenkinsfile.release.groovy` if you prefer dedicated files per flow.

3) **Run the seed job (optional)**
   - Install **Job DSL** plugin.
   - Create a Freestyle job named `seed-multibranch`.
   - Add *Process Job DSLs*: `jenkins/seed-jobs/Multibranch.groovy`
   - Build the job → it creates/updates a multibranch job pointing to your repo.

4) **Webhook**
   - Add a webhook on GitHub: **Settings → Webhooks → Add**  
     - Payload URL: `https://<jenkins>/github-webhook/`  
     - Content type: `application/json`  
     - Events: *Just the push event* (and Pull Request events if using GitHub App integration)

---

## 💡 Challenge
- Add a **quality gate** stage (e.g., `tfsec`, `checkov`, `trivy`).  
- Publish **JUnit** and **coverage** results per branch.  
- Promote images to `:stable` when building tags.  
- Add a **shared library** step to standardize Docker build & push across repos.

---

## 📌 Commit
```bash
git add day33-jenkins-multibranch-pipelines
git commit -m "day33: Jenkins Multibranch Pipelines (branch/PR conditions, Job DSL seed, helper scripts)"
git push
```
