terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.31.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

module "ec2" {
  source        = "./modules/ec2-provisioning/"
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name




}