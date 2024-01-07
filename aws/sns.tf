data "aws_iam_policy_document" "notify_image_upload" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["SNS:Publish"]
    resources = ["arn:aws:sns:*:*:s3-event-notification-topic"]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.claims_bucket.arn]
    }
  }

  statement {
    sid       = "sqs_statement"
    effect    = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sqs.amazonaws.com"]
    }

    actions   = ["sns:Subscribe"]
    resources = ["arn:aws:sns:*:*:s3-event-notification-topic"]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:sqs:us-east-2:767925479794:*"]
    }
  }
}
resource "aws_sns_topic" "notify_image_upload" {
  name   = "s3-event-notification-topic"
  policy = data.aws_iam_policy_document.notify_image_upload.json
}


resource "aws_s3_bucket_notification" "notify_image_upload" {
  bucket = aws_s3_bucket.claims_bucket.id

  topic {
    topic_arn     = aws_sns_topic.notify_image_upload.arn
    events        = ["s3:ObjectCreated:*"]
    #filter_suffix = ".jpeg"
  }
}


resource "aws_sns_topic_subscription" "sqs_subscription" {
  protocol             = "sqs"
  raw_message_delivery = true
  topic_arn            = aws_sns_topic.notify_image_upload.arn
  endpoint             = aws_sqs_queue.Process-Claims-Queue.arn
}