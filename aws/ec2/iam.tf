resource "aws_iam_role" "ec2_assume_role" {
  name               = "ec2_assume_role"
  assume_role_policy = file("${path.module}"/iam/assume-role-policy.json)
}

resource "aws_iam_policy" "cloudwatch_writepolicy" {
  name        = "cloudwatch_writepolicy"
  description = "Policy to write CloudWatch metrics"
  policy      = templatefile ("${path.module}/iam/cloudwatch-write-policy.json", {
    cloudwatch_log_group_arn = "arn:aws:logs:us-east-1:${data.aws_caller_identity.account_id}:log-group:/ec2/*"
  })
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy" {
  role       = aws_iam_role.ec2_assume_role.name
  policy_arn = aws_iam_policy.cloudwatch_writepolicy.arn
}

resource "aws_iam_instance_profile" "example" {
  name             =  "example"
  role             = aws_iam_role.ec2_assume_role.name
}



