#!/bin/sh

rm -rf .terraform*
rm -rf .terraform.lock.hcl

terraform --version


terraform init -backend-config "bucket=cloudtech-terraform-tfstate" -backend-config "region=sa-east-1" -backend-config "key=pgmbox-eks"


if [[ $(terraform workspace list | grep 'production' | wc -l ) = 0 ]]; then
  terraform workspace new production
fi

terraform workspace select production

terraform init -backend-config "bucket=cloudtech-terraform-tfstate" -backend-config "region=sa-east-1" -backend-config "key=pgmbox-eks"
