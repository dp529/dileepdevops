# DevOps Portfolio - Terraform, Ansible, Docker & GitHub Actions

End-to-end DevOps reference setup demonstrating multi-tier AWS infrastructure provisioned with **Terraform**, server configuration with **Ansible**, containerization with **Docker**, and a complete **GitHub Actions** CI/CD pipeline that deploys to **Amazon EKS** via **ArgoCD** (GitOps).

---

## Architecture Overview

```
   Developer Push (GitHub)
         |
         v
   GitHub Actions Pipeline
   +------------------------+
   | 1. SonarQube scan      |  <- static code analysis
   | 2. Docker build        |
   | 3. Push to Amazon ECR  |
   | 4. Trivy CVE scan      |  <- block CRITICAL/HIGH
   | 5. Update GitOps repo  |
   +------------------------+
         |
         v
   ArgoCD (auto-sync)
         |
         v
   Amazon EKS - Dev / Staging / Cert / Prod
```

Infrastructure underneath is provisioned and configured by:
- **Terraform** -> VPC, subnets (public/private), routing, security groups, EC2, VPC peering, S3 remote backend
- **Ansible** -> server configuration, Nginx/Redis deployment, Jinja2 templating, secrets via Ansible Vault

---

## Repository Structure

```
dileepdevops/
├── terraform/                  # AWS infrastructure as code
│   ├── 1.provider.tf            # AWS provider + S3 remote backend
│   ├── 2.vpc.tf                 # VPC
│   ├── 3.public-subnets.tf
│   ├── 4.private-subnets.tf
│   ├── 5.public-routing.tf
│   ├── 6.private-routing.tf
│   ├── 7.ec2.tf                 # EC2 instances (multi-tier)
│   ├── 8.sg.tf                  # Security groups
│   ├── 9.vpc-peering.tf
│   ├── 10.locals.tf
│   ├── 11.localfile_ansible_inventory.tf   # Generates Ansible inventory from Terraform
│   ├── 12.localfile_ansible_inventory_yaml.tf
│   ├── 13.null-local-exec.tf    # Triggers Ansible after provisioning
│   ├── 14.outputs.tf
│   ├── 16.variables.tf
│   ├── *.tpl                    # Ansible inventory templates
│   └── terraform.tfvars.example # Copy to terraform.tfvars and fill in
│
├── ansible/                    # Server configuration
│   ├── dynamic_aws_ec2.yaml     # Dynamic AWS EC2 inventory plugin
│   ├── dummy_inventory.example
│   └── playbooks/
│       ├── 0.addhoc-cmds/        # shell vs command vs raw
│       ├── 1.nginx/              # Nginx local + remote deployment
│       ├── 2.Redis_Ansible_facts/# Redis with Ansible facts
│       ├── 3.Jinja/              # Jinja2 templating (Nginx, MySQL)
│       └── 4.Ansible_Vault/      # Secrets management with Ansible Vault
│
├── docker/                     # Container image definition
│   └── Dockerfile               # Multi-stage, non-root, healthcheck
│
└── .github/workflows/
    └── ci-cd.yml                # 4-stage pipeline (Sonar -> Build -> Trivy -> GitOps)
```

---

## Key Technologies Demonstrated

| Area | Tools / Practices |
|---|---|
| Cloud | AWS (EC2, S3, VPC, IAM, ECR, EKS) |
| Infrastructure as Code | Terraform (modules, remote state in S3, multi-tier networking, VPC peering) |
| Configuration Management | Ansible (playbooks, roles, dynamic inventory, Jinja2, Vault) |
| Containers | Docker (multi-stage build, non-root user, healthcheck) |
| CI/CD | GitHub Actions (multi-stage pipeline with OIDC to AWS) |
| GitOps | ArgoCD (auto-sync from manifest repo) |
| Security Scanning | SonarQube (SAST), Trivy (container CVE scan) |
| Orchestration | Amazon EKS, Kubernetes manifests |

---

## How the Pieces Fit Together

### 1. Terraform provisions AWS infrastructure
The `terraform/` directory creates a complete VPC with public + private subnets across multiple AZs, EC2 instances, security groups, and **automatically generates an Ansible inventory file** from the provisioned EC2 IPs (`11.localfile_ansible_inventory.tf`).

### 2. Ansible configures the servers
Once Terraform creates the EC2 instances, Ansible reads the generated inventory and runs playbooks to install Nginx, Redis, deploy app configs via Jinja2 templates, and manage secrets through Ansible Vault.

### 3. Docker containerizes the app
A multi-stage Dockerfile with build/runtime separation, non-root user, healthcheck, and slim base image - ready for production.

### 4. GitHub Actions runs the pipeline
On every push, the pipeline:
1. Runs **SonarQube** static analysis with quality gate
2. Builds the Docker image and pushes to **Amazon ECR**
3. Scans the image with **Trivy** for CRITICAL/HIGH CVEs (blocks pipeline on findings)
4. Updates the GitOps manifest repo, which **ArgoCD** watches and auto-syncs to EKS

### 5. ArgoCD deploys to EKS
ArgoCD continuously reconciles the Kubernetes manifests in the GitOps repo against the EKS cluster - zero manual `kubectl apply` ever needed.

---

## Running Locally

### Terraform
```bash
cd terraform/
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan
terraform apply
```

### Ansible
```bash
cd ansible/
ansible-playbook -i inventory playbooks/1.nginx/3.nginx-remote.yml
```

### Docker
```bash
docker build -t myapp:latest -f docker/Dockerfile .
docker run -p 8000:8000 myapp:latest
```

---

## About

Reference repository demonstrating production-grade DevOps practices.

**Author**: Dileep Mundluri
**LinkedIn**: linkedin.com/in/dileep-mundluri
