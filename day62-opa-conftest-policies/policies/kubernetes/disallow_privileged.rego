package policy.kubernetes.disallow_privileged
deny[msg] {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  c.securityContext.privileged == true
  msg := sprintf("Deployment %q container %q must not run privileged", [input.metadata.name, c.name])
}
