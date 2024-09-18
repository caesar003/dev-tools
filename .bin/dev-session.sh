#!/bin/bash

# ~/.bin/dotbin/dev-session.sh

# Define the session directory
SESSION_DIR=~/.dev-sessions

# Create the config directory if it doesn't exist
mkdir -p $SESSION_DIR

# Function to save the kitty state
save_state() {
  local session_name="${1:-kitty_state}"
  local state_file="$SESSION_DIR/${session_name}.json"

  kitty @ ls | jq '[.[0].tabs[] | {title: .title, cwd: .windows[0].cwd}]' > "$state_file"
  echo "Kitty state saved to $state_file"
}

# Function to restore the kitty state
restore_state() {
  local session_name="${1:-kitty_state}"
  local state_file="$SESSION_DIR/${session_name}.json"

  if [ ! -f "$state_file" ]; then
    echo "No state file found at $state_file"
    exit 1
  fi

  state=$(cat "$state_file")
  num_tabs=$(echo "$state" | jq '. | length')

  for ((i=0; i<$num_tabs; i++)); do
    cwd=$(echo "$state" | jq -r ".[$i].cwd")
    title=$(echo "$state" | jq -r ".[$i].title")
    if [ $i -eq 0 ]; then
      kitty @ set-tab-title "$title"
      cd "$cwd"
    else
      kitty @ launch --type=tab --tab-title="$title" --cwd="$cwd"
    fi
  done

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
  ls -1 $SESSION_DIR/*.json 2>/dev/null | sed 's|^.*/||' | sed 's/\.json$//'
}

# Check the parameter and call the appropriate function
case "$1" in
  save|-s)
    save_state "$2"
    ;;
  restore|-r)
    restore_state "$2"
    ;;
  destroy|-d)
    destroy_tabs
    ;;
  list|-l)
    list_sessions
    ;;
  *)
    echo "Usage: devs {save|-s|restore|-r|destroy|-d|list|-l}"
    exit 1
    ;;
esac
