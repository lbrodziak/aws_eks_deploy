# Specifies the Terraform version and required providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" # Use the AWS provider from HashiCorp
      version = "~> 5.0"        # Ensures compatibility with AWS provider version 5.x
    }
  }
}

# Configures the AWS provider with the default region
provider "aws" {
  region = "us-east-1" # The AWS region to deploy resources
}

# Creates a Virtual Private Cloud (VPC)
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16" # IP address range for the VPC
  enable_dns_hostnames = true          # Enable DNS hostnames for instances in this VPC
}

# Creates the first public subnet
resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.main.id      # Associates subnet with the created VPC
  cidr_block              = "10.0.0.0/20"       # IP address range for this subnet
  availability_zone       = "us-east-1b"        # Specify the availability zone
  map_public_ip_on_launch = true                # Automatically assign public IP to instances
}

# Creates the second public subnet
resource "aws_subnet" "subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.16.0/20"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true
}

# Creates the third public subnet
resource "aws_subnet" "subnet_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.32.0/20"
  availability_zone       = "us-east-1d"
  map_public_ip_on_launch = true
}

# Creates an Internet Gateway (IGW) for VPC to access the internet
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main.id
}

# Creates a route table for managing network routing
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  # Route to allow traffic to the internet
  route {
    cidr_block = "0.0.0.0/0"                     # Default route for all traffic
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  # Local route for communication within the VPC
  route {
    cidr_block = "10.0.0.0/16"                   # Local VPC CIDR block
    gateway_id = "local"
  }
}

# Associates the first subnet with the route table
resource "aws_route_table_association" "subnet_1_association" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route_table.id
}

# Associates the second subnet with the route table
resource "aws_route_table_association" "subnet_2_association" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.route_table.id
}

# Associates the third subnet with the route table
resource "aws_route_table_association" "subnet_3_association" {
  subnet_id      = aws_subnet.subnet_3.id
  route_table_id = aws_route_table.route_table.id
}

# Creates an EKS cluster using the AWS EKS Terraform module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"  # Source of the EKS module
  version = "~> 20.0"                        # Module version

  cluster_name                     = "my-project"  # Name of the EKS cluster
  cluster_version                  = "1.28"        # Kubernetes version for the cluster
  cluster_endpoint_public_access   = true          # Allow public access to the EKS endpoint

  vpc_id                   = aws_vpc.main.id                         # VPC for the cluster
  subnet_ids               = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id, aws_subnet.subnet_3.id] # Subnets for worker nodes
  control_plane_subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id, aws_subnet.subnet_3.id] # Subnets for control plane

  # Configuration for a managed node group
  eks_managed_node_groups = {
    green = {
      min_size       = 1                # Minimum number of nodes
      max_size       = 1                # Maximum number of nodes
      desired_size   = 1                # Desired number of nodes
      instance_types = ["t3.micro"]    # Instance type for worker nodes
    }
  }
}
