#!/bin/bash

# check_port.sh : check if a TCP port is reachable  (local or remote)

# Usage: ./check_port.sh <host> <port> [timeout_sec]

# Exit codes : 0=reachable, 1=unreachable, 2=arg error

set -Eeuo pipefail # -E : Presrve error traps

HOST=${1:-} # 1 : 1st cmd line arg or use empty string
PORT=${2:-}
TIMEOUT=${3:-3}

if [[ -z "$HOST" || -z "$PORT" ]]; then  # -z : string length is zero
        echo "Usage : $0 <host> <port> [timeout_sec]"; exit 2 # $0 : 0th cmd arg : script name
fi

if command -v nc >/dev/null 2>&1; then # check if Netcat(Network troubleshooting utility) exists , command : shell built in , -v : verify if cmd exists , /dev/null : special  file that discards op, 2>&1 : redirects stderr to stdout
        if nc -z -w "$TIMEOUT" "$HOST" "$PORT"; then # -z : zero I/O mode dont send data just test connection, -w : wait timeout
                echo "Ok: $HOST:$PORT reachable"; exit 0
        else
                echo "FAIL: $HOST:$PORT unreachable"; exit 1
        fi
elif command -v timeout >/dev/null 2>&1 && command -v bash >dev/null 2>&1; then
        # Fallback using dev/tcp
        if timeout "$TIMEOUT" bash -c "echo > /dev/tcp/$HOST/$PORT" 2>/dev/null; then
                echo "Ok: $HOST:$PORT reachable"; exit 0
        else
                echo "Fail: $HOST:$PORT unreachable"; exit 1
        fi
else
        echo "ERROR: need 'nc' or 'timeout' with bash /dev/tcp"; exit 1
fi
