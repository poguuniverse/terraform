Arguments vs Attributes vs Meta-arguments
Resource dependencies, implicit vs explicit
Use of Locals
Use of outputs
Use of lifecycle meta arguments


terraform plan -out="dry-run-v1"

terraform show "dry-run-v1"
terraform show -json dry-run-v1 > dry-run-v1.json
https://hieven.github.io/terraform-visual/

terraform plan -target="aws_vpc.dev_vpc" -> only use it for troubleshooting or rarecases

terraform apply "dry-run-v1"

terraform apply -replace="aws_instance.webapp" -> only use it for troubleshooting or rarecases  ( donot use taint and untaint, tf suggests to use replavce instead)

-parallelism=n 

terraform show 