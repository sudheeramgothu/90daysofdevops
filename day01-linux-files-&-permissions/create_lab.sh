#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="${1:-./lab-perms}"
echo "Creating lab at: $LAB_DIR"
rm -rf "$LAB_DIR"
mkdir -p "$LAB_DIR"/{docs,scripts,tmp,groupdir}
touch "$LAB_DIR"/docs/{readme.txt,private.txt,team.txt}
echo "hello" > "$LAB_DIR/docs/readme.txt"
echo "top-secret" > "$LAB_DIR/docs/private.txt"
echo "shared" > "$LAB_DIR/docs/team.txt"

printf '%s\n' '#!/usr/bin/env bash' 'echo "I run!"' > "$LAB_DIR/scripts/example.sh"
chmod 0755 "$LAB_DIR/scripts/example.sh"

chmod 0777 "$LAB_DIR/tmp"
chmod 0775 "$LAB_DIR/groupdir"

tree "$LAB_DIR" 2>/dev/null || find "$LAB_DIR" -maxdepth 2 -printf '%M %u %g %p\n'
echo " Done."
