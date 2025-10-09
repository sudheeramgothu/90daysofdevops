# Day 29 — AWS Config Rules, Conformance Packs & Remediation (Terraform)

## 📖 Overview
Today’s focus: **governance & compliance** with **AWS Config**. You’ll:
- Stand up **AWS Config** (recorder + delivery to S3)
- Enable a **set of managed rules** (S3 public access, SSH, encryption, password policy, RDS)
- (Optional) Deploy a **Conformance Pack** to group rules
- Wire **auto‑remediation** for an S3 rule via **SSM Automation**

---

## 🎯 Learning Goals
- Turn on AWS Config with a dedicated **S3 bucket** and **recorder**  
- Apply common **managed rules** for a baseline security posture  
- Use a **Conformance Pack** to roll up multiple rules with a single template  
- Attach **remediation** so drift can auto‑correct (guardrails, not handrails)

---

## 🛠️ Lab Setup & Tasks

```bash
# 1) Initialize
terraform -chdir=terraform init

# 2) Plan (tune variables)
terraform -chdir=terraform plan   -var='name_prefix=day29'   -var='enable_conformance_pack=true'   -var='enable_s3_public_block_remediation=true'

# 3) Apply
terraform -chdir=terraform apply -auto-approve

# 4) Test
# - Make an S3 bucket public (in a sandbox) and watch the rule go NON_COMPLIANT
# - If remediation is enabled, AWS Config will trigger SSM Automation to block public access
```

**Notes**
- The **recorder** captures all supported resources by default; you can scope via `resource_types` if needed.
- The **delivery channel** writes to a dedicated S3 bucket. Retain logs for audit.
- Conformance Packs are a convenient abstraction; rules can be managed either way.

---

## 💡 Challenge
- Add **organization‑wide** aggregation using **aws_config_configuration_aggregator** (multi‑account)  
- Attach additional **remediations** (e.g., disable public RDS snapshots)  
- Export **SNS** notifications from Config to SIEM via EventBridge → SNS

---

## ✅ Checklist
- [ ] Recorder **STARTED** and delivering to S3  
- [ ] Baseline rules show **COMPLIANT / NON_COMPLIANT** resources  
- [ ] (Optional) Conformance pack deployed and visible in console  
- [ ] Remediation executed for S3 public access violations

---

## 📌 Commit
```bash
git add day29-aws-config-rules
git commit -m "day29: AWS Config baseline — recorder, managed rules, conformance pack, SSM remediation"
git push
```
