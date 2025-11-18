package policy.kubernetes.no_latest_tag
deny[msg] {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  img := c.image
  endswith(img, ":latest") or not contains(img, ":")
  msg := sprintf("Deployment %q container %q uses disallowed tag in %q", [input.metadata.name, c.name, img])
}
