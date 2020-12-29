provider "aws" {
  profile = "default"
  region  = "us-east-2"
}


resource "aws_instance" "app" {
  instance_type     = "t2.micro"
  availability_zone = "us-east-2a"
  ami               = "ami-0a0ad6b70e61be944"

  user_data = <<-EOF
              #!/bin/bash
              sudo service apache2 start
              EOF
}


