#!/usr/bin/env python3
import re, sys

ip_re = re.compile(r'^(25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.'
                   r'(25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.'
                   r'(25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.'
                   r'(25[0-5]|2[0-4]\\d|[01]?\\d\\d?)$')

path_re = re.compile(r'^/[^\\s]*$')
ts_re = re.compile(r'^\\d{2}/[A-Za-z]{3}/\\d{4}:\\d{2}:\\d{2}:\\d{2} [+\\-]\\d{4}$')

def validate_record(line: str):
    try:
        ip = line.split()[0]
        dt = line.split('[',1)[1].split(']')[0]
        req = line.split('"')[1]
        method, path, _ = req.split()
        return bool(ip_re.match(ip)), bool(ts_re.match(dt)), bool(path_re.match(path))
    except Exception:
        return False, False, False

def main(path):
    ok = 0; bad = 0
    with open(path, 'r', encoding='utf-8') as f:
        for ln in f:
            vi, vt, vp = validate_record(ln.rstrip("\\n"))
            if all([vi, vt, vp]):
                ok += 1
            else:
                bad += 1
    print(f"Valid lines: {ok}, Invalid lines: {bad}")

if __name__ == "__main__":
    p = sys.argv[1] if len(sys.argv) > 1 else "sample.log"
    main(p)
