#!/usr/bin/env python3
"""
Parse Robot Framework output.xml and generate JSON for the Mobile Android E2E test report dashboard.
All written files stay in this directory: report_data.json, run_history.json, index.html

Usage: python generate_report.py [path/to/output.xml]
Default: ../results/output.xml
"""

import json
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path
from datetime import datetime


def parse_elapsed(elapsed_str):
    """Convert Robot elapsed seconds to HH:MM:SS."""
    try:
        secs = float(elapsed_str)
        m, s = divmod(int(secs), 60)
        h, m = divmod(m, 60)
        return f"{h:02d}:{m:02d}:{s:02d}"
    except (ValueError, TypeError):
        return "00:00:00"


def main():
    script_dir = Path(__file__).resolve().parent
    project_root = script_dir.parent

    if len(sys.argv) > 1:
        xml_path = Path(sys.argv[1]).resolve()
    else:
        candidates = [
            project_root / "results" / "output.xml",
            project_root / "output.xml",
        ]
        existing = [p.resolve() for p in candidates if p.exists()]
        if not existing:
            print("Error: No output.xml found. Run tests first (robot --outputdir results tests/).", file=sys.stderr)
            sys.exit(1)
        xml_path = max(existing, key=lambda p: p.stat().st_mtime)
        print(f"Using: {xml_path}")

    if not xml_path.exists():
        print(f"Error: {xml_path} not found. Run tests first.", file=sys.stderr)
        sys.exit(1)

    tree = ET.parse(xml_path)
    root = tree.getroot()

    generated = root.get("generated", "")
    try:
        dt = datetime.fromisoformat(generated.replace("Z", "+00:00"))
        last_run = dt.strftime("%d-%b-%Y %I:%M %p")
    except Exception:
        last_run = generated

    total_pass = total_fail = total_skip = 0
    total_elapsed = 0.0
    tests = []
    failures = []
    by_tag = []
    by_suite = []

    for stat in root.findall(".//statistics/total/stat"):
        total_pass = int(stat.get("pass", 0))
        total_fail = int(stat.get("fail", 0))
        total_skip = int(stat.get("skip", 0))
        break

    for stat in root.findall(".//statistics/tag/stat"):
        by_tag.append({
            "name": stat.text or stat.get("name", ""),
            "pass": int(stat.get("pass", 0)),
            "fail": int(stat.get("fail", 0)),
            "skip": int(stat.get("skip", 0)),
        })

    for stat in root.findall(".//statistics/suite/stat"):
        name = stat.text or stat.get("name", "")
        stat_id = stat.get("id", "")
        if stat_id == "s1":
            continue
        by_suite.append({
            "name": name,
            "pass": int(stat.get("pass", 0)),
            "fail": int(stat.get("fail", 0)),
            "skip": int(stat.get("skip", 0)),
        })

    def parse_kw(kw_el):
        name = kw_el.get("name", "")
        st = kw_el.find("status")
        status = st.get("status", "UNKNOWN") if st is not None else "UNKNOWN"
        elapsed = round(float(st.get("elapsed", 0)), 2) if st is not None else 0
        children = [parse_kw(child) for child in kw_el.findall("kw")]
        return {"name": name, "status": status, "elapsed": elapsed, "children": children}

    def get_steps_and_logs(test_el):
        steps = [parse_kw(kw) for kw in test_el.findall("kw")]
        logs = []
        for msg in test_el.iter("msg"):
            level = msg.get("level", "INFO")
            timestamp = msg.get("timestamp", "")
            text = (msg.text or "").strip()
            if text or level != "INFO":
                logs.append({"level": level, "timestamp": timestamp, "message": text or "(no message)"})
        return steps, logs

    for suite in root.iter("suite"):
        suite_id = suite.get("id", "")
        suite_name = (suite.get("name") or "").strip()
        if not suite_id or suite_id == "s1" or not suite_name:
            continue
        for test in suite.findall("test"):
            name = test.get("name", "")
            tags = [t.text or "" for t in test.findall("tag") if (t.text or "").strip()]
            status_el = test.find("status")
            status = status_el.get("status", "UNKNOWN") if status_el is not None else "UNKNOWN"
            elapsed = float(status_el.get("elapsed", 0)) if status_el is not None else 0
            total_elapsed = max(total_elapsed, elapsed)
            steps, logs = get_steps_and_logs(test)
            tests.append({
                "name": name,
                "status": status,
                "elapsed": round(elapsed, 2),
                "suite": suite_name,
                "tags": tags,
                "steps": steps,
                "logs": logs,
            })
            if status == "FAIL":
                failures.append({"name": name, "elapsed": round(elapsed, 2), "suite": suite_name, "tags": tags})

    root_suite = root.find(".//suite[@id='s1']")
    if root_suite is not None:
        status_list = root_suite.findall("status")
        if status_list:
            total_elapsed = float(status_list[-1].get("elapsed", 0))
    if total_elapsed == 0 and tests:
        total_elapsed = sum(t["elapsed"] for t in tests)

    total_tests = total_pass + total_fail + total_skip
    success_rate = (total_pass / total_tests * 100) if total_tests else 0

    run_history_path = script_dir / "run_history.json"
    run_history = []
    if run_history_path.exists():
        try:
            run_history = json.loads(run_history_path.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, OSError):
            run_history = []
    if not isinstance(run_history, list):
        run_history = []
    current_run = {
        "lastRun": last_run,
        "pass": total_pass,
        "fail": total_fail,
        "skip": total_skip,
        "totalTests": total_tests,
        "successRate": round(success_rate, 2),
        "duration": parse_elapsed(total_elapsed),
    }
    run_history.append(current_run)
    run_history = run_history[-20:]
    run_history_path.write_text(json.dumps(run_history, indent=2), encoding="utf-8")

    report = {
        "generated": generated,
        "lastRun": last_run,
        "duration": parse_elapsed(total_elapsed),
        "totalTests": total_tests,
        "pass": total_pass,
        "fail": total_fail,
        "skip": total_skip,
        "successRate": round(success_rate, 2),
        "tests": tests,
        "failures": failures,
        "byTag": by_tag,
        "bySuite": by_suite,
        "framework": "Robot Framework",
        "testType": "Mobile E2E",
        "version": "1.0.0",
        "runHistory": run_history,
    }

    out_path = script_dir / "report_data.json"
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(report, f, indent=2)
    print(f"Report data written to {out_path}")

    index_path = script_dir / "index.html"
    if index_path.exists():
        html = index_path.read_text(encoding="utf-8")
        json_str = json.dumps(report).replace("</script>", "<\\/script>").replace("</SCRIPT>", "<\\/SCRIPT>")
        embed = f'<script>window.REPORT_DATA = {json_str};</script>'
        if "<!-- REPORT_DATA_PLACEHOLDER -->" in html:
            html = html.replace("<!-- REPORT_DATA_PLACEHOLDER -->", embed)
        else:
            html = re.sub(r"<script>window\.REPORT_DATA = [\s\S]*?</script>", lambda m: embed, html, count=1)
        index_path.write_text(html, encoding="utf-8")
        print(f"Dashboard updated: {index_path}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
