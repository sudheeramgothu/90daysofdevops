# Day 11 — Terraform Remote State

## 📖 Overview
Today’s focus: **Terraform Remote State**.  
You’ll bootstrap a secure remote backend on **S3 (+ DynamoDB locking)**, migrate local state to remote, and consume that state from another Terraform project via `terraform_remote_state`.

---

## 🎯 Learning Goals
- Create an **S3 backend** with **DynamoDB** for state locking.  
- Initialize and **migrate** local state to a remote backend.  
- Store state per environment/path using `key` conventions.  
- **Consume** remote state outputs from another Terraform project.  
- Use backend config files (`.hcl`) and safe automation scripts.

---

## 🛠️ Lab Setup & Tasks

```text
1) Bootstrap backend (S3 + DynamoDB)
   cd bootstrap
   terraform init
   terraform apply -auto-approve      -var="region=us-east-1"      -var="name_prefix=devopsday11"

   # Outputs will show: bucket, dynamodb_table, region

2) Prepare backend config for the app
   cd ../app
   # Edit env/backend.hcl (or use defaults printed in README)
   terraform init      -backend-config=env/backend.hcl

3) Apply app stack (writes state to S3)
   terraform apply -auto-approve

4) Consume remote state from another project
   cd ../consumer
   terraform init
   terraform plan  # reads outputs from app's remote state

5) (Optional) Migrate from local to remote
   - Comment out backend in app/main backend init (use local), apply, then re-init with remote to migrate.
```

---

## 💡 Challenge
- Add an **`environment` variable** (`dev`, `staging`, `prod`) and use it in the backend `key` to separate states.  
- Add **server-side encryption** with a custom **KMS key** (update S3 bucket + backend config).  
- Split `consumer` into **multiple modules** that read different remote states (e.g., networking/app).

---

## ✅ Checklist
- [ ] S3 bucket + DynamoDB table created for backend & locking  
- [ ] App stack state stored in S3 (confirmed by `terraform state list`)  
- [ ] `consumer` successfully read outputs via `terraform_remote_state`  
- [ ] Challenge implemented (env-based keys or KMS encryption)

---

## 🔐 Notes
- You must have valid AWS credentials (`aws configure`) with permissions to manage S3 and DynamoDB.  
- S3 bucket names are **global**; change `name_prefix` if creation fails due to name conflicts.  
- Never commit real **state files** or secrets.

---

## 📌 Commit
```bash
git add day11-terraform-remote-state
git commit -m "day11: Terraform remote state — S3 backend + DynamoDB locking + remote_state consumer"
git push
```
