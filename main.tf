provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    "Name" = "Dev01" 
  }
}
resource "aws_subnet" "main-pubsubnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    "Name" = "Dev01-pubsubnet" 
  }

}
resource "aws_subnet" "main-privatesubnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  tags = {
    "Name" = "Dev01-privatesubnet" 
  }

}
resource "aws_internet_gateway" "Dev01-aws_internet_gateway" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    "Name" = "Dev01-IGW" 
  }
  
}
resource "aws_route_table" "Dev01-pubRT" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "Dev01pubRT" 
  }
  
}
resource "aws_route_table" "Dev01-privateRT" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "Dev01privateRT" 
  }
  
}
resource "aws_route_table_association" "Dev01-pubRT-Assc" {
  subnet_id = aws_subnet.main-pubsubnet.id
  route_table_id = aws_route_table.Dev01-pubRT.id
}
resource "aws_route_table_association" "Dev01-privateRT-Assc" {
  subnet_id = aws_subnet.main-privatesubnet.id
  route_table_id = aws_route_table.Dev01-privateRT.id
}
resource "aws_route" "Dev01pri" {
route_table_id = aws_route_table.Dev01-pubRT.id
gateway_id = aws_internet_gateway.Dev01-aws_internet_gateway.id
destination_cidr_block = "0.0.0.0/0"
  
}
resource "aws_instance" "Dev0-DBserver" {
  ami = "ami-0fb931c44feaa02a9"
  instance_type = "t2.micro"
  key_name = "Ansible2"

}
resource "aws_security_group" "DBserver-aws_security_group" {
name_prefix = "DBserverSG"
description = "DBserverSG"
vpc_id = aws_vpc.main.id

ingress {
from_port = 80
to_port = 80
protocol = "tcp"
security_groups = [aws_alb.Dev01LB.id]

}
}
resource "aws_security_group" "ALB-lb_sg" {
  name        = "ALB-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
}
ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
}
egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to any destination

  }
  tags = {
    "Name" = "albSG"
  }
  
  
}
resource "aws_alb" "Dev01LB" {

  
}

