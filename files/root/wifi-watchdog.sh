#!/bin/sh
# Tu dong phuc hoi song WiFi va chong treo he thong 24/7
GW="192.168.0.1"
FAIL_FILE="/tmp/wifi_fail_count"

if ping -c 1 -W 2 "$GW" >/dev/null 2>&1; then
    [ -f "$FAIL_FILE" ] && rm -f "$FAIL_FILE"
    exit 0
fi

COUNT=1
if [ -f "$FAIL_FILE" ]; then
    COUNT=$(cat "$FAIL_FILE" 2>/dev/null || echo 0)
    COUNT=$((COUNT + 1))
fi
echo "$COUNT" > "$FAIL_FILE"

if [ "$COUNT" -eq 3 ]; then
    logger -t wifi-watchdog "Mat ket noi tram phat 3 lan lien tiep. Bat dau reload WiFi..."
    wifi reload
elif [ "$COUNT" -ge 8 ]; then
    logger -t wifi-watchdog "Mat ket noi tram phat 8 lan lien tiep. Khoi dong lai router..."
    sync
    /sbin/reboot
fi
