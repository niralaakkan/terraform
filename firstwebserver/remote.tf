terraform {
  backend "remote" {
    organization = "corp-v3"

    workspaces {
      name = "terraform"
    }
  }
}
