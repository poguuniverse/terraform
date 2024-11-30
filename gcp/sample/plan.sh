#!/bin/bash

terraform init -reconfigure -var-file=./envs/dev.tfvars
terraform plan --auto-approve -var-file=./envs/dev.tfvars
