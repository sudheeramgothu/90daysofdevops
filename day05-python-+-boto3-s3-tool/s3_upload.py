import boto3, sys

def upload_file(bucket, local_path, key):
    s3 = boto3.client("s3")
    s3.upload_file(local_path, bucket, key)
    print(f"Uploaded {local_path} to s3://{bucket}/{key}")

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python s3_upload.py <bucket> <local_path> <key>")
    else:
        upload_file(sys.argv[1], sys.argv[2], sys.argv[3])
