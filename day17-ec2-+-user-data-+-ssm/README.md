# Day 17 — EC2 + User Data + SSM (No SSH Keys)

## 📖 Overview
Today’s focus: **Provision EC2 with Terraform**, bootstrap with **cloud-init user data**, and manage the instance using **AWS Systems Manager (SSM) Session Manager** — no inbound SSH required.

This module plugs into **Day 14** (VPC/Subnets/IGW/NAT) and **Day 16** (SGs). You will:
- Launch an EC2 instance in a chosen subnet (public *or* private).
- Attach an **IAM role** with `AmazonSSMManagedInstanceCore` for SSM.
- Use **user data** to install and run NGINX and push a demo page.
- (Optional) Route SSM traffic via **Interface Endpoints** from Day 15 for private subnets.

---

## 🎯 Learning Goals
- Data-source the latest **Amazon Linux** AMI.
- Use `user_data` to install packages and write files at boot.
- Attach an **instance profile** with least-privilege policy.
- Use **SSM Session Manager** to access the instance without SSH keys.

---

## 🛠️ Lab Setup & Tasks

```text
1) Initialize
   terraform -chdir=terraform init

2) Plan (replace with your values from Day 14/16)
   terraform -chdir=terraform plan      -var='vpc_id=vpc-012345'      -var='subnet_id=subnet-abc'      -var='security_group_ids=["sg-xyz"]'

3) Apply
   terraform -chdir=terraform apply -auto-approve      -var='vpc_id=vpc-012345'      -var='subnet_id=subnet-abc'      -var='security_group_ids=["sg-xyz"]'

4) Connect (no SSH needed)
   - Open AWS Console → Systems Manager → Session Manager → Start session → choose instance
   - Or CLI: aws ssm start-session --target <instance-id>

5) Verify user data
   - From the session: curl -s localhost | head -n3
   - Check systemd service status: sudo systemctl status nginx
```

**Notes**
- If you place the instance in a **private** subnet, ensure **Day 15 SSM interface endpoints** exist, or the instance needs a NAT path for SSM.
- Amazon Linux 2023 & 2 come with SSM agent by default (the module still handles the IAM role).

---

## 💡 Challenge
- Add a **CloudWatch agent** to ship NGINX access logs (via extra user data).  
- Switch to a **Launch Template + Auto Scaling Group** pattern.  
- Parameterize **user data** from a local file and pass variables (e.g., app name, env).

---

## ✅ Checklist
- [ ] Instance reachable via **SSM Session Manager**  
- [ ] NGINX is **running** and serving a custom index page  
- [ ] No inbound SSH required  
- [ ] (Optional) Private subnet + VPC interface endpoints for SSM

---

## 📌 Commit
```bash
git add day17-ec2-userdata-ssm
git commit -m "day17: EC2 with user data + SSM Session Manager (no SSH)"
git push
```
