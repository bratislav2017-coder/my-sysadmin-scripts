#!/usr/bin/env bash
set -eu

N=5
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${LOG_FILE:-$SCRIPT_DIR/monitor.log}"

if ! [[ "$N" =~ ^[1-9][0-9]*$ ]]; then
    printf 'Ошибка: N должно быть положительным целым числом.\n' >&2
    exit 1
fi

for tool in date free df uptime sleep; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        printf 'Ошибка: команда %s не найдена.\n' "$tool" >&2
        exit 1
    fi
done

mkdir -p -- "$(dirname -- "$LOG_FILE")"

if ! touch -- "$LOG_FILE"; then
    printf 'Ошибка: невозможно записать лог %s\n' "$LOG_FILE" >&2
    exit 1
fi

trap 'exit 0' INT TERM

while true; do
    {
        printf '\n--- %s ---\n' "$(date '+%Y-%m-%d %H:%M:%S %z')"
        printf '\nОперативная память:\n'
        free -h
        printf '\nФайловые системы:\n'
        df -h
        printf '\nВремя работы и нагрузка:\n'
        uptime
    } >> "$LOG_FILE"

    sleep "$N"
done
