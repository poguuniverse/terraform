resource "aws_key_pair" "common-keypair" {
  count = var.create_instance ? 1 : 0

  key_name   = "${var.tag_prefix_name}-key"
  public_key = file("${path.module}/resources/common-key.pub")
}

resource "aws_instance" "common" {
  count = var.create_instance ? 1 : 0

  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  key_name = aws_key_pair.common-keypair[0].key_name

  vpc_security_group_ids = [aws_security_group.common_sg.id]

  user_data = templatefile("${path.module}/resources/common_userdata.tpl", var.instance_config)

  tags = {
    Name = "${var.tag_prefix_name}-ec2"
  }
}

resource "aws_network_interface" "common_network_interface" {
  count = var.create_instance ? 1 : 0

  subnet_id = var.subnet_id
  tags = {
    Name = "${var.tag_prefix_name}-eni"
  }

  security_groups = [aws_security_group.common_sg.id]

  depends_on = var.create_instance ? [aws_instance.common] : []
}