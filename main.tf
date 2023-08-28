provider "aws" {
  region = "ap-south-1"  # Update this to your desired AWS region
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"  # Update this to an available zone in your region
}

# Create private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1a"  # Update this to an available zone in your region
}

# Create EC2 instance in the public subnet
resource "aws_instance" "my_instance" {
  ami           = "ami-0f5ee92e2d63afc18"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id

  root_block_device {
    volume_size = 9
    volume_type = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name    = "MyEC2Instance"
    purpose = "Assignment"
  }
}

# Create security group
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "My security group"

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
}

# Attach security group to the EC2 instance
resource "aws_instance" "my_instance2" {
   
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"  # Specify the desired instance type
  # Other configuration settings for the instance

  security_groups = [aws_security_group.my_security_group.name]
}
