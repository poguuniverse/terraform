# main.tf

module "webapp_resources" {
  source = "./ec2-module"

  tag_prefix_name = "webapp"
  environment     = "development"
  create_instance = true
  instance_config = var.frontend_instance_config
  ami_id          = var.ami-id
  instance_type   = var.instance-type
  subnet_id       = aws_subnet.dev_subnet.id
  vpc_id          = aws_vpc.dev_vpc.id
  allowed_ports   = []
}

module "backend_resources" {
  source = "./ec2-module"

  tag_prefix_name = "backend"
  environment     = "development"
  create_instance = var.create_backend_instance
  ami_id          = var.backend_instance_ami
  instance_type   = var.backend_instance_type
  subnet_id       = aws_subnet.dev_subnet.id
  vpc_id          = aws_vpc.dev_vpc.id
  allowed_ports   = var.allowed_additional_backend_ports
  instance_config = var.backend_instance_config
}
