#!/bin/bash

# lock user account to prevent logins

# Exit codes : 0 : ok ; 1: args ; 2 : user missing

set -Eeuo pipefail

USER_NAME="${1:-}"

if [[ -z "$USER_NAME" ]]; then
        echo "Username cannot be empty"
fi

if ! id "$USER_NAME" >/dev/null 2>&1; then
        echo "User does not exist"
        exit 2
fi

passwd -l "$USER_NAME"
chage -E 0 "$USER_NAME"

echo "Locked user : $USER_NAME"
exit 0
