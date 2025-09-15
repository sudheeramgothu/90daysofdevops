#!/usr/bin/env python3
import re, sys
from collections import Counter

log_pattern = re.compile(
    r'^(?P<ip>\S+) \S+ \S+ \[(?P<dt>[^\]]+)\] '
    r'"(?P<method>[A-Z]+) (?P<path>[^ ]+) (?P<proto>HTTP/\\d\\.\\d)" '
    r'(?P<status>\\d{3}) (?P<size>\\d+|-) "[^"]*" "(?P<ua>[^"]*)"'
)

def records(path):
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            m = log_pattern.match(line)
            if m:
                yield m.groupdict()

def main(path):
    status = Counter()
    ips = Counter()
    paths = Counter()
    agents = Counter()

    for r in records(path):
        status[r["status"]] += 1
        ips[r["ip"]] += 1
        paths[r["path"]] += 1
        agents[r["ua"]] += 1

    print("== Status counts ==")
    for k, v in status.most_common():
        print(k, v)
    print("\\n== Top IPs ==")
    for k, v in ips.most_common(5):
        print(k, v)
    print("\\n== Top Paths ==")
    for k, v in paths.most_common(5):
        print(k, v)
    print("\\n== Top User Agents ==")
    for k, v in agents.most_common(3):
        print(k, v)

if __name__ == "__main__":
    p = sys.argv[1] if len(sys.argv) > 1 else "sample.log"
    main(p)
