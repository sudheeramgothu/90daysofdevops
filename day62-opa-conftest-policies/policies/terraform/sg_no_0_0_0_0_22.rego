package policy.terraform.sg_no_0_0_0_0_22
deny[msg] {
  sgs := input.resource.aws_security_group
  some name
  sg := sgs[name]
  ing := sg.ingress[_]
  cidr := ing.cidr_blocks[_]
  cidr == "0.0.0.0/0"
  ing.from_port <= 22
  ing.to_port >= 22
  msg := sprintf("Security group %q allows SSH from 0.0.0.0/0", [name])
}
