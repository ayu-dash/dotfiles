#!/bin/bash

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

# Threshold
LOW=20
CRITICAL=15

BATTERY=$(upower -e | grep 'battery')
BATTERY_STATE=$(upower -i "$BATTERY" | grep -E "state" | awk '{print $2}')
BATTERY_PERCENTAGE=$(upower -i "$BATTERY" | grep -E "percentage" | awk '{print $2}' | sed 's/%//')

if [[ "$BATTERY_STATE" == "discharging" ]]; then
    if (( BATTERY_PERCENTAGE <= CRITICAL )); then
        notify-send -u critical -i battery-caution "Battery Critical" "Battery is at $BATTERY_PERCENTAGE%. Please plug in the charger."
    elif (( BATTERY_PERCENTAGE <= LOW )); then
        notify-send -u normal -i battery-low "Battery Low" "Battery is at $BATTERY_PERCENTAGE%. Consider plugging in the charger."
    fi
fi
