#!/bin/bash

echo "Enter username: "
read user

if ! id "$user" &>/dev/null; then
        echo "User doesnt exist"
        exit 1
fi

status=$(passwd -S "$user" | awk '{print $2}')
if [ "$status" = "LK" ]; then
        sudo passwd -u "$user"
else
        echo "user is not locked."
fi
