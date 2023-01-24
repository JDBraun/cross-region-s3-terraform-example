# Cross Region S3 Terraform Workspace Deployment Example


- This example is meant to be an example to assist with trials, proof of concepts, and a foundation for production deployments. 
- There are no guarantees or warranties associated with this example.

# Terraform Script

- **Data Plane Creation:**
    - VPC
    - Workspace Subnets
    - Security Groups
    - NACLs
    - Route Tables
    - AWS VPC Endpoints (S3, Kinesis, STS, Databricks Endpoints)
    - S3 Root Bucket
    - Cross Account - IAM Role
    - S3 Instance Profile - IAM Role

 - **VPC Peer Creation:**   
    - VPC
    - VPC Peering Connection
    - S3 Interface Endpoint
    - Route 53 Zone
    - A name records

- **Workspace Deployment:**
    - Credential Configuration
    - Storage Configuration
    - Network Configuration (Backend PrivateLink Enabled)

- **Post Workspace Deployment:**
    - Data Engineering Cluster 
    - Instance Profile Registration

# Getting Started

1. Clone this Repo 

2. Install [Terraform](https://developer.hashicorp.com/terraform/downloads)

3. Fill out `example.tfvars` and place in `aws` directory

5. CD into `aws`

5. Run `terraform init`

6. Run `terraform validate`

7. From `aws` directory, run `terraform plan -target=module.independent_cross_region_aws_assets -var-file ../example.tfvars`

8. Run `terraform apply -target=module.independent_cross_region_aws_assets -var-file ../example.tfvars`

9. Run `terraform apply -var-file ../example.tfvars`


# Network Diagram

![Architecture Diagram](https://github.com/JDBraun/cross-region-s3-terraform-example/blob/master/img/Cross%20Region%20S3%20-%20Network%20Topology.png)
