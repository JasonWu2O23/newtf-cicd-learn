# Configure the AWS Instance
resource "aws_instance" "Jinqing-Server" {
  ami    = "ami-0f34c5ae932e6f0e4" # Amazon Linux 2 LTS
  instance_type = "t2.micro"
  count = 3 # number of AWS instances
  key_name = "JinqingKeyPair" # Use a key created previously on AWS
  associate_public_ip_address = "true"
  subnet_id = "subnet-0b0bde519c41428b1" # points to the subnet from the used VPC                                       
  vpc_security_group_ids = [aws_security_group.jinqing_allow_https_ssh.id] # Points to a previously created security group on AWS
 
  tags = {
    Name = "Jinqing Server ${count.index + 1}"
    Demo = "FIS"
    Version = "2"
  }
}

resource "aws_security_group" "jinqing_allow_https_ssh" {
  name        = "jinqing_allow_https_ssh"
  description = "Allow inbound traffic for https and ssh"

  ingress {
    description      = "HTTPS inbound"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH inbound"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # Equivalent to all
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

terraform {
  backend "s3" {
    bucket = "sctp-ce3-tfstate-bucket"
    region = "us-east-1"
    key    = "jinqing2.tfstate"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}