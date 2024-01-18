resource "aws_security_group" "common_sg" {
  name        = "common-sg"
  description = "Security group for common resources"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.tag_prefix_name}-common-sg"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "common_allow_ssh" {
  security_group_id = aws_security_group.common_sg.id

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "common_allow_http" {
  security_group_id = aws_security_group.common_sg.id

  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "common_allow_additional_ports" {
  security_group_id = aws_security_group.common_sg.id

  type        = "ingress"
  from_port   = each.value
  to_port     = each.value
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  for_each = var.allowed_ports
}
