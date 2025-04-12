resource "aws_instance" "ec2_instance" {
  ami           = var.ec2_conf["ami_id"]
  instance_type = var.ec2_conf["instance_type"]

  tags = {
    Name = "${var.ec2_conf["instance_name_prefix"]}-${var.env_name}"
  }
}

# resource "aws_vpc" "example" {
#   cidr_block = "10.0.0.0/16"
# }
