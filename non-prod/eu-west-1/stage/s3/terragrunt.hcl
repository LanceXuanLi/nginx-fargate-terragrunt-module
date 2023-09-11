include "root" {
  path = find_in_parent_folders()
  expose = true
}


include "env" {
  path = "${dirname(find_in_parent_folders())}/_env/s3.hcl"

}


inputs = {
  s3-bucket = include.root.locals.project_name
  s3-env    = include.root.locals.environment
}