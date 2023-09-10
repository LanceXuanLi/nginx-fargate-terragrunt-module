terraform {
  source = "${local.module-url}//modules/waf?ref=v1.0.0"
}

locals {
  module-url = "git::https://github.com/LanceXuanLi/nginx-fargate-resource-module.git"
}

dependency "alb" {
  config_path = "../alb"
}


inputs = {
  alb-arn         = dependency.alb.outputs.alb-arn
}