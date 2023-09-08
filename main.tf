# Configure the AWS Instance
resource "aws_instance" "Jinqing-Server" {
  ami    = "ami-0f34c5ae932e6f0e4" # Amazon Linux 2 LTS
  instance_type = "t2.micro"
  count = 3 # number of AWS instances
  key_name = "JinqingKeyPair" # Use a key created previously on AWS
  associate_public_ip_address = "true"
  subnet_id = "subnet-0b0bde519c41428b1" # points to the subnet from the used VPC                                       
  vpc_security_group_ids = ["sg-062be99ddcfe2f881"] # Points to a previously created security group on AWS
 
  tags = {
    Name = "Jinqing Server ${count.index + 1}"
    Demo = "FIS"
    Version = "2"
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