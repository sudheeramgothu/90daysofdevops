import boto3, sys

def create_bucket(bucket_name, region="us-east-1"):
    s3 = boto3.client("s3", region_name=region)
    if region == "us-east-1":
        s3.create_bucket(Bucket=bucket_name)
    else:
        s3.create_bucket(
            Bucket=bucket_name,
            CreateBucketConfiguration={"LocationConstraint": region},
        )
    print(f"Bucket created: {bucket_name}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python s3_create_bucket.py <bucket-name>")
    else:
        create_bucket(sys.argv[1])
