provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Select only the first two availability zones
locals {
  selected_azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

output "selected_azs" {
  value = local.selected_azs
}

# Create the VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_id}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project_name
  }
}

# # Create an Internet Gateway for public subnet connectivity
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_id}-${var.environment}-igw"
    Environment = var.environment
  }
}

# # Create Public Subnets in each specified Availability Zone
resource "aws_subnet" "public" {
  count                   = length(local.selected_azs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
  availability_zone       = element(local.selected_azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_id}-${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_subnet" "private" {
  count      = length(local.selected_azs)
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index + length(local.selected_azs))

  availability_zone       = element(local.selected_azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_id}-${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment
  }
}


# # Create a Route Table for the Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.project_id}-${var.environment}-public-rt"
    Environment = var.environment
  }
}

# # Associate the Public Subnets with the Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
