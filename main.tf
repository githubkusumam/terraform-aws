terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # Configuration options
}


resource "aws_vpc" "kusumamvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "kusumamvpc"
  }
  enable_dns_hostnames = true
}

resource "aws_subnet" "kusumamsubnet" {
  vpc_id     = aws_vpc.kusumamvpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name : "kusumamsubnet"
  }

}

resource "aws_internet_gateway" "kusumamigw" {
  vpc_id = aws_vpc.kusumamvpc.id
}
resource "aws_route_table" "kusumamrt" {
  vpc_id = aws_vpc.kusumamvpc.id
}
resource "aws_route" "kusumamroute" {
  route_table_id         = aws_route_table.kusumamrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.kusumamigw.id

}
resource "aws_route_table_association" "kusumamrt_association" {
  route_table_id = aws_route_table.kusumamrt.id
  subnet_id      = aws_subnet.kusumamsubnet.id
}
resource "aws_security_group" "kusumam-sg" {
  name        = "Allow_All"
  vpc_id      = aws_vpc.kusumamvpc.id
  description = "Allow_All_traffic"
  ingress {
    description = "Allow_All"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow_All"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

}
resource "aws_instance" "kusumamec2" {
  ami                         = "ami-012967cc5a8c9f891"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.kusumamsubnet.id
  key_name                    = "newkeypair"
  vpc_security_group_ids      = [aws_security_group.kusumam-sg.id]
  associate_public_ip_address = true
  user_data                   = <<EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install httpd -y
  sudo systemctl start httpd
  sudo systemctl enable httpd
  echo "<h1> Welcome to AWS Terraform!!!. This Ec2 Instance is created using Terraform </h1>" >/var/www/html/index.html
  EOF
  tags = {
    Name = "Apache WebServer"
  }

}
