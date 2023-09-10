terraform {
  source = "${local.module-url}//modules/auto-scaling?ref=v1.0.0"
}

locals {
  module-url = "git::https://github.com/LanceXuanLi/nginx-fargate-resource-module.git"
}

dependency "ecs" {
  config_path = "../ecs"
}


inputs = {
  ecs-cluster-name  = dependency.ecs.outputs.ecs-cluster-name
  ecs-service-name  = dependency.ecs.outputs.ecs-service-name
}