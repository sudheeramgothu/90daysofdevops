# Day 27 — AWS Backup Plans (Terraform)

## 📖 Overview
Today’s focus: **AWS Backup** with Terraform. You’ll create a **Backup Vault**, a **Backup Plan** with one or more **rules** (daily/weekly/monthly), set **lifecycle** (cold storage + retention), optionally **copy** to a **secondary region**, and select resources by **tags** or **explicit ARNs**. We’ll also include **Vault Lock** (WORM) and **SNS notifications**.

---

## 🎯 Learning Goals
- Model **vaults**, **plans**, and **selections** for EC2/EBS, RDS, EFS, and DynamoDB.
- Configure **lifecycle** (transition to cold storage, delete after) and **cross‑region copies**.
- Enforce tamper‑resistance via **Backup Vault Lock**.
- Use **tag-based selection** for environment-level coverage.

---

## 🛠️ Lab Setup & Tasks

```bash
# 1) Initialize
terraform -chdir=terraform init

# 2) Plan (tune variables)
terraform -chdir=terraform plan   -var='name_prefix=day27'   -var='selection_tag_key=Backup'   -var='selection_tag_value=true'

# 3) Apply
terraform -chdir=terraform apply -auto-approve

# 4) Opt-in resources
# Tag resources you want protected:
#   Key=Backup, Value=true  (or pass explicit ARNs via var.resource_arns)
```

**What gets protected?**  
Everything matching your **tag filter** (default `Backup=true`) or any **explicit ARNs** you pass. The daily rule runs at `03:00 UTC` with 35‑day retention by default.

---

## 💡 Challenge
- Add a **monthly** rule with 12‑month retention for long-term snapshots.
- Enable **cross‑region copy** to a DR region.
- Turn on **SNS notifications** for backup/restore events.
- Enable **Vault Lock** with a **min/max retention** policy.

---

## ✅ Checklist
- [ ] Vault exists and plan shows **compliant** selections  
- [ ] Recovery points visible under AWS Backup → **Protected resources**  
- [ ] (Optional) **Vault Lock** applied (be careful: some settings are **irrevocable** after lock)  
- [ ] (Optional) **Cross‑region copy** recovery points present in target region

---

## 📌 Commit
```bash
git add day27-aws-backup-plans
git commit -m "day27: AWS Backup — vault, plan (rules), tag-based selection, optional copy + vault lock + SNS"
git push
```
