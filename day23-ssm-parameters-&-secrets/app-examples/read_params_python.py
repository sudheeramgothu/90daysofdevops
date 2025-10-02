#!/usr/bin/env python3
"""
read_params_python.py
Usage: python3 read_params_python.py /dev/sampleapp
Requires: boto3 installed and AWS creds with SSM/Secrets access.
"""
import sys, json, boto3

def fetch_params(prefix: str) -> dict:
    ssm = boto3.client("ssm")
    params = {}
    next_token = None
    while True:
        kw = dict(Path=prefix, Recursive=True, WithDecryption=True, MaxResults=10)
        if next_token:
            kw["NextToken"] = next_token
        resp = ssm.get_parameters_by_path(**kw)
        for p in resp.get("Parameters", []):
            key = p["Name"].split("/")[-1]
            params[key] = p["Value"]
        next_token = resp.get("NextToken")
        if not next_token:
            break
    return params

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 read_params_python.py /env/app")
        sys.exit(2)
    prefix = sys.argv[1]
    params = fetch_params(prefix)
    print("# .env preview")
    for k, v in params.items():
        print(f"{k}={v}")
