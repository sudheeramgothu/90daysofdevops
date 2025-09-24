# Day 18 — Application Load Balancer (ALB) with HTTPS (ACM) + Health Checks

## 📖 Overview
Today’s focus: **Provision an ALB with Terraform**, enable **HTTPS** via an **ACM certificate**, add an **HTTP→HTTPS redirect**, and register targets with a **Target Group** (instances from Day 17 or attach later from an ASG).

This module plugs into **Day 14** (VPC/subnets), **Day 16** (SGs), and can front the instance from **Day 17** or an Auto Scaling Group you create later.

---

## 🎯 Learning Goals
- Create an **internet-facing ALB** in public subnets with a dedicated SG.  
- Configure **listeners**: port **80** (redirect to 443) and **443** (HTTPS with ACM).  
- Build a **target group** with **health checks** and attach instances.  
- Output the **ALB DNS** name for quick testing and Route53 mapping.

---

## 🛠️ Lab Setup & Tasks

```text
1) Prereqs
   - An ACM certificate in the same region as the ALB (var.certificate_arn).
   - VPC ID + **public** subnet IDs from Day 14.
   - (Optional) One or more instance IDs (e.g., from Day 17) to register as targets.

2) Initialize & Plan
   terraform -chdir=terraform init
   terraform -chdir=terraform plan      -var='vpc_id=vpc-0123456789abcdef0'      -var='public_subnet_ids=["subnet-aaa","subnet-bbb"]'      -var='certificate_arn=arn:aws:acm:us-east-1:111122223333:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'      -var='instance_ids=["i-0123abcd","i-0456efgh"]'

3) Apply
   terraform -chdir=terraform apply -auto-approve      -var='vpc_id=vpc-0123456789abcdef0'      -var='public_subnet_ids=["subnet-aaa","subnet-bbb"]'      -var='certificate_arn=arn:aws:acm:us-east-1:111122223333:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'      -var='instance_ids=["i-0123abcd","i-0456efgh"]'

4) Test
   - Open: http://<ALB_DNS_NAME> → should redirect to HTTPS
   - Open: https://<ALB_DNS_NAME> → should reach your Day 17 NGINX index page

5) (Optional) Attach an ASG later
   - Output `target_group_arn` and reference it in your ASG resource via `target_group_arns = [var.target_group_arn]`.
```

---

## 💡 Challenge
- Add an **HTTPS listener rule** that routes `/api/*` to a second target group on a different port.  
- Enable **access logs** to S3 and set **deletion protection** on the ALB.  
- Use **Route53** to map a friendly domain to the ALB with an alias A record.

---


## 📌 Commit
```bash
git add day18-alb-with-https
git commit -m "day18: Internet-facing ALB with HTTPS (ACM), HTTP→HTTPS redirect, target group + health checks"
git push
```
