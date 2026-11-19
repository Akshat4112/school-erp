#!/usr/bin/env python3
"""Produce an empty schema from the repository's historical phpMyAdmin dump.

No original INSERT/REPLACE records are imported into cloud development or CI.
This is purposely restricted to the legacy SQL export's statement formatting.
"""
from pathlib import Path
import re
import sys

source = Path(sys.argv[1] if len(sys.argv) > 1 else "school_erp.sql")
output = Path(sys.argv[2] if len(sys.argv) > 2 else "dev/schema-only.sql")
lines = source.read_text(encoding="utf-8-sig").splitlines(keepends=True)
data_start = re.compile(r"^\s*(?:INSERT\s+(?:IGNORE\s+)?INTO|REPLACE\s+INTO)\s+", re.I)
drop = False
removed = 0
result = []
for line in lines:
    if not drop and data_start.match(line):
        drop = True
        removed += 1
    if drop:
        if line.rstrip().endswith(";"):
            drop = False
        continue
    result.append(line)
if drop:
    raise SystemExit("Unexpected unterminated data statement: refusing to generate schema")
schema = "".join(result)
table_count = len(re.findall(r"^CREATE TABLE\s+", schema, flags=re.I | re.M))
if removed < 1 or table_count < 1 or data_start.search(schema):
    raise SystemExit("Refusing to publish an unverified or populated schema")
output.parent.mkdir(parents=True, exist_ok=True)
output.write_text("-- SYNTHETIC CLOUD DEMO: DDL ONLY, historical INSERT records removed.\n" + schema, encoding="utf-8")
print(f"Generated empty schema: {table_count} tables, {removed} data statements omitted")
