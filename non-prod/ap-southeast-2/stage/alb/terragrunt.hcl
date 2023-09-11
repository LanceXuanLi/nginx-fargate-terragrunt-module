include "root" {
  path = find_in_parent_folders()
  expose = true
}


include "env" {
  path = "${dirname(find_in_parent_folders())}/_env/alb.hcl"
}

inputs = {
  alb-env = include.root.locals.environment
  alb-name = "${include.root.locals.project_name}-${include.root.locals.environment}"
  alb-log-s3-prefix = "${include.root.locals.project_name}-${include.root.locals.environment}"
}