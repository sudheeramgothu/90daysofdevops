import boto3, sys

def delete_object(bucket, key):
    s3 = boto3.client("s3")
    s3.delete_object(Bucket=bucket, Key=key)
    print(f"Deleted object s3://{bucket}/{key}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python s3_delete_object.py <bucket> <key>")
    else:
        delete_object(sys.argv[1], sys.argv[2])
