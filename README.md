# Terraform AWS Mini Project
This is a **beginner-level Terraform project** created while following a **freeCodeCamp tutorial** on Infrastructure as Code (IaC).  
It demonstrates how to provision basic AWS resources using Terraform and serves as a learning exercise for Terraform and AWS.

---

## Project Overview

This project provisions the following AWS resources:

1. **VPC (Virtual Private Cloud)** – A custom VPC with CIDR block `10.0.0.0/16`.
2. **Subnet** – A subnet inside the VPC (`10.0.1.0/24`).
3. **Internet Gateway** – Provides internet connectivity to the VPC.
4. **Route Table** – Custom route table connecting the subnet to the Internet Gateway.
5. **Security Group** – Allows inbound traffic for:
   - HTTP (80)
   - HTTPS (443)
   - SSH (22)
6. **Network Interface** – Private network interface inside the subnet.
7. **Elastic IP** – Assigned to the network interface.
8. **EC2 Instance** – Ubuntu server with Apache installed via `user_data`.

---

## Architecture Diagram
VPC (10.0.0.0/16)
└── Subnet (10.0.1.0/24)
└── Network Interface (10.0.1.50)
└── EC2 Instance (Ubuntu + Apache)
Internet Gateway → Route Table → Subnet
Security Group → Allows HTTP, HTTPS, SSH
Elastic IP → Assigned to Network Interface

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed.
- AWS account with CLI configured:

```bash
aws configure

---

## How to Run

1. **Clone the repository:**
```bash
git clone https://github.com/smilercompiler/terraform-aws-mini-project.git
cd terraform-aws-mini-project
2. Initialize Terraform:
terraform init
3. Preview the plan:
terraform plan
4. Apply the configuration:
terraform apply
- Type yes when prompted to confirm.
- Terraform will provision the AWS resources defined in the code.
5. Destroy resources when done (to avoid AWS charges):
terraform destroy


