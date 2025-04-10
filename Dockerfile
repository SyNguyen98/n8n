FROM node:lts-buster

USER root

# Install OS-level dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install n8n globally
RUN npm install -g n8n

# Install Terraform
ENV TERRAFORM_VERSION=1.11.3
RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip -d /usr/local/bin/ \
    && rm terraform.zip

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Environment variables for n8n
ENV N8N_PORT=5678 \
    N8N_HOST=0.0.0.0 \
    DB_TYPE=postgresdb \
    DB_POSTGRESDB_SSL=true \
    DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED=false \
    N8N_BASIC_AUTH_ACTIVE=true \

USER node

WORKDIR /app

EXPOSE 5678

CMD ["n8n", "start"]
