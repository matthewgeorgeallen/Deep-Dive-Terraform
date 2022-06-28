##################################################################################
# DATA SOURCES
##################################################################################

data "consul_keys" "applications" {
  key {
    name = "applications"
    path = terraform.workspace == "default" ? "applications/configuration/deep-dive-matthewton/app_info" : "applications/configuration/deep-dive-matthewton/${terraform.workspace}/app_info"
  }

  key {
    name = "common_tags"
    path = "applications/configuration/deep-dive-matthewton/common_tags"
  }
}

data "terraform_remote_state" "networking" {
  backend = "consul"

  config = {
    address = "${var.consul_address}:8500"
    scheme  = "http"
    path    = terraform.workspace == "default" ? "networking/state/deep-dive-matthewton" : "networking/state/deep-dive-matthewton-env:${terraform.workspace}"
  }
}

data "aws_ami" "aws_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-20*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
