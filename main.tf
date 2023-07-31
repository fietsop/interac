provider "aws" {
    region = "us-east-1"
  
}

resource "aws_vpc" "depop" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      "Name" = "dev01"
    }
  
}
resource "aws_subnet" "dev01pubsub1" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.depop.id

    tags = {
      "Name" = "devpubsubnet1" 
    }
}
resource "aws_subnet" "dev01pubsub2" {
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.depop.id

    tags = {
      "Name" = "devpubsubnet2" 
    }
}
resource "aws_subnet" "dev01prtsub1" {
    cidr_block = "10.0.3.0/24"
    vpc_id = aws_vpc.depop.id

    tags = {
      "Name" = "devprtsubnet1" 
    } 
}
resource "aws_subnet" "dev01prtsub2" {
    cidr_block = "10.0.4.0/24"
    vpc_id = aws_vpc.depop.id

    tags = {
      "Name" = "devprtsubnet2" 
    } 
}
resource "aws_internet_gateway" "dev01igw" {
    vpc_id = aws_vpc.depop.id
  
}

resource "aws_route_table" "dev01_pubrt" {
    vpc_id = aws_vpc.depop.id

    tags = {
      "Name" = "dev01rt"
    }
    
}
resource "aws_instance" "webser" {
    ami = "ami-0f9ce67dcf718d332"
    subnet_id = aws_subnet.dev01prtsub1.id
    instance_type = "t2.micro"

  
}