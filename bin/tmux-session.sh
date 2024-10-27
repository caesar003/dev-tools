#!/bin/bash

# ~/.bin/tmux-session.sh

# Configuration paths
CONFIG_DIR="$HOME/.config/tmux-session"
SETTING_FILE="$CONFIG_DIR/setting.conf"
LAYOUTS_DIR="$CONFIG_DIR/layouts"

# Ensure configuration and layouts directories exist
mkdir -p "$CONFIG_DIR"
mkdir -p "$LAYOUTS_DIR"

# Function to list available layouts
list_layouts() {
	if compgen -G "$LAYOUTS_DIR/*.json" >/dev/null; then
		echo "Available layouts:"
		for layout_file in "$LAYOUTS_DIR"/*.json; do
			layout_name=$(basename "$layout_file" .json)
			echo "$layout_name"
		done
	else
		echo "No layouts found in $LAYOUTS_DIR."
	fi
}

# Function to set a default layout
set_default_layout() {
	local layout_name="$1"
	if [ -z "$layout_name" ]; then
		echo "Error: A layout name is required for '-d' (set default)."
		exit 1
	fi

	echo "Setting DEFAULT_LAYOUT to '$layout_name' in $SETTING_FILE."
	echo "DEFAULT_LAYOUT=\"$layout_name\"" >"$SETTING_FILE"

	local layout_file="$LAYOUTS_DIR/$layout_name.json"
	if [ ! -f "$layout_file" ]; then
		echo "Creating layout file '$layout_file' with default content."
		echo '[{"title": "editor"}]' >"$layout_file"
	else
		echo "Layout file '$layout_file' already exists. Skipping creation."
	fi
}

# Function to initialize a tmux session
init_session() {
	local layout_name="$1"
	local session_name="$2"

	# If no layout name is provided, read the default from settings
	if [ -z "$layout_name" ]; then
		if [ -f "$SETTING_FILE" ]; then
			source "$SETTING_FILE"
			if [ -n "$DEFAULT_LAYOUT" ]; then
				layout_name="$DEFAULT_LAYOUT"
			else
				echo "Error: No layout specified, and DEFAULT_LAYOUT is empty in $SETTING_FILE."
				exit 1
			fi
		else
			echo "Error: No layout specified, and $SETTING_FILE does not exist."
			exit 1
		fi
	fi

	# Define the path to the layout file based on the resolved layout name
	local layout_file="$LAYOUTS_DIR/$layout_name.json"
	if [ ! -f "$layout_file" ]; then
		echo "Error: Layout file '$layout_file' not found!"
		exit 1
	fi

	# Set default session name if none is provided
	if [ -z "$session_name" ]; then
		session_name="session_$(date +%s)"
	fi

	# Create the tmux session and first window
	WINDOW_TITLE=$(jq -r '.[0].title' "$layout_file")
	tmux new-session -d -s "$session_name" -n "$WINDOW_TITLE"

	# Loop through windows in the layout JSON
	local num_windows=$(jq '. | length' "$layout_file")
	for ((i = 1; i < num_windows; i++)); do
		WINDOW_TITLE=$(jq -r ".[$i].title" "$layout_file")
		tmux new-window -t "$session_name" -n "$WINDOW_TITLE"

		WINDOW_SPLIT=$(jq -r ".[$i].window_split // empty" "$layout_file")
		if [ -n "$WINDOW_SPLIT" ]; then
			tmux split-window -v -t "$session_name:$(($i + 1))"
		fi
	done

	# Attach to the tmux session
	tmux attach -t "$session_name"
}

# Parse flags
while getopts ":i:d:l" opt; do
	case $opt in
	i)
		init_flag=true
		layout_name="$OPTARG"
		;;
	d)
		set_default_layout "$OPTARG"
		exit 0
		;;
	l)
		list_layouts
		exit 0
		;;
	\?)
		echo "Invalid option: -$OPTARG" >&2
		exit 1
		;;
	:)
		echo "Option -$OPTARG requires an argument." >&2
		exit 1
		;;
	esac
done
shift $((OPTIND - 1))

# Execute initialize session if -i flag is set, otherwise use default layout if available
if [ "$init_flag" = true ]; then
	init_session "$layout_name" "$1"
else
	# Use default layout if no layout name is provided
	init_session "" "$1"
fi
