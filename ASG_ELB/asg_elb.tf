provider "aws" {
  region = "${var.AWS_REGION}"
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
}

data "aws_availability_zones" "all" {}


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
    cidr_blocks = ["52.216.0.0/16"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["52.216.0.0/16"]
  }
}

resource "aws_launch_configuration" "asg_config" {
    image_id  = "${lookup(var.AMIS, var.AWS_REGION)}"
    instance_type  = "t2.micro"
    name_prefix   = "webserver-"
    security_groups = ["${aws_security_group.webserver.id}"]
    key_name = "${var.KEY_NAME}"
    
    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install httpd -y
                service httpd start
                chkconfig httpd on
                cd /var/www/html
                echo "<html><h1>Hello from first webserver</h1></html>" > index.html
                EOF
    lifecycle {
        create_before_destroy=true
    }
}

resource "aws_autoscaling_group" "asg_group" {
    launch_configuration = "${aws_launch_configuration.asg_config.id}"
    availability_zones = ["${data.aws_availability_zones.all.names}"]

    load_balancers = ["${aws_elb.web_elb.name}"]
    health_check_type = "ELB"

    min_size = 2
    max_size = 4

    tag {
        key =  "Name"
        value   = "Terraform-asg-group"
        propagate_at_launch = true
    }
}

resource "aws_security_group" "web_elb_scg"{
    name = "terraform-web-elb"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_elb" "web_elb" {
    name = "terraform-asg-group"
    availability_zones = ["${data.aws_availability_zones.all.names}"]
    security_groups = ["${aws_security_group.web_elb_scg.id}"]
    listener {
        lb_port = 80
        lb_protocol = "http"
        instance_port = "${var.server_port}"
        instance_protocol = "http"
    }
    health_check {
        healthy_threshold = 5
        unhealthy_threshold = 5
        timeout = 3
        interval = 30
        target = "HTTP:${var.server_port}/index.html"
    }
}

output "elb_dns_name" {
    value = "${aws_elb.web_elb.dns_name}"
}