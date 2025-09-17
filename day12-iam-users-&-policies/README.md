# Day 12 — IAM Users & Policies

## 📖 Overview
Today’s focus: **IAM Users & Policies**.  
You’ll create IAM users and groups, attach **least-privilege** managed/inline policies, and enforce security controls like **MFA-required** access — all with Terraform.

## 🎯 Learning Goals
- Model **users, groups, and policies** in Terraform.  
- Write **least-privilege** policies with `aws_iam_policy_document`.  
- Attach **managed** and **inline** policies to groups/users.  
- Enforce **MFA** with a deny-without-MFA guardrail.  
- Output safe credentials (optional) and clean up responsibly.

## 🛠️ Lab Setup & Tasks
```bash
terraform -chdir=terraform init
terraform -chdir=terraform plan -var="user_name=devops.student" -var="target_bucket_arn=arn:aws:s3:::my-logs-bucket"
terraform -chdir=terraform apply -auto-approve -var="user_name=devops.student" -var="target_bucket_arn=arn:aws:s3:::my-logs-bucket"
```

## 💡 Challenge
- Add a **permissions boundary** that limits all custom users to `ReadOnlyAccess`.  
- Add a **login profile** with password reset + MFA enforcement.  
- Expand S3 access to multiple buckets or prefixes.

## ⚠️ Security Notes
- Prefer **federated** or **role-based** access.  
- Delete test users/keys after use.  
