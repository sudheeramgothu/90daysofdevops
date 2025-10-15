# Day 34 — Jenkins Shared Libraries

## 📖 Overview
Today’s focus: **Jenkins Shared Libraries** — centralize reusable pipeline steps and keep Jenkinsfiles clean.

## 🎯 Learning Goals
- Structure a Jenkins Global Pipeline Library (`vars/` + optional `src/`).
- Call library steps via `@Library('devopslib@main')`.
- Handle **AWS ECR** auth and **Docker build/push** safely.
- Send **Slack** notifications from a reusable helper.

## 🛠️ Tasks
1) Publish the library (point Jenkins Global Pipeline Libraries to this path/repo).
2) Use it in a Jenkinsfile (`Jenkinsfile-example.groovy`).
3) Run a build and verify the results.

## 💡 Challenge
- Add a `kubeDeploy()` step to apply a manifest with a Kubeconfig credential.
- Extend `dockerBuildPush` for multi-arch builds and SBOM export.
- Add a `withVaultSecret` helper to fetch secrets on demand.

## 📌 Commit
```bash
git add day34-jenkins-shared-libraries
git commit -m "day34: Jenkins Shared Libraries (dockerBuildPush, withECRLogin, slackNotify, hello)"
git push
```
