#!/bin/bash

terraform destroy -var-file=./envs/dev.tfvars
