# Creating an EC2 key pair
resource "aws_key_pair" "example" {
  key_name   = var.key-name  # Read from variables
  public_key = file("${path.module}/ec2_key.pub")
 # public_key = var.ssh-public-key file("~/.ssh/your_key_pair.pub")
}

resource "aws_network_interface" "example" {
  for_each = var.instance_metadata

  subnet_id = local.subnet_ids
  security_groups = [aws_security_group.example.id]

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    name = each.value.hostname
    app= local.app-tag-name
  }
}

resource "aws_instance" "example" {
  for_each = var.instance_metadata

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.example.key_name
  iam_instance_profile = aws_iam_instance_profile.example.name

  network_interface {
    network_interface_id = aws_network_interface.example.id
    device_index         = 0
    delete_on_termination = false
  }

metadata_options {
  http_endpoint = "enabled"
}
  user_data = data.template_cloudinit_config.user_data.rendered

  tags = {
    Name = each.value.hostname
    app= local.app-tag-name
  }
}
