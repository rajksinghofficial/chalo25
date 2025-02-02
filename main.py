from fastapi import FastAPI
import subprocess
import json
import os
from terraform_generator import generate_terraform_code
import time 

app = FastAPI()

@app.post("/initiate")
def initiate(params: dict):
    postgres_version = params.get("postgres_version", "13")
    instance_type = params.get("instance_type", "t2.medium")
    num_replicas = params.get("num_replicas", 0)
    max_connections = params.get("max_connections", 200)
    shared_buffers = params.get("shared_buffers", "128MB")

    # Generate Terraform Configuration
    generate_terraform_code(instance_type, num_replicas)

    # Run Terraform
    subprocess.run(["terraform", "init"], cwd="terraform", check=True)
    subprocess.run(["terraform", "apply", "-auto-approve"], cwd="terraform", check=True)

    # Get Terraform Output (Server IP)
    result = subprocess.run(["terraform", "output", "-json"], cwd="terraform", capture_output=True, text=True)
    outputs = json.loads(result.stdout)
    server_ip = outputs["server_ip"]["value"]

    # Update Ansible Inventory
    with open("inventory.ini", "w") as f:
        f.write(f"[postgres]\n{server_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./ansible.key ansible_ssh_common_args='-o StrictHostKeyChecking=no'\n")
    
    print("halt for 100sec to start the server")
    time.sleep(100)
    
    # Run Ansible Playbook
    #subprocess.run(["ansible-playbook", "-i", "inventory.ini", "ansible_playbook.yml"], check=True)
    subprocess.run([
    "ansible-playbook", 
    "-i", "inventory.ini", 
    "ansible_playbook.yml",
    "--extra-vars", 
    f"postgres_version={params['postgres_version']} max_connections={params['max_connections']} shared_buffers={params['shared_buffers']}"
    ], check=True)

    return {"status": "PostgreSQL cluster deployed successfully!", "server_ip": server_ip}
