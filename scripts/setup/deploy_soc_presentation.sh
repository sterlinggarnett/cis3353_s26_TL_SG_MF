#!/bin/bash
# ==============================================================================
# SUBURBAN-SOC: Automated Presentation Setup
# 
# This script interacts directly with the Kibana API to automatically:
# 1. Force the SOC into Dark Mode globally.
# 2. Upload the Master Presentation NDJSON dashboard without manual clicking.
# ==============================================================================

# Variables
KIBANA_URL="http://localhost:5601"
# Change these if you changed your default elastic credentials!
USER="elastic"
PASS="changeme"

DASHBOARD_FILE="../../configs/server/suburban_soc_dashboard.ndjson"

echo "=========================================="
echo "🚀 Prepping Suburban-SOC Presentation..."
echo "=========================================="

echo "[1/2] Forcing global Dark Mode aesthetic..."
curl -s -X POST "$KIBANA_URL/api/kibana/settings" \
  -H "kbn-xsrf: true" \
  -H "Content-Type: application/json" \
  -u "$USER:$PASS" \
  -d '{"changes":{"theme:darkMode":true}}' > /dev/null

echo "[2/2] Importing Master NDJSON Dashboard..."
if [ -f "$DASHBOARD_FILE" ]; then
  curl -s -X POST "$KIBANA_URL/api/saved_objects/_import?overwrite=true" \
    -H "kbn-xsrf: true" \
    -u "$USER:$PASS" \
    --form file=@"$DASHBOARD_FILE" | grep -q '"success":true' && echo "-> Dashboard uploaded successfully!" || echo "-> Upload completed (Check Kibana to verify)"
else
  echo "[ERROR] Could not find the dashboard file at $DASHBOARD_FILE"
  exit 1
fi

echo "=========================================="
echo "✅ Setup Complete. Open $KIBANA_URL and blow their minds!"
echo "=========================================="
