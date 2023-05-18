# Deploying an Inf

# provider "aws" {
#   region = "us-east-1"
# }


resource "aws_vpc" "TF-VPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags                 = merge(var.tags, "${var.Environment}-TF_VPC")
}

resource "aws_internet_gateway" "TF-Igw" {
  vpc_id = aws_vpc.TF-VPC.id
  tags   = merge(var.tags, "${var.Environment}-Igw")
}

resource "aws_subnet" "Public-subnets" {
  vpc_id             = aws_vpc.TF-VPC.id
  cidr_block         = var.public_cidr[0]
  availability_zones = var.azs[0]
  tags               = merge(var.tags, "${var.Environment}-Public_subnet")
}

resource "aws_route_table" "TF-RT" {
  vpc_id = aws_vpc.TF-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.TF-Igw.id
    tags       = merge(var.tags, "${var.Environment}-TF-RT")
  }
}

resource "aws_route_table_association" "RT_Assoc" {
  subnet_id      = aws_subnet.Public-subnets.id
  route_table_id = aws_route_table.TF-RT.id
}

# create a security group
resource "aws_security_group" "project-sg" {
  name        = "Project-sg"
  vpc_id      = aws_vpc.TF-VPC.id
  description = "Inboud and outbound rules for this project"

  dynamic "ingress" {
    for_each = ["80", "8080", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, "${var.Environment}-SG")
}

# Configure ec2 instance to configure Jenkins
resource "aws_instance" "Jenkins_server" {
  ami                         = var.ami[0]
  instance_type               = var.instance_type[0]
  key_name                    = var.key_name[0]
  vpc_security_group_ids      = [aws_security_group.project-sg.id]
  user_data                   = file("jenkin.sh")
  associate_public_ip_address = true
  tags                        = merge(var.tags, "${var.Environment}-Jenkins")

}