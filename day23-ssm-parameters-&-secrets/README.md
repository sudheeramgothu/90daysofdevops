# Day 23 — SSM Parameters & Secrets (KMS + App Bootstrap)

## 📖 Overview
Today’s focus: **AWS Systems Manager Parameter Store** and **AWS Secrets Manager** for **configuration and secrets management**.  
You’ll create a **parameter hierarchy** per app/environment, protect sensitive values with **KMS encryption**, and learn **bootstrap patterns** for EC2/ECS/EKS apps.

This builds on:
- **Day 14–16** (network & security groups) and **Day 17–19** (compute & scaling)
- **Day 21–22** (stateful services)

---

## 🎯 Learning Goals
- Model a **/env/app/** parameter hierarchy (e.g., `/prod/api/DB_HOST`).  
- Store **plain** and **secure** (KMS) parameters in **Parameter Store**.  
- Create a **Secrets Manager** secret for rotation-friendly credentials.  
- Fetch config at **boot time** (user data) or **runtime** (SDK/CLI) safely.

---

## 🛠️ Lab Setup & Tasks

```bash
# 1) Initialize
terraform -chdir=terraform init

# 2) Plan (edit variables or pass -var)
terraform -chdir=terraform plan   -var='env=dev'   -var='app_name=sampleapp'   -var='parameters={"LOG_LEVEL":"info","FEATURE_X_ENABLED":"true"}'   -var='secure_parameters={"DB_PASSWORD":"s3cr3t!"}'

# 3) Apply
terraform -chdir=terraform apply -auto-approve   -var='env=dev'   -var='app_name=sampleapp'

# 4) Try bootstrap examples
#   a) On EC2 (Day 17/19), run:
bash app-examples/fetch_ssm_to_envfile.sh /dev/sampleapp .env
#   b) Python (anywhere with AWS creds):
python3 app-examples/read_params_python.py /dev/sampleapp
```

**Where things land**
- Parameter Store path prefix: `/${env}/${app_name}/...`  
- Secret name: `${env}/${app_name}/db-credentials` (editable via var)  
- Custom **KMS key** (optional) used for `SecureString` params and the secret.

---

## 💡 Challenge
- Add **parameter version pinning** in CI/CD (break glass: rollbacks).  
- Use **EC2/ECS task role** scoped to a **narrow SSM/Secrets policy** (least privilege).  
- Wire **Lambda rotation** for the Secrets Manager secret.  

---

## ✅ Checklist
- [ ] Clear **/env/app** naming for parameters  
- [ ] **SecureString** values encrypted with **KMS**  
- [ ] App can **fetch and render .env** safely at boot or runtime  
- [ ] Secrets never committed to git

---

## 📌 Commit
```bash
git add day23-ssm-parameters-secrets
git commit -m "day23: SSM Param Store hierarchy + Secrets Manager with KMS; bootstrap examples"
git push
```
