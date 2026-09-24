#!/usr/bin/env bash
# Purge every edge-app instance of EDGE_APP_NAME in PROJECT_NAME.
set -euo pipefail

: "${ZEDCLOUD_URL:?ZEDCLOUD_URL is required}"
: "${ZEDCLOUD_TOKEN:?ZEDCLOUD_TOKEN is required}"
: "${EDGE_APP_NAME:?EDGE_APP_NAME is required}"
: "${PROJECT_NAME:?PROJECT_NAME is required}"

base="${ZEDCLOUD_URL%/}"
auth=(-H "Authorization: Bearer ${ZEDCLOUD_TOKEN}" -H "Accept: application/json")

project_id="$(
  curl -fsS "${auth[@]}" "${base}/api/v1/projects/name/${PROJECT_NAME}" \
    | python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])'
)"
app_id="$(
  curl -fsS "${auth[@]}" "${base}/api/v1/apps/name/${EDGE_APP_NAME}" \
    | python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])'
)"

python3 - "$base" "$project_id" "$app_id" "$ZEDCLOUD_TOKEN" <<'PY'
import json
import os
import sys
import urllib.error
import urllib.parse
import urllib.request

base, project_id, app_id, token = sys.argv[1:5]
headers = {
    "Authorization": "Bearer " + token,
    "Accept": "application/json",
    "Content-Type": "application/json",
}

def get(url):
    request = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(request) as response:
        return json.load(response)

instances = []
page_token = ""
while True:
    params = {
        "projectName": os.environ["PROJECT_NAME"],
        "appName": os.environ["EDGE_APP_NAME"],
        "next.pageSize": "500",
    }
    if page_token:
        params["next.pageToken"] = page_token
    query = urllib.parse.urlencode(params)
    payload = get(base + "/api/v1/apps/instances?" + query)
    for item in payload.get("list") or []:
        if item.get("projectId") == project_id and item.get("appId") == app_id:
            instances.append(item)
    page_token = ((payload.get("next") or {}).get("pageToken")) or ""
    if not page_token:
        break

if not instances:
    print("No edge-app instances to purge in this project.")
    sys.exit(0)

for item in instances:
    current = int(((item.get("purge") or {}).get("counter")) or 0)
    nxt = current + 1
    body = json.dumps({"counter": nxt}).encode()
    url = base + "/api/v1/apps/instances/id/" + item["id"] + "/purge"
    request = urllib.request.Request(url, data=body, headers=headers, method="PUT")
    try:
        with urllib.request.urlopen(request) as response:
            response.read()
    except urllib.error.HTTPError as exc:
        detail = exc.read().decode("utf-8", errors="replace")
        raise SystemExit(
            "purge failed for %s (%s): HTTP %s %s"
            % (item.get("name"), item["id"], exc.code, detail)
        )
    print("purged %s counter %s -> %s" % (item.get("name"), current, nxt))
PY
