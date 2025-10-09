# Day 30 — AWS Organizations & Service Control Policies (SCPs)

## 📖 Overview
Today’s focus: **AWS Organizations** guardrails with **Service Control Policies (SCPs)**. You’ll bootstrap (or connect to) an Organization, create **Organizational Units (OUs)**, and attach **opinionated SCPs** that enforce baseline security and region restrictions across accounts.

> ⚠️ **Important**: Many Organizations operations must be run from the **management (payer) account** with elevated permissions. Some actions are **destructive** or **restrictive**. Test in a sandbox **org** first.

---

## 🎯 Learning Goals
- Understand **root**, **OU**, and **account** hierarchy.
- Create and attach **SCPs** (deny by default-allow model) for guardrails:
  - **DenyLeavingOrg** — prevent accounts leaving the org
  - **DenyRootAccessKeys** — block creating access keys for root
  - **RequireMFARoot** — deny most actions if root user MFA not enabled
  - **DenyStopCloudTrail** — block disabling CloudTrail/GuardDuty/SecurityHub
  - **DenyPublicS3** — deny S3 Public* APIs at org scope
  - **AllowOnlyListedRegions** — limit actions to approved regions
- Apply **different SCP sets per OU** (e.g., `Sandbox`, `Prod`).

---

## 🛠️ Lab Setup & Tasks

```bash
# 1) Initialize
terraform -chdir=terraform init

# 2) Plan (adjust org/OU names and allowed regions)
terraform -chdir=terraform plan   -var='org_feature_set=ALL'   -var='allowed_regions=["us-east-1","us-west-2"]'   -var='enable_prod_ou=true' -var='enable_sandbox_ou=true'

# 3) Apply
terraform -chdir=terraform apply -auto-approve

# 4) Attach accounts to OUs (if not already)
# Either move existing accounts into the OU in console, or use aws_organizations_account + aws_organizations_move_account.
```

**Notes**
- SCPs do **not** grant permissions; they set the **maximum permissions boundary**. IAM roles/users still need explicit permissions.
- The **Root** entity can have SCPs, which then apply to everything underneath unless explicitly excluded.
- Be careful with **region restriction** SCP — keep at least one region allowed for management.

---

## 💡 Challenge
- Add an **exception SCP** for a specific account (attach a less restrictive SCP).
- Create a **DenyDataDestruction** SCP for destructive actions (e.g., `s3:DeleteBucket`, `kms:ScheduleKeyDeletion`, `ec2:TerminateInstances`) with break‑glass tags.
- Manage **Tag Policies** and **AI services opt‑out** (AWS policy types) for FinOps/Governance.

---

## ✅ Checklist
- [ ] Organization active with **ALL features**
- [ ] `Sandbox` and/or `Prod` OU created
- [ ] SCPs attached at **Root and OU** levels
- [ ] Accounts in OU inherit guardrails (verify via **Organizations → Policies**)

---

## 📌 Commit
```bash
git add day30-organizations-and-scps
git commit -m "day30: AWS Organizations + SCPs — baseline guardrails for sandbox/prod with region allow list"
git push
```
