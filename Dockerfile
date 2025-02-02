# Base image with Python 3.9
FROM python:3.9

# Set working directory
WORKDIR /app

# Install Terraform
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    software-properties-common \
    && wget -O terraform.zip https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip \
    && unzip terraform.zip -d /usr/local/bin/ \
    && rm terraform.zip

# Install Ansible
RUN apt-add-repository --yes --update ppa:ansible/ansible \
    && apt-get update && apt-get install -y ansible

# Copy and install Python dependencies
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application files
COPY . .

# Expose the default port for FastAPI
EXPOSE 8000

# Start FastAPI application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

