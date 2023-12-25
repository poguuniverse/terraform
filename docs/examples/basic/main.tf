# Create a Security Group for an EC2 instance 
resource "aws_security_group" "security_grp" {
  name = "terraform-example-security-group"
  
  ingress {
    from_port	  = "${var.server_port}"
    to_port	    = "${var.server_port}"
    protocol	  = "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }
}
