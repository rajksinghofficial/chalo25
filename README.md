# Step to execute:
1. Create a ansible.key file on path parallel to playbook which will be to ssh in the server.
2. install req: ```  pip install  -r requirements.txt ```
3. Example API : ```
4.      curl -X POST http://localhost:8000/initiate \
          -H "Content-Type: application/json" \
          -d '{
            "postgres_version": "16",
            "instance_type": "t2.medium",
            "num_replicas": 0,
            "max_connections": 200,
            "shared_buffers": "128MB"
          }'
   ```
   Pls make sure terraform and ansible is installed in the server.

   
