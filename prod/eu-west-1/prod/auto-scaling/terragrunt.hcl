
include "root" {
  path = find_in_parent_folders()
  expose = true
}


include "env" {
  path = "${dirname(find_in_parent_folders())}/_env/auto-scaling.hcl"
}


inputs = {
  auto-scaling-name = include.root.locals.project_name
}