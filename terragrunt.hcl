locals {
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region       = local.region_vars.locals.region
  environment_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment       = local.environment_vars.locals.environment
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  account_id   = local.account_vars.locals.aws_account_id

  project_name = "sapia"
  backend_region = "ap-southeast-2"
  backend_bucket = "backendtest0905-6116"
  dynamodb_name  = "backendtest0905-6116"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
}
EOF
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {
    bucket         = "${local.backend_bucket}"
    key            = "sapia/${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.backend_region}"
    encrypt        = true
    dynamodb_table = "${local.dynamodb_name}"
  }
}
EOF
}