def generate_terraform_code(instance_type, num_replicas):
    terraform_config = f"""
    provider "aws" {{
      region = "${{var.aws_region}}"
    }}

    resource "aws_instance" "postgres" {{
      ami           = "ami-0c55b159cbfafe1f0"
      instance_type = "{instance_type}"
      key_name      = "my-key"
      security_groups = ["allow_ssh"]

      tags = {{
        Name = "PostgresServer"
      }}
    }}

    output "server_ip" {{
      value = aws_instance.postgres.public_ip
    }}
    """

    with open("terraform/main.tf", "w") as f:
        f.write(terraform_config)
