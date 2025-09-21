# Day 15 — Route Tables & VPC Endpoints (S3/DynamoDB + Interface)

## 📖 Overview
Today’s focus: **VPC route tables & endpoints**. We’ll attach **Gateway Endpoints** (S3 & DynamoDB) to private route tables to enable **egress-free** access, and optionally add **Interface Endpoints** (SSM, EC2 Messages, SSM Messages) secured by a security group.

This module is designed to **plug into Day 14**. Bring your `vpc_id` and the route table IDs from Day 14.

## 🎯 Learning Goals
- Understand **Gateway Endpoints** (S3 & DynamoDB) vs **Interface Endpoints** (PrivateLink).  
- Attach endpoints to **specific route tables** (gateway) or **subnets** (interface).  
- Apply **endpoint policies** for least-privilege access.  
- Reduce NAT data transfer and improve security posture.

## 🛠️ Lab Setup & Tasks

```bash
terraform -chdir=terraform init
terraform -chdir=terraform plan   -var='vpc_id=vpc-0123456789abcdef0'   -var='private_route_table_ids=["rtb-aaa","rtb-bbb"]'   -var='public_route_table_id=rtb-ccc'   -var='private_subnet_ids=["subnet-111","subnet-222"]'   -var='vpc_cidr="10.0.0.0/16"'
terraform -chdir=terraform apply -auto-approve   -var='vpc_id=vpc-0123456789abcdef0'   -var='private_route_table_ids=["rtb-aaa","rtb-bbb"]'   -var='public_route_table_id=rtb-ccc'   -var='private_subnet_ids=["subnet-111","subnet-222"]'   -var='vpc_cidr="10.0.0.0/16"'
```

## 💡 Challenge
- Add a **custom endpoint policy** restricting S3 access to a specific bucket/prefix.  
- Add more **interface endpoints** (e.g., ECR API/DKR, CloudWatch Logs).  
- Split endpoint SG to **subnet-specific** rules for tighter control.

