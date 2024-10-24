#!/bin/bash

# ~/.bin/dev-session.sh

# Define the session directory
SESSION_DIR=~/.config/dev-session/sessions

# Create the config directory if it doesn't exist
mkdir -p $SESSION_DIR

# Function to save the kitty state
save_state() {
	local session_name="$1"
	if [ -z "$session_name" ]; then
		echo "Error: Session name must be provided for saving."
		exit 1
	fi
	local state_file="$SESSION_DIR/${session_name}.txt"

	kitty @ ls | jq '[.[0].tabs[] | {title: .title, cwd: .windows[0].cwd}]' >"$state_file"
	echo "Kitty state saved to $state_file"
}

# Function to restore the kitty state
restore_state() {
	local session_name="$1"
	if [ -z "$session_name" ]; then
		echo "Error: Session name must be provided for restoring."
		exit 1
	fi
	local state_file="$SESSION_DIR/${session_name}.txt"

	if [ ! -f "$state_file" ]; then
		echo "No state file found at $state_file"
		exit 1
	fi

	# Read the file line by line
	tab_number=0
	while IFS=' ' read -r title cwd; do
		# Prefix the title with its number (starting from 1)
		numbered_title="$((tab_number + 1)). $title"

		if [ $tab_number -eq 0 ]; then
			kitty @ set-tab-title "$numbered_title"
			kitty @ send-text "cd \"$cwd\"\n"
		else
			kitty @ launch --type=tab --tab-title="$numbered_title" --cwd="$cwd"
		fi
		((tab_number++))
	done <"$state_file"

	echo "Kitty state restored from $state_file"
}

# Function to destroy all tabs except one
destroy_tabs() {
	# Get the list of tab IDs
	tabs=$(kitty @ ls | jq '.[0].tabs[].id')

	# Check if there is more than one tab to destroy
	if [ $(echo "$tabs" | wc -l) -le 1 ]; then
		echo "There is only one tab open, nothing to destroy."
		exit 0
	fi

	# Destroy all tabs except the first one
	for tab in $(echo "$tabs" | tail -n +2); do
		kitty @ close-tab --match id:$tab
	done

	echo "All tabs except one have been destroyed."
}

# Function to list available session files
list_sessions() {
	echo "Available sessions:"
	ls -1 $SESSION_DIR/*.txt 2>/dev/null | sed 's|^.*/||' | sed 's/\.txt$//'
}

# Check the parameter and call the appropriate function
case "$1" in
save | -s)
	save_state "$2"
	;;
restore | -r)
	restore_state "$2"
	;;
destroy | -d)
	destroy_tabs
	;;
list | -l)
	list_sessions
	;;
*)
	echo "Usage: devs {save|-s|restore|-r|destroy|-d|list|-l}"
	exit 1
	;;
esac
