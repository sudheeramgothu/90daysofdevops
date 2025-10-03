# Day 26 — Route53 DNS Records (CloudFront + optional ALB)

## 📖 Overview
Today’s focus: **Amazon Route 53 DNS** — creating public hosted zones and records that point your domains to **CloudFront** (Day 25) and optionally to an **ALB** (Day 18). We’ll cover **A/AAAA Alias**, **CNAME**, and **TXT** (verification) records, with a clean, repeatable Terraform module.

---

## 🎯 Learning Goals
- Create or reuse a **public hosted zone**.
- Publish **A/AAAA alias** records for **CloudFront** (apex and/or subdomain).
- (Optional) Publish **A/AAAA alias** records for an **ALB** (e.g., `api.example.com`).
- Manage **TXT** verification records (e.g., ACM/Email/Google Site Verification).

---

## 🛠️ Lab Setup & Tasks

```bash
# 1) Initialize
terraform -chdir=terraform init

# 2) Plan (replace with your values)
terraform -chdir=terraform plan   -var='domain_name=example.com'   -var='create_zone=false'   -var='zone_id=Z123EXAMPLE'   -var='site_subdomain="www"'   -var='cloudfront_domain_name=d111111abcdef8.cloudfront.net'   -var='root_apex_alias=true'

# 3) Apply
terraform -chdir=terraform apply -auto-approve

# 4) Verify
# - Check Route53 → Hosted Zones → Records
# - Resolve DNS locally
dig +short www.example.com
```

> **Tip**: CloudFront’s hosted zone ID is generally `Z2FDTNDATAQYW2` (provided as default here), but you can override with `cloudfront_zone_id` to be explicit.

**Optional ALB example**
```bash
terraform -chdir=terraform plan   -var='create_alb_record=true'   -var='alb_subdomain="api"'   -var='alb_dns_name=day18-alb-123456.us-east-1.elb.amazonaws.com'   -var='alb_zone_id=Z35SXDOTRQ7X7K'  # from your ALB attributes
```

**TXT verification records**
```bash
terraform -chdir=terraform plan   -var='txt_records={"_amazonses.example.com"="random-token","@"]="v=spf1 include:amazonses.com ~all"}'
```

---

## 💡 Challenge
- Add **weighted** or **latency-based** records for active/active across regions.  
- Use **failover** alias to a static maintenance page on S3/CloudFront.  
- Wire **ACM DNS validation** records via Terraform (if issuing a new cert).

---

## ✅ Checklist
- [ ] Hosted zone exists and is **authoritative** for your domain (NS updated at registrar)  
- [ ] **A/AAAA alias** records resolve to CloudFront within minutes (TTL)  
- [ ] Optional **ALB** `api.` subdomain resolves correctly  
- [ ] TXT verification records present (SPF/ACM/etc.)

---

## 📌 Commit
```bash
git add day26-route53-dns-records
git commit -m "day26: Route53 DNS — hosted zone + CloudFront/ALB aliases + TXT records"
git push
```
