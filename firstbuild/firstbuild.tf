provider "aws" {
  region = "${var.AWS_REGION}"
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
}

resource "aws_instance" "firstbuild" {
    ami  = "${lookup(var.AMIS, var.AWS_REGION)}"
    instance_type  = "${lookup(var.instance_type, var.AWS_REGION)}"
    tags {
        Name = "First build"
    }
}