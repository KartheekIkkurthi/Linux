#!/bin/bash

# server_usage.sh - log simple server usage stats

LOG_FILE="/var/log/server_usage.log"
if [ ! -w "$(dirname "$LOG_FILE")" ]; then
  LOG_FILE="$HOME/server_usage.log"
fi

TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
CPU_USAGE="$(top -bn1 | grep -E "Cpu\(s\)|%Cpu\(s\)" | awk '{print $2+$4+$6 "%"}')"
DISK_USAGE="$(df -h / | awk 'NR==2 {print $5}')"
ZOMBIE_COUNT="$(ps -eo stat,pid,comm | awk '/^Z/ {count++} END {print count+0}')"
MEMORY_USAGE="$(free -m | awk 'NR==2 {printf "%.1f%%", $3/$2*100}')"

cat >> "$LOG_FILE" <<EOF
$TIMESTAMP | CPU: $CPU_USAGE | MEM: $MEMORY_USAGE | DISK(/): $DISK_USAGE | ZOMBIES: $ZOMBIE_COUNT
EOF

exit 0
