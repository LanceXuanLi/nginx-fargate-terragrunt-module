terraform {
  source = "${local.module-url}//modules/alb?ref=v1.0.0"
}

locals {
  module-url = "git::https://github.com/LanceXuanLi/nginx-fargate-resource-module.git"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "s3" {
  config_path = "../s3"
}

inputs = {
  alb-sg-id         = dependency.vpc.outputs.alb-sg
  alb-subnets      = dependency.vpc.outputs.public-subnets
  vpc-id            = dependency.vpc.outputs.vpc-id
  s3-bucket         = dependency.s3.outputs.s3-bucket
}