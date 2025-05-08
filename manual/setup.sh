#!/bin/bash

# Update system packages
sudo apt-get update
sudo apt-get upgrade -y

# Install required dependencies
sudo apt-get install -y curl wget git

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu

# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Create Ollama systemd service
sudo tee /etc/systemd/system/ollama.service << EOF
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
Environment="OLLAMA_HOST=0.0.0.0"
ExecStart=/usr/bin/ollama serve
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# Create n8n data directory
sudo mkdir -p /opt/n8n/data
sudo chown -R ubuntu:ubuntu /opt/n8n

# Create systemd service for n8n
sudo tee /etc/systemd/system/n8n.service << EOF
[Unit]
Description=n8n workflow automation
After=docker.service
Requires=docker.service

[Service]
Type=simple
User=ubuntu
Environment=N8N_PORT=5678
Environment=N8N_PROTOCOL=http
Environment=NODE_ENV=production
ExecStart=/usr/bin/docker run -d \\
    --name n8n \\
    -p 5678:5678 \\
    -v /opt/n8n/data:/home/node/.n8n \\
    -e N8N_PORT=5678 \\
    -e N8N_PROTOCOL=http \\
    -e NODE_ENV=production \\
    --restart unless-stopped \\
    docker.n8n.io/n8nio/n8n
ExecStop=/usr/bin/docker stop n8n
ExecStopPost=/usr/bin/docker rm n8n
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Start and enable services
sudo systemctl daemon-reload
sudo systemctl enable ollama
sudo systemctl start ollama
sudo systemctl enable n8n
sudo systemctl start n8n

# Print status
echo "Installation completed!"
echo "n8n is running on http://localhost:5678"
echo "Ollama is running on http://localhost:11434"
echo "You can test Ollama with: ollama run llama2" 