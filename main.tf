# configure aws provider
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
  #profile = "Admin"
}

# Create VPC
resource "aws_vpc" "dp5vpc" {
  cidr_block              = "10.0.0.0/16"
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = var.vpc_name
  }
}

# Create a subnet within the VPC
resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.dp5vpc.id 
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.pub_subnetA_az
  map_public_ip_on_launch = true

  tags      = {
    Name    = var.pub_subnetA_name
  }
}

# Create a subnet within the VPC
resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.dp5vpc.id 
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.pub_subnetB_az
  map_public_ip_on_launch = true

  tags      = {
    Name    = var.pub_subnetB_name
  }
}

# Create instance to configure Jenkins server
resource "aws_instance" "app_server" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.subnet_a.id
  security_groups = [aws_security_group.dp5SG_app_server.id]
  key_name = var.key_name

  user_data = "${file("deploy.sh")}"

  tags = {
    "Name" : var.instance_A_name
  }

}

# Create instance to configure application server
resource "aws_instance" "webApp_server" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.subnet_b.id
  security_groups = [aws_security_group.dp5SG_web_server.id]
  key_name = var.key_name



  tags = {
    "Name" : var.instance_B_name
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dp5vpc.id

  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "dp5_route_table" {
  vpc_id = aws_vpc.dp5vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.route_table_name
  }
}

# associate route table with subnets
resource "aws_route_table_association" "dp5_RT_subnetA" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.dp5_route_table.id
}

resource "aws_route_table_association" "dp5_RT_subnetB" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.dp5_route_table.id
}

output "instance_ips" {
  description = "IDs of the instances created"
  value = {
    app_server_instance = aws_instance.app_server.id,
    webApp_server_instance = aws_instance.webApp_server.id
  }
} 

# Create Security Groups

resource "aws_security_group" "dp5SG_app_server" {
  name        = "dp5SG_app_server"
  description = "open ssh traffic"
  vpc_id = aws_vpc.dp5vpc.id 


  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

    ingress {
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : var.security_groups_name
    "Terraform" : "true"
  }

}

# Create Security Groups

resource "aws_security_group" "dp5SG_web_server" {
  name        = "dp5SG_web_server"
  description = "open ssh traffic"
  vpc_id = aws_vpc.dp5vpc.id 


  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

    ingress {
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : var.security_groups_name
    "Terraform" : "true"
  }

}
