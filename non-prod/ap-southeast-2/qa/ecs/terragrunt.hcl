include "root" {
  path = find_in_parent_folders()
  expose = true
}


include "env" {
  path = "${dirname(find_in_parent_folders())}/_env/ecs.hcl"
}

inputs = {
  ecs-env                 = include.root.locals.environment
  ecs-name                = "${include.root.locals.project_name}-${include.root.locals.environment}"
  task-desired-count      = 3
}