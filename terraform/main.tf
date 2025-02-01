
    provider "aws" {
      region = "${var.aws_region}"
    }

    resource "aws_instance" "postgres" {
      ami           = "ami-00bb6a80f01f03502"
      instance_type = "t2.medium"
      key_name      = "my-key"
      security_groups = ["allow_ssh"]

      tags = {
        Name = "PostgresServer"
      }
    }

    output "server_ip" {
      value = aws_instance.postgres.public_ip
    }
    
