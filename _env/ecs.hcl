terraform {
  source = "${local.module-url}//modules/ecs?ref=v1.0.0"
}

locals {
  module-url = "git::https://github.com/LanceXuanLi/nginx-fargate-resource-module.git"
}

dependency "alb" {
  config_path = "../alb"
}

dependency "vpc" {
  config_path = "../vpc"
}


inputs = {
  alb-target-group-arn    = dependency.alb.outputs.target_group_arn
  ecs-private-subnets-ids = dependency.vpc.outputs.private-subnets
  ecs-security-group      = dependency.vpc.outputs.ecs-sg
}