# Day 14 — VPC, Subnets, IGW, NAT

## 📖 Overview
Today’s focus: **AWS VPC networking** with Terraform — we’ll build a production-style VPC with **public and private subnets across multiple AZs**, an **Internet Gateway** for egress on public subnets, and **NAT Gateways** for private subnets.

---

## 🎯 Learning Goals
- Model a **VPC** with CIDR planning and AZ-aware subnetting.  
- Configure **public** (IGW) vs **private** (NAT) routing.  
- Create **route tables** and **associations** per subnet.  
- Parameterize the design (AZ count, single-NAT vs per-AZ NAT).  

---

## 🛠️ Lab Setup & Tasks

```text
1) Initialize & plan
   terraform -chdir=terraform init
   terraform -chdir=terraform plan -var="vpc_cidr=10.0.0.0/16" -var="az_count=2"

2) Apply
   terraform -chdir=terraform apply -auto-approve -var="vpc_cidr=10.0.0.0/16" -var="az_count=2"

3) Inspect
   terraform -chdir=terraform output

4) (Optional) Try single NAT for cost savings
   terraform -chdir=terraform apply -auto-approve -var="single_nat=true"

5) Destroy when done
   terraform -chdir=terraform destroy -auto-approve
```

---

## 💡 Challenge
- Switch to **per‑AZ NAT** (set `single_nat=false`) and verify each private subnet routes to its AZ’s NAT.  
- Add **VPC endpoints** (e.g., S3, DynamoDB) for private subnets.  
- Add **Network ACLs** with explicit rules for `logs/` ingestion hosts only.  

---

## ✅ Checklist
- [ ] VPC + subnets created across AZs  
- [ ] Public route (0.0.0.0/0) → IGW, Private route(s) → NAT  
- [ ] NAT choice validated (`single_nat` vs per‑AZ)  
- [ ] (Optional) Endpoints/NACLs added  

---

## 📌 Commit
```bash
git add day14-vpc-subnets-igw-nat
git commit -m "day14: VPC with multi-AZ public/private subnets, IGW, and NAT (single/per-AZ)"
git push
```
