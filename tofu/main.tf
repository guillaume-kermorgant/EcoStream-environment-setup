resource "aws_instance" "free_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "gitlab-opentofu-ec2"
  }
}

# resource "aws_vpc" "example" {
#   cidr_block = "10.0.0.0/16"
# }
