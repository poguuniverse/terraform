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