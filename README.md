# Automated n8n and Ollama Setup on EC2

This repository contains automated installation scripts to set up n8n (via Docker) and Ollama on AWS EC2 instances.

## Prerequisites

- An AWS EC2 instance with Ubuntu (recommended: Ubuntu 22.04 LTS)
- SSH access to the instance
- Sudo privileges on the instance
- At least 4GB of RAM recommended (2GB for n8n + 2GB for Ollama)

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

## Verifying the Installation

Once the installation is complete:

- n8n will be accessible at `http://<ec2-ip-address>:5678`
- Ollama will be accessible at `http://<ec2-ip-address>:11434`

### Testing Ollama

To test Ollama, you can use the command:
```bash
ollama run llama2
```

## Data Structure

- n8n data is persisted in `/opt/n8n/data`
- Ollama models are stored in `~/.ollama`
- Both services are configured to automatically restart in case of failure

## Security Configuration

For production use, it is recommended to:

1. Configure EC2 security groups to allow only necessary ports (5678 for n8n, 11434 for Ollama)
2. Set up a reverse proxy (like Nginx) with SSL
3. Implement authentication for n8n
4. Configure regular backups of `/opt/n8n/data` and `~/.ollama` directories
5. Configure Docker to use an isolated network
6. Limit Ollama access to necessary IP addresses only

## Support

For more information:
- [n8n Documentation](https://docs.n8n.io/)
- [Ollama Documentation](https://github.com/ollama/ollama)
- [Docker Documentation](https://docs.docker.com/)
- [cloud-init Documentation](https://cloudinit.readthedocs.io/) 