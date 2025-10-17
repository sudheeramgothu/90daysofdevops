output "bucket_name" { value = aws_s3_bucket.artifact.bucket }
output "region" { value = var.aws_region }
output "workspace" { value = var.env }
