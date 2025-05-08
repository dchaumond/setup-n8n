terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# Security group for the EC2 instance
resource "aws_security_group" "n8n_sg" {
  name        = "n8n-security-group"
  description = "Security group for n8n instance"

  ingress {
    from_port   = 5678
    to_port     = 5678
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "n8n web interface"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "n8n-security-group"
  }
}

# EC2 instance
resource "aws_instance" "n8n_instance" {
  ami           = "ami-0a0c8eebcdd6dcbd0"  # Ubuntu 22.04 LTS in eu-central-1
  instance_type = "t3.medium"
  key_name      = "n8n-key"  # Make sure to create this key pair in AWS

  security_groups = [aws_security_group.n8n_sg.name]

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "n8n-instance"
  }
}

# Output the private IP address
output "private_ip" {
  value = aws_instance.n8n_instance.private_ip
} 