include "root" {
  path = find_in_parent_folders()
  expose = true
}


include "env" {
  path = "${dirname(find_in_parent_folders())}/_env/waf.hcl"
}

inputs = {
  waf-description = include.root.locals.project_name
  waf-name        = include.root.locals.project_name
  waf-env         = include.root.locals.environment
}