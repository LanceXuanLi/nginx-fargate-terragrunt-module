terraform {
  source = "${local.module-url}//modules/vpc?ref=v1.0.0"
}

locals {
  module-url = "git::https://github.com/LanceXuanLi/nginx-fargate-resource-module.git"
}



inputs = {

}