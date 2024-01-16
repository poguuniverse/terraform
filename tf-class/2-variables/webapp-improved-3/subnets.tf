resource "aws_subnet" "backend_subnets" {
  count = var.backend_subnet_count

  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = slice(var.backend_subnet_cidr_blocks, count.index, count.index + 1)[0]
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "backend-subnet-${count.index + 1}"
  }
}

# Webapp Subnets
resource "aws_subnet" "webapp_subnets" {
  count = var.webapp_subnet_count

  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = slice(var.webapp_subnet_cidr_blocks, count.index, count.index + 1)[0]
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true  # Adjust as needed

  tags = {
    Name = "webapp-subnet-${count.index + 1}"
  }
}
