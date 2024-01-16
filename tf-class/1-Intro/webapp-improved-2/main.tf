resource "aws_key_pair" "webapp-keypair" {
  key_name   = "${local.tag_prefix_name}-key"  # Replace with your key pair name
  public_key = file("${path.module}/resources/webapp-key.pub")  # Replace with the path to your public key file
}

resource "aws_instance" "webapp" {
  ami           = var.ami-id
  instance_type = var.instance-type
  subnet_id          = aws_subnet.dev_subnet.id

  key_name = aws_key_pair.webapp-keypair.key_name

  vpc_security_group_ids = [aws_security_group.dev_web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from user data!" > /tmp/user_data_output.txt
              EOF

  tags = {
    Name = "${local.tag_prefix_name}-ec2"
  }
}

resource "aws_network_interface" "dev_web_network_interface" {
  subnet_id          = aws_subnet.dev_subnet.id
  tags = {
    Name = "${local.tag_prefix_name}-eni"
  }

  security_groups = [aws_security_group.dev_web_sg.id]

  depends_on = [aws_instance.webapp]    ###### Explicit Resource dependency ########

  attachment {
    instance     = aws_instance.webapp.id
    device_index = 1
  }
}



