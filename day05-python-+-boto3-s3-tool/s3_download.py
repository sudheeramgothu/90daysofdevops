import boto3, sys

def download_file(bucket, key, local_path):
    s3 = boto3.client("s3")
    s3.download_file(bucket, key, local_path)
    print(f"Downloaded s3://{bucket}/{key} to {local_path}")

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python s3_download.py <bucket> <key> <local_path>")
    else:
        download_file(sys.argv[1], sys.argv[2], sys.argv[3])
