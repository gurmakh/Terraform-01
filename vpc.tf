resource "aws_vpc" "prod" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  assign_generated_ipv6_cidr_block = "true"
  tags = {
    Name = "TerraformVpcProd"
  }
}

resource "aws_internet_gateway" "sidhu-prod-igw" {
  vpc_id = aws_vpc.prod.id

  tags = {
    Name = "TerraformProdIGW"
  }
}

resource "aws_subnet" "pub-sn" {
  vpc_id                  = aws_vpc.prod.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "Terraform-pub-sn01"
  }
}


resource "aws_route_table" "prod-pub-rt01" {
  vpc_id = aws_vpc.prod.id
  
  route {
    cidr_block ="0.0.0.0/0"
    gateway_id = aws_internet_gateway.sidhu-prod-igw.id
  } 
}

resource "aws_route_table_association" "pub-sn-rt-association" {
  subnet_id =  aws_subnet.pub-sn.id
  route_table_id = aws_route_table.prod-pub-rt01.id
}

resource "aws_subnet" "pri-sn" {
  vpc_id = aws_vpc.prod.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Terraform-pri-sn01"
  }
}