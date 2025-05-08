#!/bin/bash
# Update system
apt-get update
apt-get upgrade -y

# Install Docker
apt-get install -y ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Create Ollama service
cat > /etc/systemd/system/ollama.service << 'EOL'
[Unit]
Description=Ollama Service
After=network.target

[Service]
ExecStart=/usr/bin/ollama serve
Restart=always
User=root
Environment=OLLAMA_HOST=0.0.0.0
Environment=OLLAMA_ORIGINS=http://localhost:5678

[Install]
WantedBy=multi-user.target
EOL

# Start Ollama service
systemctl daemon-reload
systemctl enable ollama
systemctl start ollama

# Pull and run Ollama model
sleep 10
ollama pull codellama

# Get host IP
HOST_IP=$(hostname -I | awk '{print $1}')

# Create n8n service
cat > /etc/systemd/system/n8n.service << 'EOL'
[Unit]
Description=n8n workflow automation
After=network.target ollama.service

[Service]
Type=simple
User=root
ExecStart=/usr/bin/docker run -d --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  -e N8N_HOST=${N8N_HOST:-localhost} \
  -e N8N_PORT=5678 \
  -e N8N_PROTOCOL=${N8N_PROTOCOL:-http} \
  -e NODE_ENV=production \
  -e OLLAMA_HOST=host.docker.internal \
  -e OLLAMA_PORT=11434 \
  --add-host=host.docker.internal:host-gateway \
  docker.n8n.io/n8nio/n8n
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOL

# Start n8n service
systemctl daemon-reload
systemctl enable n8n
systemctl start n8n 