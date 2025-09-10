# Extras
- To change gzip level globally: `export GZIP=-9` (before running archive scripts)
- To exclude patterns, modify `archive_daily.sh` tar command with `--exclude='*.tmp'` etc.
- Cron idea (daily at 01:05):
  ```cron
  5 1 * * * /path/to/backup_rotate.sh /var/log /var/backups 14
  ```
