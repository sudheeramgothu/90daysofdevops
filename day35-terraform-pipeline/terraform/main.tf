locals { bucket_name = "ninjas-tfstate-${var.env}-${random_id.suffix.hex}" }
resource "random_id" "suffix" { byte_length = 2 }
resource "aws_s3_bucket" "artifact" { bucket = local.bucket_name tags = var.tags }
resource "aws_s3_bucket_versioning" "v" { bucket = aws_s3_bucket.artifact.id versioning_configuration { status = "Enabled" } }
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" { bucket = aws_s3_bucket.artifact.id rule { apply_server_side_encryption_by_default { sse_algorithm = "AES256" } } }
resource "aws_s3_bucket_public_access_block" "block" { bucket = aws_s3_bucket.artifact.id block_public_acls=true block_public_policy=true ignore_public_acls=true restrict_public_buckets=true }
