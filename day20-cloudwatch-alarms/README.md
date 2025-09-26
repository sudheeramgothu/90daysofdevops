# Day 20 — CloudWatch Alarms (ALB + Target Group + ASG) with SNS Notifications

## 📖 Overview
Today’s focus: **CloudWatch alarms** for your **ALB**, **Target Group**, and **ASG**, wired to **SNS notifications** (email optional).  
We’ll alert on:
- **ALB 5xx errors** (ELB-generated 5xx)
- **ALB target response time** (latency)
- **Target Group unhealthy hosts**
- **ASG InService instances below threshold**

This module plugs into **Day 18 (ALB)** and **Day 19 (ASG)**.

---

## 🎯 Learning Goals
- Use **AWS/ApplicationELB** & **AWS/AutoScaling** metrics with dimensions.  
- Configure **alarm thresholds**, **evaluation periods**, and **treat missing data** policy.  
- Send notifications via **SNS** (email) and/or forward to other **alarm actions** (e.g., Ops tools).

---

## 🛠️ Lab Setup & Tasks

```text
1) Collect inputs from previous days
   - lb_arn_suffix           (Day 18 ALB → ARN suffix, looks like: app/<alb-name>/<id>)
   - tg_arn_suffix           (Day 18 TG  → ARN suffix, looks like: targetgroup/<tg-name>/<id>)
   - asg_name                (Day 19 ASG name)
   - (optional) alarm_email  (to subscribe an email to SNS)

2) Initialize & Plan
   terraform -chdir=terraform init
   terraform -chdir=terraform plan      -var='lb_arn_suffix=app/day18-alb/1234567890abcdef'      -var='tg_arn_suffix=targetgroup/day18-tg/abcdef1234567890'      -var='asg_name=day19-asg'      -var='alarm_email=you@example.com'

3) Apply (you'll receive an SNS confirmation email if provided)
   terraform -chdir=terraform apply -auto-approve ...

4) Test ideas
   - Stop one instance in the ASG → **Unhealthy/low InService** alarms may trigger.
   - Serve slow responses on targets → **Latency** alarm may trigger.
   - Force 5xx from app → **ALB 5xx** alarm may trigger.
```

---

## 💡 Challenge
- Add alarms for **HTTPCode_Target_5XX_Count** and **RejectedConnectionCount**.  
- Enable **OK actions** to post recovery messages.  
- Wire alarms to a **chat webhook** via Lambda subscription.

---

## ✅ Checklist
- [ ] SNS topic created and (optionally) **email subscription confirmed**  
- [ ] ALB 5xx + latency alarms **in ALARM when thresholds crossed**  
- [ ] Target Group unhealthy hosts alarm **fires appropriately**  
- [ ] ASG **InService count** alarm protects capacity

---

## 📌 Commit
```bash
git add day20-cloudwatch-alarms
git commit -m "day20: CloudWatch alarms for ALB/TG/ASG + SNS notifications"
git push
```
