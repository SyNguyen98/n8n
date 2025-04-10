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

USER node

# Set working directory (optional)
WORKDIR /app

# Expose n8n port
EXPOSE 5678

# Start n8n
CMD ["n8n"]
