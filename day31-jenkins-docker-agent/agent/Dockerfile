# Jenkins inbound agent with Docker CLI & common DevOps tools
FROM debian:bookworm-slim
ARG USER=jenkins
ARG UID=1000
ARG GID=1000
ARG TF_VERSION=1.7.5
ARG KUBECTL_VERSION=v1.29.6
ARG AWSCLI_VERSION=2.17.40
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8 LC_ALL=C.UTF-8
RUN apt-get update && apt-get install -y --no-install-recommends     openjdk-17-jre-headless ca-certificates     git curl jq make zip unzip gnupg lsb-release bash     python3 python3-pip apt-transport-https &&     curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg &&     echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list &&     apt-get update && apt-get install -y --no-install-recommends docker-ce-cli &&     curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m)-${AWSCLI_VERSION}.zip" -o /tmp/awscliv2.zip &&     unzip /tmp/awscliv2.zip -d /tmp && /tmp/aws/install &&     curl -fsSL "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_$(dpkg --print-architecture).zip" -o /tmp/terraform.zip &&     unzip /tmp/terraform.zip -d /usr/local/bin &&     curl -fsSLo /usr/local/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/$(dpkg --print-architecture)/kubectl" &&     chmod +x /usr/local/bin/kubectl && rm -rf /var/lib/apt/lists/* /tmp/*
RUN groupadd -g ${GID} ${USER} && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USER}
RUN mkdir -p /home/${USER}/agent && chown -R ${USER}:${USER} /home/${USER}
ENV AGENT_WORKDIR=/home/${USER}/agent
WORKDIR /home/${USER}
USER ${USER}
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
