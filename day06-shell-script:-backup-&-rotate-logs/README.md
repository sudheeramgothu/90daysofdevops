# Day 6 — Shell Script: Backup & Rotate Logs

## 📖 Overview
Today’s focus: **Shell Script: Backup & Rotate Logs**.  
You’ll build reliable log rotation and backup workflows with pure bash: time-based and size-based rotations, archiving, integrity checks, and restore.

---

## 🎯 Learning Goals
- Rotate logs safely (copy‑truncate pattern) without losing writes.
- Create dated archives and prune old backups with retention policies.
- Perform size‑based rotation for fast‑growing logs.
- Verify archive integrity with checksums.
- Restore logs from an archive confidently.

---

## 🛠️ Lab Setup & Tasks

```text
1. Generate sample logs
   bash generate_logs.sh ./lab-logs

2. Time-based rotation + archive + retention (days)
   bash backup_rotate.sh ./lab-logs ./backups 7

3. Size-based rotation (e.g., rotate files > 1MB)
   bash rotate_by_size.sh ./lab-logs 1

4. Daily archive (one tar.gz per day) + retention
   bash archive_daily.sh ./lab-logs ./backups/daily 14

5. Verify checksums of archives
   bash verify_integrity.sh ./backups

6. Restore from a given archive into restore/ dir
   bash restore_from_archive.sh ./backups <archive-name.tar.gz> ./restore
```

---

## 💡 Challenge
- Add **GZIP level** as an env var (e.g., `GZIP=-9`) and measure size/time tradeoffs.  
- Encrypt archives using `gpg` (optional) and document restore steps.  
- Add **exclusions** (e.g., `*.tmp`) via a config file read by the scripts.  

---

## ✅ Checklist
- [ ] Rotated logs safely with copy‑truncate  
- [ ] Created dated archives and pruned by retention  
- [ ] Rotated by size for large logs  
- [ ] Verified checksums of all archives  
- [ ] Restored logs successfully to a sandbox directory  

---

## 📌 Commit
Once complete, commit your progress:
```bash
git add day06-shell-backup-rotate-logs
git commit -m "day06: shell log rotation & backup — time/size rotation, archive, retention, verify, restore"
git push
```
