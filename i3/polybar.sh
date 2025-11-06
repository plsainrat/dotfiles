#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
echo "---" | tee -a /tmp/polybar1.log 
polybar example 2>&1 | tee -a /tmp/polybar1.log & disown

