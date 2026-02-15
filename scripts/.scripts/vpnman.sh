#!/bin/bash

SERVICE="awg-quick@wg0.service"
INTERFACE="RT-5GPON-800C"

while true; do
    STATUS=$(systemctl is-active --quiet "$SERVICE" && echo "running" || echo "stopped")
    echo "Current state of $SERVICE: $STATUS"
    echo "Press s to switch state, q to quit"
    read -r choice
    if [[ "$choice" == "q" ]]; then
        break
    elif [[ "$choice" == "s" ]]; then
        if [ "$STATUS" = "running" ]; then
            systemctl stop "$SERVICE" && nmcli con down id "$INTERFACE" && nmcli con up id "$INTERFACE"

            echo "$SERVICE stopped."
        else
            resolvconf -u && systemctl start "$SERVICE"
            echo "$SERVICE started."
        fi
    fi
done
