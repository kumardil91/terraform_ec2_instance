provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

   tags = var.vpc_tags
}


resource "aws_instance" "app" {
  instance_type     = "t2.micro"
  availability_zone = "us-east-2a"
  ami               = "ami-0a0ad6b70e61be944"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }


  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y httpd
              sudo yum install -y php 
              sudo git clone https://github.com/brikis98/php-app.git /var/www/html/app
              sudo service httpd start
              EOF
}


