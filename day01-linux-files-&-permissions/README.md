# Day 1 — Linux Files & Permissions

## 📖 Overview
Today’s focus: **Linux Files & Permissions**.  
We’ll learn how to manage ownership, permissions, `chmod`, `umask`, sticky bit, setgid, and even ACLs.

---

## 🎯 Learning Goals
- Understand Linux file types and permission bits.
- Explore symbolic vs numeric modes with `chmod`.
- See how `umask` influences defaults.
- Learn about special modes (`sticky bit`, `setgid`).
- Get a taste of ACLs for fine-grained access.

---

## 🛠️ Lab Setup & Tasks

```text
1. Create sandbox
   bash create_lab.sh
   ✔ Creates lab-perms/ with files and directories to experiment safely.

2. Explore permissions
   bash explore_perms.sh
   ✔ Use ls -l and stat to read permissions.
   ✔ Understand r, w, x for files vs directories.

3. Apply permissions
   bash apply_perms.sh
   ✔ Practice chmod (numeric & symbolic).
   ✔ Secure files to 600/644.
   ✔ Add/remove execute bits.
   ✔ Recursively set defaults (755 dirs, 644 files).

4. Understand umask
   bash umask_demo.sh
   ✔ See how new files differ with umask 022, 027, 077.
   ✔ Learn why your files often default to 644.

5. Sticky bit
   bash stickybit_demo.sh
   ✔ Apply chmod 1777 to world-writable dirs.
   ✔ Understand why /tmp works this way.

6. Setgid directories
   bash setgid_dir_demo.sh
   ✔ Apply chmod 2775 to team dirs.
   ✔ Observe group inheritance for collaboration.

7. (Optional) ACLs
   bash acl_demo.sh
   ✔ If setfacl is installed, test ACLs for specific users.
   ✔ Learn how ACLs extend beyond the classic ugo model.
'''
## Challenge
- Make private.txt readable only by the file owner.
- Configure team.txt so it’s group-readable, but not others.
- Create a new directory where all team members can drop files, but cannot delete each other’s files.