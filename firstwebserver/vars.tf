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

variable "KEY_NAME" {
  type = string
  default = "public_key"
}

