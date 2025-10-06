# Day 28 — Budgets & Cost Alerts (Terraform)

## 📖 Overview
Today’s focus: **AWS Budgets** for **monthly cost controls** and **alerts** (actual and forecasted). We’ll create:
- A **monthly cost budget** with **SNS notifications** at two thresholds (e.g., 80% forecasted, 100% actual).
- Optional **service / tag filters** (e.g., only `AmazonEC2` or `Environment=dev`).
- Reusable variables so you can clone budgets per env/account quickly.

> ℹ️ These alerts are account‑level. You can also scope by **Linked Account**, **Service**, **Tag**, or **Cost Category** using filters below.

---

## 🎯 Learning Goals
- Define **monthly cost budgets** that track **ACTUAL** and **FORECASTED** spend.
- Notify stakeholders via **SNS → Email** (or HTTP endpoint) when a threshold is crossed.
- Filter by **services** or **tags** to target specific workloads/environments.

---

## 🛠️ Lab Setup & Tasks

```bash
# 1) Initialize
terraform -chdir=terraform init

# 2) Plan (tune variables)
terraform -chdir=terraform plan   -var='budget_amount=50'   -var='emails=["billing@example.com","ops@example.com"]'   -var='services=["AmazonEC2","AmazonEKS"]'   -var='tag_key="Environment"' -var='tag_values=["dev"]'

# 3) Apply
terraform -chdir=terraform apply -auto-approve

# 4) Test
# Force a small threshold (e.g., budget_amount=1) in a sandbox to trigger a notification.
```

**Notes**
- Budgets evaluate periodically (not real‑time). Expect a delay before notifications fire.
- SNS is configured for **Email** by default. Confirm the subscription from your inbox.
- To send to Slack, integrate **SNS → Lambda → Slack** or **AWS Chatbot** (not included here).

---

## 💡 Challenge
- Create **separate budgets per environment** (`dev`, `staging`, `prod`) with different limits.
- Add a **Usage** budget (e.g., EC2 hours) or a **Savings Plans**/ **RI coverage** budget.
- Wire **Cost Anomaly Detection** (separate service) for ML‑based spikes.

---

## ✅ Checklist
- [ ] Budget appears in **Cost Management → Budgets**  
- [ ] Subscribers confirm their **SNS email**  
- [ ] Threshold alert arrives when forecast/actual crosses limit  
- [ ] Filters (services/tags) match intended scope

---

## 📌 Commit
```bash
git add day28-budgets-and-cost-alerts
git commit -m "day28: AWS Budgets — monthly cost, forecast + actual alerts via SNS; filters for services/tags"
git push
```
