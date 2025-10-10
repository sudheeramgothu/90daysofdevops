#!/usr/bin/env bash
set -euo pipefail
: "${{JENKINS_URL:?JENKINS_URL is required}}"
: "${{AGENT_NAME:?AGENT_NAME is required}}"
: "${{AGENT_SECRET:?AGENT_SECRET is required}}"
: "${{AGENT_WORKDIR:=/home/jenkins/agent}}"
JAVA_BIN=${{JAVA_BIN:-java}}
JAR=/home/jenkins/agent.jar
if [ ! -f "$JAR" ]; then
  echo "[INFO] Downloading agent.jar from ${JENKINS_URL}"
  curl -fsSL "${JENKINS_URL}jnlpJars/agent.jar" -o "$JAR"
fi
mkdir -p "${AGENT_WORKDIR}"
echo "[INFO] Starting Jenkins inbound agent: ${AGENT_NAME}"
exec ${JAVA_BIN} -jar "$JAR" -jnlpUrl "${JENKINS_URL}computer/${AGENT_NAME}/jenkins-agent.jnlp" -secret "${AGENT_SECRET}" -workDir "${AGENT_WORKDIR}"
