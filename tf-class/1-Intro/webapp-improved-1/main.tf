resource "aws_instance" "web" {
  ami           = var.ami-id
  instance_type = var.instance-type

  tags = var.instance-tags
}
