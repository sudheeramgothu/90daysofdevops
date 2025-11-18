package policy.kubernetes.require_limits
deny[msg] {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  not c.resources.limits.cpu
  msg := sprintf("Deployment %q container %q missing limits.cpu", [input.metadata.name, c.name])
}
deny[msg] {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  not c.resources.limits.memory
  msg := sprintf("Deployment %q container %q missing limits.memory", [input.metadata.name, c.name])
}
