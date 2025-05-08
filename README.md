# Automated n8n and Ollama Setup on EC2

This repository contains automated installation scripts to set up n8n (via Docker) and Ollama on AWS EC2 instances. Ollama is configured to run locally and is only accessible by n8n on the same instance.

## Prerequisites

### EC2 Instance Requirements

#### Minimum Requirements
- Instance type: t3.medium
  - 2 vCPUs
  - 4 GB RAM
  - Good for testing and development
  - Suitable for basic automation tasks

#### Recommended Requirements
- Instance type: t3.large
  - 2 vCPUs
  - 8 GB RAM
  - Better performance for production use
  - Can handle multiple n8n workflows

#### Production Requirements
- Instance type: t3.xlarge
  - 4 vCPUs
  - 16 GB RAM
  - Optimal for production workloads
  - Can handle complex workflows and concurrent executions

### Storage Requirements
- Root volume: At least 20GB
- Additional EBS volume (recommended): 30GB+
  - For storing n8n data
  - For storing Ollama models
  - For workflow logs and backups

### Network Requirements
- VPC with internet access
- Security group allowing:
  - Port 5678 (n8n)
  - SSH access (port 22)
  - Note: Ollama is only accessible locally (127.0.0.1)

### Operating System
- Ubuntu 22.04 LTS (recommended)
- Ubuntu 20.04 LTS (supported)

## Installation Methods

### Method 1: Installation via cloud-init (Recommended)

1. During EC2 instance creation, go to the "Advanced details" section
2. In the "User data" field, copy the contents of the `cloud-init.yaml` file
3. Launch the instance

This method is recommended because it:
- Uses the native EC2 cloud-init format
- Better handles system dependencies
- Runs more reliably at startup
- Provides better installation tracking
- Automatically downloads the default LLM model (codellama)
- Configures Ollama for local-only access

### Method 2: Manual Installation

1. Connect to your EC2 instance via SSH
2. Clone this repository or copy the `setup.sh` file
3. Make the script executable:
   ```bash
   chmod +x setup.sh
   ```
4. Run the script:
   ```bash
   ./setup.sh
   ```

### Method 3: Terraform Installation

1. Make sure you have Terraform installed on your machine
2. Create an AWS key pair named `n8n-key` in your AWS console
3. Initialize Terraform:
   ```bash
   terraform init
   ```
4. Review the planned changes:
   ```bash
   terraform plan
   ```
5. Apply the configuration:
   ```bash
   terraform apply
   ```
6. The output will show the public IP address of your instance

## Verifying the Installation

Once the installation is complete:

- n8n will be accessible at `http://<ec2-ip-address>:5678`
- Ollama will be running locally and accessible only to n8n
- The default LLM model (codellama) will be automatically downloaded and ready to use

### Testing Ollama

To test Ollama locally (from the EC2 instance):
```bash
curl http://localhost:11434/api/generate -d '{
  "model": "codellama",
  "prompt": "Hello, how are you?"
}'
```

## Why CodeLlama?

CodeLlama is set as the default model because it:
- Is specifically trained for code and automation tasks
- Has better understanding of programming languages and APIs
- Can help with n8n workflow creation and debugging
- Provides more accurate responses for automation-related queries
- Has good performance for both code generation and natural language tasks

## Performance Considerations

### Memory Usage
- CodeLlama requires approximately 4GB of RAM
- n8n typically uses 1-2GB of RAM
- System and other processes need 1-2GB
- Total recommended: 8GB minimum, 16GB for production

### CPU Usage
- CodeLlama inference is CPU-intensive
- n8n workflows can be CPU-intensive depending on complexity
- Local-only access reduces network overhead

### Storage Performance
- EBS gp3 volumes recommended for better I/O performance
- Consider using instance store for temporary data if available
- Regular backups of n8n data and Ollama models

## Security Configuration

For production use, it is recommended to:

1. Configure EC2 security groups to allow only necessary ports (5678 for n8n)
2. Set up a reverse proxy (like Nginx) with SSL for n8n
3. Implement authentication for n8n
4. Configure regular backups of `/opt/n8n/data` and `~/.ollama` directories
5. Configure Docker to use an isolated network
6. Note: Ollama is already secured by running only on localhost

## Support

For more information:
- [n8n Documentation](https://docs.n8n.io/)
- [Ollama Documentation](https://github.com/ollama/ollama)
- [Docker Documentation](https://docs.docker.com/)
- [cloud-init Documentation](https://cloudinit.readthedocs.io/)

## Accessing n8n

After installation, access n8n at:
```
http://<your-instance-ip>:5678
```

## Ollama Configuration

Ollama is configured to:
- Run as a systemd service
- Only listen on localhost (127.0.0.1)
- Only accept connections from n8n (localhost:5678)
- Use the CodeLlama model by default

## Security Notes

- The instance is configured with basic security settings
- Ollama is restricted to localhost access only
- n8n is configured to connect to Ollama securely
- Consider implementing additional security measures for production use

## Cleaning Up

### For Method 1 & 2:
Terminate the EC2 instance through the AWS Console

### For Method 3:
```bash
terraform destroy
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 