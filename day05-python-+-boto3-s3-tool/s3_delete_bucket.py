import boto3, sys

def delete_bucket(bucket):
    s3 = boto3.client("s3")
    s3.delete_bucket(Bucket=bucket)
    print(f"Deleted bucket {bucket}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python s3_delete_bucket.py <bucket>")
    else:
        delete_bucket(sys.argv[1])
