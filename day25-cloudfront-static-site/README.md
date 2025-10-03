# Day 25 — CloudFront Static Site with S3 (+ OAC, HTTPS)

## 📖 Overview
Today’s focus: **S3 + CloudFront** with **Origin Access Control (OAC)** so the bucket stays **private** and is only readable by CloudFront. We’ll enable **HTTPS**, optional **custom domain (ACM)**, sensible **caching policies**, and optional **access logs**.

**Why OAC?** It signs origin requests with SigV4 and lets your **S3 bucket deny all public access** while still serving through CloudFront.

---

## 🎯 Learning Goals
- Provision an **S3 bucket** for static content with **all public access blocked**.
- Create a **CloudFront distribution** with **OAC** and **least-privilege bucket policy**.
- (Optional) Wire a **custom domain + ACM cert** and enable **access logging**.
- Ship a sample `index.html` to verify everything works.

---

## 🛠️ Lab Setup & Tasks

```bash
# 1) Initialize
terraform -chdir=terraform init

# 2) Plan (update variables as needed)
terraform -chdir=terraform plan   -var='name_prefix=day25'   -var='bucket_name=day25-static-<uniq>'   -var='default_root_object="index.html"'

# 3) Apply
terraform -chdir=terraform apply -auto-approve

# 4) Upload site content (sample index included)
aws s3 cp ../site/index.html s3://$(terraform -chdir=terraform output -raw site_bucket_name)/index.html

# 5) Test
echo "Open CloudFront URL:"
terraform -chdir=terraform output distribution_domain_name
```

**Custom domain (optional)**
- Create/validate an **ACM certificate in us-east-1** for your `domain_name` (and `alternate_domains` if any).
- Pass `-var='domain_name=dev.example.com' -var='certificate_arn=arn:aws:acm:us-east-1:...:certificate/...'`

**Logs (optional)**
- Set `enable_logging=true` to create a separate S3 log bucket and enable CloudFront access logs.

---

## 💡 Challenge
- Add a **Cache Policy** tuned for immutable assets (`/assets/*`) vs HTML (`/index.html`).  
- Attach a **Response Headers Policy** for security headers (CSP, HSTS).  
- Use **Lambda@Edge** or **CloudFront Functions** to enforce redirects or add headers.

---

## ✅ Checklist
- [ ] S3 bucket is **private** and **only** CloudFront can read it  
- [ ] Distribution serves **HTTPS** with the default certificate or your ACM cert  
- [ ] `index.html` loads via the **CloudFront domain**  
- [ ] (Optional) Access logs delivered to the **log bucket**

---

## 📌 Commit
```bash
git add day25-cloudfront-static-site
git commit -m "day25: CloudFront + S3 with OAC (private bucket), HTTPS, optional domain/logging"
git push
```
