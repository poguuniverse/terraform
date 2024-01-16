
# Key Pair for Backend
resource "aws_key_pair" "backend-keypair" {
  count = var.create_backend_instance ? 1 : 0  # Conditionally create the key pair based on the boolean variable

  key_name   = "${local.tag_prefix_name}-key"
  public_key = file("${path.module}/resources/backend-key.pub")
}

# Backend EC2 Instance
resource "aws_instance" "backend" {
  count = var.create_backend_instance ? 1 : 0  # Conditionally create the backend EC2 instance based on the boolean variable

  ami           = var.backend_instance_ami
  instance_type = var.backend_instance_type
  subnet_id     = aws_subnet.dev_subnet.id

  key_name = aws_key_pair.backend-keypair[0].key_name  # Use the key name from the first element (if created)

  vpc_security_group_ids = [aws_security_group.dev_backend_sg.id]

  user_data = templatefile("${path.module}/resources/backend_userdata.tpl", var.frontend_instance_config)

  tags = {
    Name = "${local.tag_prefix_name}-ec2"
  }
}

resource "aws_network_interface" "dev_backend_network_interface" {
  count = var.create_backend_instance ? 1 : 0  # Conditionally create the network interface based on the boolean variable

  subnet_id = aws_subnet.dev_subnet.id
  tags = {
    Name = "${local.tag_prefix_name}-eni"
  }

  security_groups = [aws_security_group.dev_backend_sg.id]

  depends_on = var.create_backend_instance ? [aws_instance.backend] : []  # Explicit Resource dependency only if backend instance is created

  attachment {
    instance     = aws_instance.backend[0].id  # Use the instance ID from the first element (if created)
    device_index = 1
  }
}
