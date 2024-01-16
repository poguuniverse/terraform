resource "aws_security_group" "example" {
  name        = "${var.env}-example-security-group"
  description = "Example Security Group"
  vpc_id      = data.aws_vpc.default.id

  lifecycle {
    create_before_destroy = true
  }
}

# Ingress rule for SSH access from specific CIDR block
resource "aws_security_group_rule" "ssh_ingress" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["10.0.1.0/24"]  # Replace with your CIDR block
  security_group_id = aws_security_group.example_security_group.id
}

# Ingress rule for HTTP access from another security group
resource "aws_security_group_rule" "app_ingress" {
  count = length(var.ingress_ports)

  type              = "ingress"
  from_port         = [element(var.ingress_ports, count.index)]
  to_port           = [element(var.ingress_ports, count.index)]
  protocol          = "tcp"
  cidr_blocks = ["10.0.1.0/24"]
  security_group_id = aws_security_group.example.id
}

# Egress rule allowing all traffic to a specific CIDR block
resource "aws_security_group_rule" "app_egress" {
  count = length(var.egress_ports)

  type              = "egress"
  from_port         = [element(var.egress_ports, count.index)]
  to_port           = [element(var.egress_ports, count.index)]
  protocol          = "tcp"
  cidr_blocks = ["10.0.1.0/24"]
  security_group_id = aws_security_group.example.id
}
