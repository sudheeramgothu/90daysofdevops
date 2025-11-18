
#!/usr/bin/env python3
import json,sys,glob

bad=False
paths = sys.argv[1:]

for f in paths:
    data=json.load(open(f))
    for st in data.get("Statement",[]):
        if st.get("Action")=="*" or st.get("Resource")=="*":
            print(f"[!] Over-permissive policy detected: {f}")
            bad=True

if bad:
    print("❌ Least-privilege check FAILED")
    sys.exit(1)

print("✅ Policies follow least-privilege guidelines")
