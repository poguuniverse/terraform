output "instance_ids" {
  description = "IDs of the created instance"
  value       = aws_instance.common.id
}
