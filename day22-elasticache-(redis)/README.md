# Day 22 — ElastiCache (Redis) with Terraform

## 📖 Overview
Today’s focus: **Provision Amazon ElastiCache for Redis** using Terraform with production-minded defaults: **subnet group in private subnets**, **replication group** (Multi-AZ with automatic failover), **encryption in-transit/at-rest**, **AUTH token**, and **least-privilege** security group rules from your app tier.

This module plugs into:
- **Day 14** VPC & subnets (**private** subnets for Redis)
- **Day 16** Security Groups (allow Redis 6379 from app SG)
- Optional: **Day 19** ASG (app nodes connect to Redis endpoint)

---

## 🎯 Learning Goals
- Create a **Subnet Group** for ElastiCache in private subnets.  
- Provision a **Redis Replication Group** with Multi‑AZ & automatic failover.  
- Enable **TLS (in-transit)** and **at-rest** encryption + **AUTH token**.  
- Expose a **single discovery endpoint** for applications.

---

## 🛠️ Lab Setup & Tasks

```bash
# 1) Initialize
terraform -chdir=terraform init

# 2) Plan (replace with your values)
terraform -chdir=terraform plan   -var='vpc_id=vpc-0123'   -var='private_subnet_ids=["subnet-a","subnet-b"]'   -var='app_security_group_ids=["sg-app123"]'   -var='node_type=cache.t3.micro'   -var='num_cache_clusters=2'   -var='multi_az_enabled=true'   -var='automatic_failover_enabled=true'

# 3) Apply
terraform -chdir=terraform apply -auto-approve   -var='vpc_id=vpc-0123'   -var='private_subnet_ids=["subnet-a","subnet-b"]'   -var='app_security_group_ids=["sg-app123"]'

# 4) Retrieve connection details
terraform -chdir=terraform output
# Use primary_endpoint_address for writes, reader_endpoint_address for reads (if provided).
```

**Notes**
- TLS is **enabled** by default. Your app client must support `rediss://` or TLS options.  
- An **AUTH token** is generated unless you pass your own via `auth_token`.  
- For cluster-mode enabled (sharding), set `cluster_mode_enabled=true` and adjust shard/replica counts.

---

## 💡 Challenge
- Switch to **Cluster Mode Enabled** (sharded) with `num_node_groups` and `replicas_per_node_group`.  
- Add **parameter group** overrides (e.g., `maxmemory-policy allkeys-lru`).  
- Attach **CloudWatch Alarms** for CPU, memory, and evictions.

---

## ✅ Checklist
- [ ] Private **subnet group** and **SG** restricted to app tier  
- [ ] **Multi‑AZ** + **automatic failover** (replication group)  
- [ ] **TLS** and **AUTH token** enabled  
- [ ] App connects via the **primary endpoint**

---

## 📌 Commit
```bash
git add day22-elasticache-redis
git commit -m "day22: ElastiCache Redis replication group (TLS, AUTH token, Multi-AZ) with Terraform"
git push
```
