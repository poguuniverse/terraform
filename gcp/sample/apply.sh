#!/bin/bash

terraform apply -auto-approve -var-file=./envs/dev.tfvars
