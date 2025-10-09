output "org_id"         { value = aws_organizations_organization.org.id }
output "root_id"        { value = aws_organizations_organization.org.roots[0].id }
output "prod_ou_id"     { value = try(aws_organizations_organizational_unit.prod[0].id, null) }
output "sandbox_ou_id"  { value = try(aws_organizations_organizational_unit.sandbox[0].id, null) }
