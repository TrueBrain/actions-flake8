import glob
import json
import os
import re
import sys

matcher = max(glob.glob(os.path.join(os.environ["RUNNER_TEMP"], "flake8-matcher.*")), key=os.path.getmtime)
patterns = {p["owner"]: p["pattern"][0]["regexp"] for p in json.load(open(matcher))["problemMatcher"]}
line = "example_simplify/example.py:2:5: SIM103 Return the condition a directly"

for severity in ("error", "warning"):
    matched = re.match(patterns[f"flake8-{severity}"], line) is not None
    if matched != (severity == sys.argv[1]):
        sys.exit(f"SIM103 {'unexpectedly' if matched else 'not'} matched as {severity}")
