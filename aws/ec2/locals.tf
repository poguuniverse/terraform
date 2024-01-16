locals{
  subnet_ids = [for subnet in tolist(data.aws_subnet.example.ids): subnet if subnet !=data.aws_subnet.exclude.id]

  app-tag-name = format("var.app_name-%s", lower(var.env))
}


