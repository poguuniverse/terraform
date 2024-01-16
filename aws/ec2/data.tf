data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_vpc" "default" {
  default = true

  filter {
    name   = "owner-id"
    values = [data.aws_caller_identity.current.account_id]
  }
}

data "aws_subnet" "example" {
  vpc_id = data.aws_vpc.default.id  #

  tags = var.subnet_lookup_tags
  availability_zone = "us-east-1e"
}

data "aws_subnet" "exclude" {
  vpc_id = data.aws_vpc.default.id  #

  filter{
    tag = "exclude-subnet"
  }
  availability_zone = "us-east-1e"
}

data "template_cloudinit_config" "user_data" {
 for_each = var.instance_metadata

  part {
    content_type = "text/x-shellscript"
    filename     = templatefile("${path.module}/bootstrap/userdata.sh.tpl, {
      hostname = each.value.hostname
    }
    )
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true

  owners = [data.aws_caller_identity.current.account_id]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}



