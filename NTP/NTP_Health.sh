#!/bin/bash

set -euo pipefail

echo "=====NTP Heakth Check====="
echo

echo "Hostname: "
hostname
echo

echo "Current time : "
date
echo

echo "Chronyd service "
systemctl status chronyd
echo

echo "Time sync: "
timedatectl status | grep -E "System clock synchronized|NTP service"

echo "Chrony Tracking: "
chronyc tracking
echo

echo "NTP sources"
chronyc sources -v
echo

echo "Recent chrony logs: "
journalctl -u chronyd -n 20 --no-pager
