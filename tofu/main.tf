provider "aws" {
  region = var.region
}

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "GitLab-Terraform-EC2"
  }
}

output "instance_id" {
  value = aws_instance.example.id
}
