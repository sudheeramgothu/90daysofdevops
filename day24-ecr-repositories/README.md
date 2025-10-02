# Day 24 — Amazon ECR: Repositories, Lifecycle, and IAM (Terraform)

## 📖 Overview
Today’s focus: **Amazon Elastic Container Registry (ECR)** with production-minded defaults:
- Private **repositories** (immutable tags optional)
- **Lifecycle policies** for pruning old/untagged images
- **Image scanning on push**
- **Encryption at rest** (KMS optional)
- Minimal **IAM policies** for CI (push) and runtime (pull)
- (Optional) **Cross-account read** via repository policy

This prepares the ground for upcoming CI/CD and containerized workloads.

---

## 🎯 Learning Goals
- Create and govern ECR repositories per app/environment.
- Enforce **image hygiene** with lifecycle rules.
- Provide **least-privilege** JSON policies for CI (push) and runtime (pull).
- (Optional) Allow **cross-account** read access safely.

---

## 🛠️ Lab Setup & Tasks

```bash
# 1) Initialize
terraform -chdir=terraform init

# 2) Plan (edit variables as needed)
terraform -chdir=terraform plan   -var='env=dev'   -var='repositories=["api","worker"]'   -var='untagged_keep_count=5'   -var='tagged_keep_count=10'

# 3) Apply
terraform -chdir=terraform apply -auto-approve ...

# 4) Use from CI (example)
# Login (GitHub Actions/Jenkins agent) and push an image:
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account>.dkr.ecr.us-east-1.amazonaws.com

# Build & push
export REPO=<account>.dkr.ecr.us-east-1.amazonaws.com/dev-api
docker build -t ${REPO}:v1 .
docker push ${REPO}:v1
```

---

## 💡 Challenge
- Add **per-repository** lifecycle rules (e.g., keep 50 prod tags, 10 dev tags).
- Add a **registry scanning configuration** (enhanced scans) and set **severity thresholds** for promotion.
- Wire a **cross-account** reader principal (prod account) via `cross_account_reader_arns`.

---

## ✅ Checklist
- [ ] Repos created and visible under **ECR → Repositories**  
- [ ] **Scan on push** turned on  
- [ ] Lifecycle policy prunes **untagged** & stale **tagged** images  
- [ ] CI has **push** rights, runtime has **pull** rights

---

## 📌 Commit
```bash
git add day24-ecr-repositories
git commit -m "day24: ECR repos with lifecycle, scan-on-push, and IAM policies for push/pull"
git push
```
