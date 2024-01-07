resource "aws_dynamodb_table" "claim_details" {
  name             = "claim-details"
  hash_key         = "claimID"
  billing_mode     = "PAY_PER_REQUEST"

  attribute {
    name = "claimID"
    type = "S"
  }
}