# Day 13 — S3 Bucket + Versioning & Lifecycle

## 📖 Overview
Today’s focus: **Amazon S3 with Versioning & Lifecycle** using Terraform.  
You’ll provision an S3 bucket with **server-side encryption**, **public access block**, **versioning**, and **lifecycle rules** (transition/expiration/noncurrent/abort-incomplete).

---

## 🎯 Learning Goals
- Enable **bucket versioning** and understand object/version behavior.  
- Configure **lifecycle rules** for cost optimization and hygiene: transitions to IA/Glacier, expiration, noncurrent cleanup, and abort incomplete uploads.  
- Use **prefix/tag filters** to scope lifecycle behavior (e.g., `data/` vs `logs/`).  
- Apply **security** best practices: encryption + block public access.  

---

## 🛠️ Lab Setup & Tasks

```text
1) Initialize & plan
   terraform -chdir=terraform init
   terraform -chdir=terraform plan -var="bucket_name_prefix=devopsday13-demo"

2) Apply
   terraform -chdir=terraform apply -auto-approve -var="bucket_name_prefix=devopsday13-demo"

3) (Optional) Put and version objects
   aws s3 cp ./sample.txt s3://<bucket-name>/data/sample.txt
   aws s3 cp ./sample.txt s3://<bucket-name>/logs/app.log

4) Inspect lifecycle & versions
   aws s3api list-object-versions --bucket <bucket-name>

5) Destroy when done
   terraform -chdir=terraform destroy -auto-approve
```

---

## 💡 Challenge
- Add a **tag-based** lifecycle rule (e.g., `{"class":"archive"}` → transition to Glacier Deep Archive at 30 days).  
- Wire an **access log bucket** and enable **server access logging** for the main bucket.  
- Switch encryption to **SSE-KMS** with a customer-managed key.  

---

## ✅ Checklist
- [ ] Bucket created with encryption & public access blocked  
- [ ] Versioning enabled and verified with multiple object versions  
- [ ] Lifecycle transitions & expirations configured and planned  
- [ ] Optional: tag-based rule / access logging / SSE-KMS implemented  

---

## 📌 Commit
```bash
git add day13-s3-versioning-lifecycle
git commit -m "day13: S3 bucket with versioning + lifecycle (transition, expiration, noncurrent, abort)"
git push
```
