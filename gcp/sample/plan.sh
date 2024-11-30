#!/bin/bash

terraform init -var-file=./envs/dev.tfvars
terraform plan -var-file=./envs/dev.tfvars
