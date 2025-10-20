package terraform.s3
deny[msg] { input.resource_type == "aws_s3_bucket"; input.public == true; msg := "S3 buckets must not be public" }
