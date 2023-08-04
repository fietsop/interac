provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
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