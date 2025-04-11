resource "aws_instance" "free_ec2" {
  ami           = var.ec2_conf["ami_id"]
  instance_type = var.ec2_conf["instance_type"]

  tags = {
    Name = var.ec2_conf["instance_name"]
  }
}

# resource "aws_vpc" "example" {
#   cidr_block = "10.0.0.0/16"
# }
