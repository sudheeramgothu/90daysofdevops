package policy.terraform.s3_no_public_read
deny[msg] {
  buckets := input.resource.aws_s3_bucket
  some name
  b := buckets[name]
  b.acl != null
  lower(b.acl) == "public-read" or lower(b.acl) == "public-read-write"
  msg := sprintf("S3 bucket %q uses public ACL %v", [name, b.acl])
}
