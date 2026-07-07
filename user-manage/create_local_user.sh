#!/bin/bash

# create_local_user.sh : Craete a local linux user with safe defaults
# Notes : if --no-password is omitted , this will prompt to set a pwd
# Will create a group if it doesnt exist

set -Eeuo pipefail

USERNAME="${1:-}"
SHELL_BIN="/bin/bash"
PRIMARY_GROUP=""
NO_PASSWORD=false

[[ -n "$USERNAME" ]] || { echo "Usage : $0 <username> [--shell /bin/bash] [--group mygroup] [--no-password]"; exit 1; } # -n : string not empty , || : Short circuit OR if right isde fails run right side

shift || true #Shift:since we are not using 1st Positional parameter (username)
while [[ $# -gt 0 ]]; do
        case "$1" in
                --shell) SHELL_BIN="${2:-/bin/bash}"; shift 2 ;;
                --group) PRIMARY_GROUP="${2:-}"; shift 2 ;;
                --no-password) NO_PASSWORD=true; shift ;;
                *) echo "Unknown option : $1"; exit 1 ;;
        esac
done

#If user already exists
if id "$USERNAME" &>/dev/null; then
        echo "Error : User already exists."
        exit 2
fi

# ensure group exists (if provided)
if [[ -n "$PRIMARY_GROUP" ]]; then
        getent group "$PRIMARY_GROUP" >/dev/null || groupadd "$PRIMARY_GROUP"
        useradd -m -s "$SHELL_BIN" -g "$PRIMARY_GROUP" "$USERNAME"
else
        useradd -m -s "$SHELL_BIN" "$USERNAME"
fi

# Password policy : non expiring
chage -I -1 -m 0 -M 9999 -E -1 "$USERNAME" # chage : change age , -I -1 : No inactivity lockout , -m 0 : min pwd age (user can chnage t immediately) , -m 9999 : max pwd age (nvr expires)

# Home permissions (private)
chmod 700 "/home/$USERNAME"

# optional password
if ! $NO_PASSWORD; then
        echo "Set password for '$USERNAME':"
        passwd "$USERNAME"
fi

echo "User '$USERNAME' created."
