variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AMIS" {
  type = "map"
  default = {
      us-east-1  = "ami-0b898040803850657"
  }
}
variable "instance_type" {
  type = "map"
  default = {
      us-east-1  =  "t2.micro"
  }
}

variable "KEY_NAME" {}

variable "server_port" {
  default = "80"
}


