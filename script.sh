#!/usr/bin/env bash
 
INTERVAL=60          # период опроса в секундах
LOG_FILE="monitor.log"

# проверка наличия утилит
missing=()
for cmd in free df uptime date; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
done
if ((${#missing[@]})); then
    echo "monitor: не найдены утилиты: ${missing[*]}" >&2
    exit 1
fi

# штатное завершение
cleanup() {
    echo "--- $(date '+%Y-%m-%d %H:%M:%S') stopped ---" >> "$LOG_FILE"
    exit 0
}
trap cleanup INT TERM

while true; do
    {
        echo "--- $(date '+%Y-%m-%d %H:%M:%S') ---"
        free -h
        df -h
        uptime
    } >> "$LOG_FILE"
    sleep "$INTERVAL"
done
