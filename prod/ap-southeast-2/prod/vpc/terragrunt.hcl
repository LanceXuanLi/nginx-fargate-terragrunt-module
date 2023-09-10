
include "root" {
  path = find_in_parent_folders()
  expose = true
}


include "env" {
  path = "${dirname(find_in_parent_folders())}/_env/vpc.hcl"
}

inputs = {
  vpc-env     = include.root.locals.environment
  vpc-name    = include.root.locals.project_name
  # https://repost.aws/questions/QU6ndN_tPYR9K9NoXGA2chBw/2-azs-vs-3-or-more-azs
  # 3 AZs minimum; that way if the worst happens and there's an AZ outage, you still have redundancy.
  first-n-azs = 3
}