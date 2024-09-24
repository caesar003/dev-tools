#!/bin/bash

# ~/.bin/dotbin/init-config.sh

# Check if a session name was provided as an argument
if [ -z "$1" ]; then
	# If no session name is provided, use a default name with timestamp
	SESSION_NAME="dev_tools_$(date +%s)"
else
	# Use the provided session name
	SESSION_NAME="$1"
fi

# Create a new tmux session with the specified or default name and the first window named 'dotbin'
tmux new-session -d -s $SESSION_NAME -n dotdevtools -c ~/.dev-tools

# Create a new window named 'kittyconf'
# tmux new-window -t $SESSION_NAME -n kittyconf -c ~/.config/kitty

# Attach to the tmux session
tmux attach -t $SESSION_NAME
