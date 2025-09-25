# Day 19 — Auto Scaling Group (ASG) behind the ALB (Rolling Updates + Target Tracking)

## 📖 Overview
Today’s focus: **Launch Template + Auto Scaling Group** registered to the **Day 18 Target Group**. We’ll support **rolling instance refresh**, **ELB health checks**, and **target tracking** (CPU or ALB requests per target).

This module plugs into **Day 14** (VPC), **Day 16** (SGs), **Day 17** (user data ideas), and **Day 18** (ALB target group).

---

## 🎯 Learning Goals
- Create a reusable **Launch Template** with user data.
- Run an **ASG** across private subnets and register to an ALB **target group**.
- Configure **Instance Refresh** for **rolling updates** on LT changes.
- Add **target tracking** scaling policy (choose CPU or ALB Requests/Target).

---

## 🛠️ Lab Setup & Tasks

```text
1) Inputs you need
   - vpc_id
   - private_subnet_ids (list, where your app will run)
   - security_group_ids (e.g., Day 16 web_sg or app_sg)
   - target_group_arn (from Day 18)

2) Init & Plan
   terraform -chdir=terraform init
   terraform -chdir=terraform plan      -var='vpc_id=vpc-0123'      -var='private_subnet_ids=["subnet-a","subnet-b"]'      -var='security_group_ids=["sg-xyz"]'      -var='target_group_arn=arn:aws:elasticloadbalancing:...:targetgroup/...'      -var='desired_capacity=2' -var='min_size=2' -var='max_size=5'

3) Apply
   terraform -chdir=terraform apply -auto-approve ...

4) Test
   - Hit your **ALB DNS** (from Day 18) and see responses coming from ASG instances.
   - Increase load (e.g., `ab` or `hey`) and watch scaling (if target tracking enabled).
```

---

## 💡 Challenge
- Switch scaling policy to **ALBRequestCountPerTarget** (default provided) or **CPUUtilization**.
- Enable **CloudWatch agent** in user data and push custom metrics.
- Add **Warm Pools** and experiment with **scheduled actions** (e.g., office hours).

---



## 📌 Commit
```bash
git add day19-asg-behind-alb
git commit -m "day19: Launch Template + Auto Scaling Group behind ALB with rolling updates and target tracking"
git push
```
