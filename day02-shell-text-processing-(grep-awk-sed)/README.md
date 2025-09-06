# Day 2 — Shell Text Processing (grep/awk/sed)

## 📖 Overview
Today’s focus: **Shell Text Processing with grep, awk, and sed**.  
We’ll practice filtering, extracting, transforming, and summarizing text — all critical skills for DevOps engineers when parsing logs, config files, and command outputs.

---

## 🎯 Learning Goals
- Master searching and filtering text with `grep`.
- Use `awk` to extract fields and calculate values.
- Apply `sed` to transform text in-place.
- Combine these tools for real-world log parsing.

---

## 🛠️ Lab Setup & Tasks

```text
1. Prepare sample log
   bash prepare_logs.sh
   ✔ Creates sample.log with mock Apache access logs.

2. Practice with grep
   bash grep_examples.sh
   ✔ Find all lines with status code 404.
   ✔ Count number of requests from a specific IP.
   ✔ Highlight matches.

3. Practice with awk
   bash awk_examples.sh
   ✔ Extract only IP addresses.
   ✔ Print request method + URL.
   ✔ Count requests per status code.
   ✔ Compute average response size.

4. Practice with sed
   bash sed_examples.sh
   ✔ Replace http with https.
   ✔ Remove lines with favicon.ico.
   ✔ Mask IP addresses (anonymization).
```

---

## 💡 Challenge
- Combine `grep` and `awk` to find the **top 5 IP addresses** causing `404` errors.  
- Use `sed` to rewrite URLs from `/old-path/` to `/new-path/`.  
- Extend the scripts so results are written into `report.txt`.

---

## 📌 Commit
Once complete, commit your progress:
```bash
git add day02-shell-text-processing
git commit -m "day02: Shell text processing — grep, awk, sed examples"
git push
```
