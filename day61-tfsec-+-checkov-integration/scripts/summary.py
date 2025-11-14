import json, os, sys
BASE = os.path.dirname(os.path.dirname(__file__))
reports = os.path.join(BASE, "reports")
policy = os.path.join(BASE, "policy", "gate.json")
fail_on = set(["HIGH","CRITICAL"])
try:
  with open(policy) as f:
    fail_on = set(json.load(f).get("fail_on", list(fail_on)))
except Exception:
  pass

def parse_tfsec(p):
  try:
    data = json.load(open(p))
    cnt=0
    rs = data.get("results") or data.get("misconfigurations", [])
    if isinstance(rs, list):
      for r in rs:
        sev = (r.get("severity") or "").upper()
        if sev in fail_on: cnt += 1
    return cnt
  except Exception as e:
    return 0

def parse_checkov(p):
  try:
    data = json.load(open(p))
    failed = data.get("results", {}).get("failed_checks", [])
    cnt=0
    for r in failed:
      sev = (r.get("severity") or "").upper()
      if sev in fail_on: cnt += 1
    return cnt
  except Exception:
    return 0

t = parse_tfsec(os.path.join(reports,"tfsec.json"))
c = parse_checkov(os.path.join(reports,"checkov.json"))
total = t + c
open(os.path.join(reports,"summary.txt"),"w").write(f"[tfsec] {t} fail-on\n[checkov] {c} fail-on\n[total] {total}\n")
sys.exit(1 if total>0 else 0)
