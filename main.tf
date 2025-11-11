terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.94.1"
    }

    aws = {
      source = "hashicorp/aws"
      version = "5.70.0"
    }
  }
  required_version = ">= 0.15"
}

provider "hcp" {}

provider "aws" {
  region = var.region
}

data "hcp_packer_version" "ubuntu" {
  bucket_name  = "ubuntu-hardened-images"
  channel_name = "latest"
}

data "hcp_packer_artifact" "ubuntu_us-east-1" {
  bucket_name         = "ubuntu-hardened-images"
  platform            = "aws"
  version_fingerprint = data.hcp_packer_version.ubuntu.fingerprint
  region              = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = data.hcp_packer_artifact.ubuntu_us-east-1.external_identifier
  instance_type = "t2.micro"
  tags = {
    Name = "your-terraform-with-packer-instance"
  }
}
