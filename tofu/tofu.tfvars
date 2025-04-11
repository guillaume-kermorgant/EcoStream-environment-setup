ec2_conf = {
  ami_id        = "ami-0669b163befffbdfc"
  instance_type = "t2.micro"
  instance_name = "ecostream-${var.env_name}"
}
