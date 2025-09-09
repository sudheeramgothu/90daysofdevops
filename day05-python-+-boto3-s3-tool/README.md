# Day 5 — Python + Boto3 S3 Tool

## 📖 Overview
Today’s focus: **Python + Boto3 S3 Tool**.  
We’ll use Python’s `boto3` SDK to interact with Amazon S3 for file management — a core DevOps skill.

---

## 🎯 Learning Goals
- Install and configure `boto3` for AWS access.  
- List, create, and delete S3 buckets.  
- Upload and download objects.  
- Manage object metadata and permissions.  
- Handle errors gracefully.  

---

## 🛠️ Lab Setup & Tasks

```text
1. Install boto3 and configure AWS credentials
   pip install boto3
   aws configure

2. List buckets
   python s3_list_buckets.py

3. Create a new bucket
   python s3_create_bucket.py my-devops-bucket-123

4. Upload and download files
   python s3_upload.py my-devops-bucket-123 ./sample.txt sample.txt
   python s3_download.py my-devops-bucket-123 sample.txt ./downloaded.txt

5. Delete objects and buckets
   python s3_delete_object.py my-devops-bucket-123 sample.txt
   python s3_delete_bucket.py my-devops-bucket-123
```

---

## 💡 Challenge
- Extend the upload script to support **multi-part uploads** for large files.  
- Add a `--public` flag to upload objects with public-read ACL.  
- Write a cleanup script to empty and delete multiple buckets at once.  

---

## ✅ Checklist
- [ ] Installed boto3 and configured AWS credentials  
- [ ] Listed S3 buckets with a script  
- [ ] Created and deleted buckets successfully  
- [ ] Uploaded and downloaded objects  
- [ ] Extended functionality with challenge task  

---

## 📌 Commit
Once complete, commit your progress:
```bash
git add day05-python-boto3-s3-tool
git commit -m "day05: Python + Boto3 S3 Tool — manage S3 buckets and objects"
git push
```
