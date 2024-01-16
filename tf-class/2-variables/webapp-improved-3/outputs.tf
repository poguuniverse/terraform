output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.dev_vpc.id
}

output "instance_ids" {
  description = "IDs of the created instance"
  value       = aws_instance.webapp.id
}
