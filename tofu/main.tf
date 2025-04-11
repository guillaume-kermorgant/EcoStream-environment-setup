provider "aws" {
  region = var.region
}

resource "aws_instance" "free_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "gitlab-opentofu-ec2"
  }
}
