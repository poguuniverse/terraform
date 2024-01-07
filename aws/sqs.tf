resource "aws_sqs_queue" "Process-Claims-Queue" {
  name                      = "Process-Claims"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  tags = {
    Environment = "production"
  }
}

resource "aws_sqs_queue_policy" "orders_to_process_subscription" {
  queue_url = aws_sqs_queue.Process-Claims-Queue.id
  policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": [
        "sqs:SendMessage"
      ],
      "Resource": [
        "${aws_sqs_queue.Process-Claims-Queue.arn}"
      ],
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.notify_image_upload.arn}"
        }
      }
    },
   {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": [
        "sqs:SendMessage",
        "sqs:ReceiveMessage"
      ],
      "Resource": [
        "${aws_sqs_queue.Process-Claims-Queue.arn}"
      ],
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_lambda_function.lambda_2.arn}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_lambda_event_source_mapping" "lambda_2" {
  event_source_arn  = aws_sqs_queue.Process-Claims-Queue.arn
  function_name     = aws_lambda_function.lambda_2.arn
  batch_size        = 1
}