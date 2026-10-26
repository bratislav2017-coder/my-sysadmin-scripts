#!/usr/bin/env bash
set -u

monitor_pid=
http_pid=

stop_children() {
    for process_id in "${monitor_pid:-}" "${http_pid:-}"; do
        if [[ -n "$process_id" ]]; then
            kill "$process_id" 2>/dev/null || true
        fi
    done
    wait 2>/dev/null || true
}

finish() {
    stop_children
    exit 0
}

trap finish INT TERM

/usr/local/bin/script.sh &
monitor_pid=$!

for attempt in {1..50}; do
    if [[ -f "$LOG_FILE" ]]; then
        break
    fi
    if ! kill -0 "$monitor_pid" 2>/dev/null; then
        wait "$monitor_pid" || exit $?
        exit 1
    fi
    sleep 0.1
done

if [[ ! -f "$LOG_FILE" ]]; then
    stop_children
    exit 1
fi

python3 -m http.server 8080 --bind 0.0.0.0 --directory /var/www &
http_pid=$!

status=1
wait -n "$monitor_pid" "$http_pid" || status=$?
stop_children
exit "$status"
