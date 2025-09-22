# Day 16 — Security Groups & NACLs

## 📖 Overview
Today’s focus: **Security Groups (SGs) and Network ACLs (NACLs)** in a typical 3‑tier VPC. You’ll create SGs for **web** and **db** tiers and enforce subnet‑level controls via **public/private NACLs**.

This module **plugs into Day 14**. Bring your `vpc_id`, `public_subnet_ids`, and `private_subnet_ids`.

---

## 🎯 Learning Goals
- Model **stateful** SG rules (web ingress, DB from app/web tier, scoped SSH).  
- Configure **stateless** NACLs for public vs private subnets.  
- Understand precedence: SGs (instance‑level) vs NACLs (subnet‑level).  
- Parameterize allowed sources with variables for safe reuse.

---

## 🛠️ Lab Setup & Tasks
```text
1) Gather inputs from Day 14
   - vpc_id
   - public_subnet_ids (list)
   - private_subnet_ids (list)
   - vpc_cidr (CIDR, e.g., 10.0.0.0/16)

2) Init & Plan (replace vars)
   terraform -chdir=terraform init
   terraform -chdir=terraform plan      -var='vpc_id=vpc-0123'      -var='public_subnet_ids=["subnet-a","subnet-b"]'      -var='private_subnet_ids=["subnet-c","subnet-d"]'      -var='vpc_cidr="10.0.0.0/16"'      -var='ssh_allowed_cidr="YOUR.PUBLIC.IP/32"'

3) Apply
   terraform -chdir=terraform apply -auto-approve      -var='vpc_id=vpc-0123'      -var='public_subnet_ids=["subnet-a","subnet-b"]'      -var='private_subnet_ids=["subnet-c","subnet-d"]'      -var='vpc_cidr="10.0.0.0/16"'      -var='ssh_allowed_cidr="YOUR.PUBLIC.IP/32"'

4) (Optional) Verify
   - Launch a small EC2 in a public subnet with web_sg attached; try `curl http://EC2_PUBLIC_IP`.
   - Launch a DB EC2 in a private subnet with db_sg; from web EC2, `nc -zv DB_PRIVATE_IP 5432`.
   - Observe NACLs in console: public vs private rules.
```

---

## 💡 Challenge
- Add an **app_sg** and restrict DB ingress to **app_sg only** (remove web_sg access).  
- Add **egress‑only** rules on SGs (deny egress to RFC1918 outside `vpc_cidr`).  
- Harden NACLs by **denying SSH** except from a **bastion** subnet CIDR.

---

## ✅ Checklist
- [ ] SGs created: `web_sg` (80/443 world, 22 from your IP), `db_sg` (5432 from web/app tier)  
- [ ] NACLs created & associated: public vs private behavior  
- [ ] Tested path: web → db on 5432 works; outside traffic denied as expected

---

## 📌 Commit
```bash
git add day16-security-groups-nacls
git commit -m "day16: SGs (web/db) + public/private NACLs with Terraform"
git push
```
