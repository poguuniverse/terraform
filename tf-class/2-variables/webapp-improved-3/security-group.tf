resource "aws_security_group" "dev_web_sg" {
  name        = "dev-web-sg"
  description = "Security group for initech web app development"
  vpc_id      = aws_vpc.dev_vpc.id   ########Implicit resource dependency on vpc

  tags = {
    Name        = "${local.tag_prefix_name}-sg"
    Environment = var.environment
  }

}

resource "aws_security_group_rule" "dev_allow_ssh" {
  security_group_id = aws_security_group.dev_web_sg.id    ##### Implicit resource dependency ####

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "dev_allow_http" {
  security_group_id = aws_security_group.dev_web_sg.id

  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

##################################

# Security Group for Backend
resource "aws_security_group" "dev_backend_sg" {
  name        = "dev-backend-sg"
  description = "Security group for initech backend development"
  vpc_id      = aws_vpc.dev_vpc.id

  tags = {
    Name        = "${local.tag_prefix_name}-backend-sg"
    Environment = var.environment
  }
}

# Security Group Rules for Backend
resource "aws_security_group_rule" "dev_backend_allow_ssh" {
  security_group_id = aws_security_group.dev_backend_sg.id

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "dev_backend_allow_app" {
  security_group_id = aws_security_group.dev_backend_sg.id

  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_additional_backend_ports" {
  security_group_id = aws_security_group.dev_backend_sg.id

  type        = "ingress"
  from_port   = each.value
  to_port     = each.value
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  for_each = var.allowed_additional_backend_ports
}

