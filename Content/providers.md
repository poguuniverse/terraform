HashiCorp and the Terraform community have already written thousands of providers, can be found here: https://registry.terraform.io/

You can also write your own

https://developer.hashicorp.com/terraform/intro

section1:
https://developer.hashicorp.com/terraform/tutorials/cli/init
tf init and tf get terraform init -upgrade
tf validate
https://developer.hashicorp.com/terraform/tutorials/cli/init
tree .terraform -L 1
explore .terraform/modules
tree .terraform/modules
tree .terraform/providers
'
section2:
terraform plan -out "tfplan"
terraform show "tfplan"
terraform show -json "tfplan" | jq > tfplan.json
jq '.terraform_version, .format_version' tfplan.json
jq '.configuration.provider_config' tfplan.json
terraform plan -destroy -out "tfplan-destroy"


variables: sensitive   = true


terraform state list
terraform apply -replace "aws_instance.main[1]"


terraform console

Interpolate variables in strings

Validate variables

terraform output

terraform output lb_url

terraform output -raw lb_url

terraform output -json


required_version

~> 0.12.29
major.minor.patch

Required Version	Meaning	Considerations
0.15.0	Only Terraform v0.15.0 exactly	To upgrade Terraform, first edit the required_version setting
>= 0.15	Any Terraform v0.15.0 or greater	Includes Terraform v1.0.0 and above
~> 0.15.0	Any Terraform v0.15.x, but not v1.0 or later	Minor version updates are intended to be non-disruptive
>= 0.15, < 2.0.0	Terraform v0.15.0 or greater, but less than v2.0.0	Avoids major version updates


terraform state list

terraform plan -replace="aws_instance.example"


terraform state mv 

terraform state mv -state-out=../terraform.tfstate aws_instance.example_new aws_instance.example_new

terraform plan -generate-config-out=generated.tf

export TF_LOG_CORE=TRACE

export TF_LOG_PROVIDER=TRACE

