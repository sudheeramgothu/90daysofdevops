#!/usr/bin/env python3
import re, sys

log_pattern = re.compile(
    r'^(?P<ip>\S+) \S+ \S+ \[(?P<dt>[^\]]+)\] '
    r'"(?P<method>[A-Z]+) (?P<path>[^ ]+) (?P<proto>HTTP/\d\.\d)" '
    r'(?P<status>\d{3}) (?P<size>\d+|-) "[^"]*" "(?P<ua>[^"]*)"'
)

def parse_line(line: str):
    m = log_pattern.match(line)
    if not m:
        return None
    return m.groupdict()

def main(fp):
    for line in fp:
        parsed = parse_line(line.rstrip("\\n"))
        if parsed:
            print(parsed)

if __name__ == "__main__":
    path = sys.argv[1] if len(sys.argv) > 1 else "sample.log"
    with open(path, "r", encoding="utf-8") as f:
        main(f)
