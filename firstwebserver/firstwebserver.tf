terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.AWS_REGION
}

resource "aws_instance" "firstwebserver" {
    ami  = "${lookup(var.AMIS, var.AWS_REGION)}"
    instance_type  = "${lookup(var.instance_type, var.AWS_REGION)}"
    vpc_security_group_ids = ["${aws_security_group.webserver.id}"]
    key_name = "${var.KEY_NAME}"
    tags = {
        Name = "First webserver"
    }
    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install httpd -y
                service httpd start
                chkconfig httpd on
                cd /var/www/html
                echo "<html><h1>Hello from first webserver</h1></html>" > index.html
                EOF
}

resource "aws_security_group" "webserver" {
  name = "webserver SG"
  description = "Created by Madanraj"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


output "public_ip" {
    value = "${aws_instance.firstwebserver.public_ip}"
}
