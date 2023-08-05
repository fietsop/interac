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
resource "aws_route_table_association" "Dev01-pubRT-Assc" {
  subnet_id = aws_subnet.main-privatesubnet.id
  route_table_id = aws_route_table.Dev01-privateRT.id
}
