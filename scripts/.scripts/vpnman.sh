#!/bin/bash

# Variables
SERVICE="awg-quick@wg0.service"
INTERFACE="RT-5GPON-800C"

# ANSI colors
GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

clear
echo -e "${GREEN}Amnezia vpn switcher\n${NC}"

while true; do
    if systemctl is-active "$SERVICE" &>/dev/null; then
        STATUS="${GREEN}running${NC}"
        # ACTION="stop"
    else
        STATUS="${RED}stopped${NC}"
        # ACTION="start"
    fi
    echo -e "Current state of $SERVICE: $STATUS"
    echo -e "${BLUE}Press s to switch state, q to quit${NC}"
    read -r choice
    if [[ "$choice" == "q" ]]; then
        break
    elif [[ "$choice" == "s" ]]; then
        if [ "$STATUS" = "${GREEN}running${NC}" ]; then
            echo "wait ..."
            systemctl stop "$SERVICE" && nmcli con down id "$INTERFACE" > /dev/null && nmcli con up id "$INTERFACE" > /dev/null

            # echo "$SERVICE stopped."
        else
            resolvconf -u && systemctl start "$SERVICE"
            # echo "$SERVICE started."
        fi
    fi
done
