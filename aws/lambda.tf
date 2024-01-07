
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  # Define policy here if needed
}

data "aws_iam_policy_document" "lambda_administrator_policy" {
  statement {
    effect = "Allow"

    actions = ["*"]

    resources = ["*"]
  }
}

data "archive_file" "lambda_1" {
  type        = "zip"
  source_dir  = "uploadClaimToS3"
  output_path = "${path.module}/.terraform/archive_files/uploadClaimToS3.zip"

  depends_on = [null_resource.lambda_1]
}

# Provisioner to install dependencies in lambda package
resource "null_resource" "lambda_1" {

  triggers = {
    updated_at = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
    sleep 2
    EOF

    working_dir = "${path.module}/uploadClaimToS3"
  }
}

resource "aws_lambda_function" "lambda_1" {
  filename      = "${path.module}/.terraform/archive_files/uploadClaimToS3.zip"  # Replace with the path to your Lambda code ZIP file
  function_name = "upload-images-lambda"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "index.handler"
  source_code_hash = data.archive_file.lambda_1.output_base64sha256

  runtime       = "nodejs18.x"
}



data "archive_file" "lambda_2" {
  type        = "zip"
  source_dir  = "ProcessClaims"
  output_path = "${path.module}/.terraform/archive_files/ProcessClaims.zip"

  depends_on = [null_resource.lambda_2]
}

# Provisioner to install dependencies in lambda package before upload it.
resource "null_resource" "lambda_2" {

  triggers = {
    updated_at = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
    sleep 2
    EOF

    working_dir = "${path.module}/ProcessClaims"
  }
}

resource "aws_lambda_function" "lambda_2" {
  filename      = "${path.module}/.terraform/archive_files/ProcessClaims.zip"  # Replace with the path to your Lambda code ZIP file
  function_name = "ProcessClaims"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "app.lambda_handler"
  source_code_hash = data.archive_file.lambda_2.output_base64sha256

  runtime       = "python3.10"
}
resource "aws_apigatewayv2_api" "apigw" {
  api_key_selection_expression = "$request.header.x-api-key"
  description                  = "upload-images-api"
  disable_execute_api_endpoint = false
  name                         = "upload-images-api"
  protocol_type                = "HTTP"
  tags                         = {}
  tags_all                     = {}

  cors_configuration {
    allow_credentials = false
    allow_headers     = []
    allow_methods     = []
    allow_origins     = [
      "http://*",
    ]
    expose_headers    = []
    max_age           = 0
  }
}

# aws_apigatewayv2_stage.upload_images_gw:
resource "aws_apigatewayv2_stage" "apigw" {
  api_id          = aws_apigatewayv2_api.apigw.id
  auto_deploy     = true
  name            = "default"
  stage_variables = {}
  tags            = {}
  tags_all        = {}

  default_route_settings {
    data_trace_enabled       = false
    detailed_metrics_enabled = false
    throttling_burst_limit   = 0
    throttling_rate_limit    = 0
  }
}

# Attach Lambda to API Gateway
resource "aws_apigatewayv2_integration" "apigw" {
  api_id = aws_apigatewayv2_api.apigw.id
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.lambda_1.arn #"arn:aws:lambda:us-east-2:767925479794:function:my-lambda-function"
  payload_format_version = "2.0"
  request_parameters     = {}
  request_templates      = {}
  timeout_milliseconds   = 30000
}

resource "aws_apigatewayv2_route" "apigw" {
  api_id = aws_apigatewayv2_api.apigw.id
  route_key            = "ANY /{path+}"
  target               = "integrations/${aws_apigatewayv2_integration.apigw.id}"
  api_key_required     = false
  authorization_scopes = []
  authorization_type   = "NONE"
  request_models       = {}
}