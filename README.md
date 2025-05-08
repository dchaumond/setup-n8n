# Setup n8n with Ollama

This repository contains scripts to set up n8n with Ollama on an AWS EC2 instance. It provides three different installation methods:

1. Manual installation using a shell script
2. Automated installation using cloud-init
3. Infrastructure as Code using Terraform

## Prerequisites

- An AWS account
- AWS CLI configured with appropriate credentials
- (Optional) Terraform installed for method 3

## Installation Methods

### Method 1: Manual Installation

Located in the `manual` directory:
1. Launch an EC2 instance (t3.medium recommended) with Ubuntu 22.04
2. Copy the `setup.sh` script to your instance
3. Make it executable and run it:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

### Method 2: Cloud-init Installation

Located in the `aws` directory:
1. Launch an EC2 instance using the provided cloud-init configuration:
   ```bash
   aws ec2 run-instances \
     --image-id ami-0a0c8eebcdd6dcbd0 \
     --instance-type t3.medium \
     --user-data file://aws/cloud-init.yaml \
     --security-group-ids your-security-group-id \
     --key-name your-key-name
   ```

### Method 3: Terraform Installation

Located in the `terraform` directory:
1. Make sure you have Terraform installed on your machine
2. Create an AWS key pair named `n8n-key` in your AWS console
3. Navigate to the terraform directory:
   ```bash
   cd terraform
   ```
4. Initialize Terraform:
   ```bash
   terraform init
   ```
5. Review the planned changes:
   ```bash
   terraform plan
   ```
6. Apply the configuration:
   ```bash
   terraform apply
   ```
7. The output will show the private IP address of your instance

## Accessing n8n

After installation, access n8n at:
```
http://<your-instance-ip>:5678
```

## Ollama Configuration

Ollama is configured to:
- Run as a systemd service
- Listen on all interfaces (0.0.0.0)
- Only accept connections from n8n (localhost:5678)
- Use the CodeLlama model by default

## Security Notes

- The instance is configured with basic security settings
- Ollama is accessible from n8n via host.docker.internal
- n8n is configured to connect to Ollama securely
- Consider implementing additional security measures for production use

## Cleaning Up

### For Method 1 & 2:
Terminate the EC2 instance through the AWS Console

### For Method 3:
```bash
cd terraform
terraform destroy
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 