variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "us-west-2"
}
variable "AMIS" {
  type = "map"
  default = {
    us-west-2  = "ami-082b5a644766e0e6f"
  }
}
variable "instance_type" {
  type = "map"
  default = {
    us-west-2  =  "t2.micro"
  }
}

