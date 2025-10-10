# Day 31 — Jenkins Docker Agent

## 📖 Overview
Today’s focus: **Jenkins Docker Agent** — running Jenkins builds inside containerized agents.  
We’ll learn how to create a lightweight, reproducible Jenkins agent image that can build, test, and deploy applications from a Docker environment.

---

## 🎯 Learning Goals
- Understand how Jenkins agents connect to the controller.  
- Build and run a **custom Docker agent** with all DevOps tools pre-installed.  
- Configure Jenkins to dynamically use Docker agents for CI/CD workloads.  
- Learn how to use this agent both locally and in a Kubernetes-based Jenkins setup.

---

## 🛠️ Tasks

1. **Build your Jenkins Agent Docker Image**
   - Create a `Dockerfile` that includes:
     - Jenkins inbound agent
     - AWS CLI, Docker CLI
     - Terraform, kubectl, and Python3  
   - Example:
     ```dockerfile
     FROM jenkins/inbound-agent:latest
     USER root
     RUN apt-get update && apt-get install -y \
         docker.io awscli curl unzip python3 python3-pip && \
         curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
         echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
         apt-get update && apt-get install terraform -y && \
         curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.29.0/bin/linux/amd64/kubectl" && \
         chmod +x kubectl && mv kubectl /usr/local/bin/ && \
         apt-get clean && rm -rf /var/lib/apt/lists/*
     USER jenkins
     ```

2. **Run the Agent Locally**
   ```bash
   docker build -t devops/jenkins-docker-agent:latest .
   docker run -d --name jenkins-agent \
     -v /var/run/docker.sock:/var/run/docker.sock \
     -v $HOME/.aws:/home/jenkins/.aws:ro \
     -e JENKINS_URL="https://jenkins.yourdomain.com/" \
     -e AGENT_NAME="docker-agent-1" \
     -e AGENT_SECRET="YOUR_AGENT_SECRET" \
     -e AGENT_WORKDIR="/home/jenkins/agent" \
     devops/jenkins-docker-agent:latest

3. **Integrate the Agent in Jenkins**
Go to Jenkins → Manage Nodes and Clouds → New Node

Choose “Permanent Agent” or “Docker Agent Template”

Fill in:

Remote root directory: /home/jenkins/agent

Labels: docker-agent

Launch method: “Launch agent by connecting it to the controller”

