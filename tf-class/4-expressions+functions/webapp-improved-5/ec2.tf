# main.tf

module "webapp_resources" {
  source = "./ec2-module"

  tag_prefix_name = "webapp"
  environment     = "development"
  public-key      = file("${path.module}/resources/webapp-key.pub")
  user-data       = templatefile("${path.module}/resources/backend_userdata.tpl", var.frontend_instance_config)
  ami_id          = var.ami-id
  instance_type   = var.instance-type
  subnet_id       = aws_subnet.dev_subnet.id
  vpc_id          = aws_vpc.dev_vpc.id
  allowed_ports   = {}
}

module "backend_resources" {
  source = "./ec2-module"

  public-key      = file("${path.module}/resources/webapp-key.pub")
  tag_prefix_name = "backend"
  environment     = "development"
  user-data       = templatefile("${path.module}/resources/backend_userdata.tpl", var.backend_instance_config)
  ami_id          = var.backend_instance_ami
  instance_type   = var.backend_instance_type
  subnet_id       = aws_subnet.dev_subnet.id
  vpc_id          = aws_vpc.dev_vpc.id
  allowed_ports   = var.allowed_additional_backend_ports
}
