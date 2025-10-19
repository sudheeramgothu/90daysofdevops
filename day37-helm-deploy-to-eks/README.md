# Day 37 — Helm Deploy to EKS

## 📖 Overview
Deploy a containerized app to **Amazon EKS** using **Helm**. You'll use `helm upgrade --install`, parameterize image/tag/replicas, and practice rollback.

## 🎯 Learning Goals
- Understand Helm chart structure and values.
- Deploy with `helm upgrade --install` and rollback with `helm rollback`.
- Authenticate to EKS with `aws eks update-kubeconfig`.
- Use Jenkins to automate deploy.

## 🛠️ Tasks
1) Inspect the chart in `chart/myapp/`.
2) Run Jenkins with your cluster/image params.
3) Verify rollout and service.
4) Try rollback.

## 📌 Commit
git add day37-helm-deploy-eks
git commit -m "day37: Helm deploy to EKS (chart + Jenkinsfile + scripts)"
git push
