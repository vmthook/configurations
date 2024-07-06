#!/bin/sh

while true; do
	BATT=$(cat /sys/class/power_supply/BAT1/capacity)
	DATE=$(date +"%H:%M:%S")
	ROOT="$BATT% $DATE"

	xsetroot -name "$ROOT"
	sleep 1
done
