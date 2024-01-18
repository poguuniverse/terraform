resource "aws_key_pair" "common-keypair" {
  key_name   = "${var.tag_prefix_name}-key"
  public_key = var.public-key
}

resource "aws_instance" "common" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  key_name = aws_key_pair.common-keypair.key_name

  vpc_security_group_ids = [aws_security_group.common_sg.id]

  user_data = var.user-data

  tags = {
    Name = "${var.tag_prefix_name}-ec2"
  }
}

resource "aws_network_interface" "common_network_interface" {
  subnet_id = var.subnet_id
  tags = {
    Name = "${var.tag_prefix_name}-eni"
  }

  security_groups = [aws_security_group.common_sg.id]

  depends_on = [ aws_instance.common ]
}