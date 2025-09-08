#!/usr/bin/env bash
set -euo pipefail
cd lab-git

test_script=./test.sh
cat > "$test_script" <<'EOF'
#!/usr/bin/env bash
set -e
if grep -q "BUG" app.txt; then
  echo "bad"; exit 1
else
  echo "good"; exit 0
fi
EOF
chmod +x "$test_script"

git checkout main
echo "clean1" >> app.txt
git commit -am "chore: clean1"
echo "clean2" >> app.txt
git commit -am "chore: clean2"
echo "BUG here" >> app.txt
git commit -am "feat: introduce BUG"
echo "after" >> app.txt
git commit -am "chore: after bug"

git bisect start
git bisect bad
git bisect good HEAD~3
git bisect run "$test_script"
git bisect reset

echo "== Bisect finished =="
