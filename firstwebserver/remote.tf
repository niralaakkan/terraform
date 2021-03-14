terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "corp-v3"

    workspaces {
      prefix = "firstwebservers-"
    }
  }
}
