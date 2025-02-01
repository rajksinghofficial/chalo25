
    provider "aws" {
      region = "${var.aws_region}"
    }

    # Create Security Group for PostgreSQL
    resource "aws_security_group" "postgres_sg" {
      name_prefix = "postgres_sg"
      description = "Allow inbound SSH and PostgreSQL access"

      ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (change for security)
      }

      ingress {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allow PostgreSQL access from anywhere (restrict as needed)
      }

      egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }

    # Create EC2 instance for PostgreSQL
    resource "aws_instance" "postgres" {
      ami           = "ami-00bb6a80f01f03502"  # Ensure this AMI is valid for your AWS region
      instance_type = "t2.medium"
      key_name      = "raj-aws-key"  # Replace with your actual AWS EC2 key name
      vpc_security_group_ids = [aws_security_group.postgres_sg.id]  # Attach security group

      tags = {
        Name = "PostgresServer"
      }
    }

    output "server_ip" {
      value = aws_instance.postgres.public_ip
    }
    