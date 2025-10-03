output "distribution_domain_name" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "distribution_id" {
  value = aws_cloudfront_distribution.this.id
}

output "site_bucket_name" {
  value = aws_s3_bucket.site.bucket
}
