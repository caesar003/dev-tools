#!/bin/bash

# ~/.bin/dotbin/init-tmux.sh

# Ensure a configuration name is provided as a parameter
if [ -z "$1" ]; then
	echo "Usage: $0 <config-name>"
	exit 1
fi

# Path to the directory containing the JSON configurations
CONFIG_DIR="$HOME/.config/init-tmux"

# The name of the config file passed as the first argument
CONFIG_FILE="$CONFIG_DIR/$1.json"

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
	echo "Configuration file '$CONFIG_FILE' not found!"
	exit 1
fi

# Check if a session name was provided as an additional argument
if [ -z "$2" ]; then
	# If no session name is provided, use a default name with timestamp
	SESSION_NAME="session_$(date +%s)"
else
	# Use the provided session name
	SESSION_NAME="$2"
fi

# Create the tmux session with the first window (assuming it's always the first item in the JSON)
WINDOW_TITLE=$(jq -r '.[0].title' "$CONFIG_FILE")
tmux new-session -d -s $SESSION_NAME -n "$WINDOW_TITLE"

# Loop through the remaining windows in the JSON file
NUM_WINDOWS=$(jq '. | length' "$CONFIG_FILE")

for ((i = 1; i < $NUM_WINDOWS; i++)); do
	WINDOW_TITLE=$(jq -r ".[$i].title" "$CONFIG_FILE")
	tmux new-window -t $SESSION_NAME -n "$WINDOW_TITLE"

	# Check if the window has a split configuration
	WINDOW_SPLIT=$(jq -r ".[$i].window_split // empty" "$CONFIG_FILE")

	if [ ! -z "$WINDOW_SPLIT" ]; then
		# Split the window vertically if the split configuration is present
		tmux split-window -v -t $SESSION_NAME:$(($i + 1))
	fi
done

# Attach to the tmux session
tmux attach -t $SESSION_NAME
