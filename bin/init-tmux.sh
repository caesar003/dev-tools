#!/bin/bash

# ~/.bin/dotbin/init-tmux.sh

# Check if a session name was provided as an argument
if [ -z "$1" ]; then
	# If no session name is provided, use a default name with timestamp
	SESSION_NAME="session_$(date +%s)"
else
	# Use the provided session name
	SESSION_NAME="$1"
fi

# Create a new tmux session with the specified or default name and the first window named 'editor'
tmux new-session -d -s $SESSION_NAME -n editor

# Create a new window named 'git + npm'
tmux new-window -t $SESSION_NAME -n 'git + npm'

# Split the new window into two panes horizontally
tmux split-window -v -t $SESSION_NAME:2

# Attach to the tmux session
tmux attach -t $SESSION_NAME
