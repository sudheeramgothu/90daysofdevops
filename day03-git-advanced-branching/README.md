# Day 3 — Git Advanced Branching

## 📖 Overview
Today’s focus: **Git Advanced Branching**.  
You’ll practice creating feature branches, fast‑forward vs. no‑fast‑forward merges, rebasing, cherry‑picking, reverting, stashing, tagging, and bisecting.

---

## 🎯 Learning Goals
- Use **branching strategies** (feature, release, hotfix).
- Compare **merge** vs **rebase** and when to prefer each.
- Apply **no‑FF merges** for history clarity; **FF** merges for simplicity.
- Use **cherry‑pick**, **revert**, **stash**, **tags**, and **bisect** confidently.

---

## 🛠️ Lab Setup & Tasks

```text
1. Create sandbox repo
   bash setup_repo.sh
   ✔ Creates lab-git/ with an initialized repo and a few commits.

2. Explore branch strategies (FF vs --no-ff)
   bash merge_ff.sh
   bash merge_noff.sh
   ✔ See the difference in history graphs and commit messages.

3. Rebase feature branch
   bash rebase_demo.sh
   ✔ Rebase feature on top of main and compare linear history.

4. Cherry-pick a specific commit
   bash cherry_pick.sh
   ✔ Copy a single commit from feature into main without merging everything.

5. Revert a bad commit
   bash revert_demo.sh
   ✔ Safely undo changes that landed on main (without rewriting history).

6. Stash and apply
   bash stash_demo.sh
   ✔ Park WIP changes while switching branches; re-apply later.

7. Bisect to find a bug
   bash bisect_demo.sh
   ✔ Binary search through history to locate the first bad commit.

8. Tags and releases
   bash tags_demo.sh
   ✔ Create annotated tags and list them.
```

---

## 💡 Challenge
- Create `feature/top-5` that adds a function; merge it with `--no-ff` into `main` and a proper message.  
- Cherry‑pick just the documentation commit from `feature/docs` to `main`.  
- Tag the result as `v0.2.0` with a release note.

---



## 📌 Commit
Once complete, commit your progress:
```bash
git add day03-git-advanced-branching
git commit -m "day03: Git advanced branching — FF vs no-FF, rebase, cherry-pick, revert, stash, tags, bisect"
git push
```
