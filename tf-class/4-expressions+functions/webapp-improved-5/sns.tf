# Resources
resource "aws_sns_topic" "sns_topics" {
  for_each = var.sns_topics

  name         = each.key
  display_name = each.value

  # You can add tags here if needed
}

