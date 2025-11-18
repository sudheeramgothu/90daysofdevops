package policy.terraform.tags_required
deny[msg] {
  some type
  res := input.resource[type]
  some name
  r := res[name]
  not r.tags.project
  msg := sprintf("Resource %s.%s missing tag 'project'", [type, name])
}
