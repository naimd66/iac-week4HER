terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }
}

resource "null_resource" "deploy_vms" {
  provisioner "local-exec" {
    command = "./deploy.sh"
  }
}