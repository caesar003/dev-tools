#!/bin/bash

# Default values
author="Khaisar Muksid"
since="2024-09-24"

# Get project name from the current working directory
project_name=$(basename "$PWD")

# Handle input arguments for author and since
while getopts a:s: flag; do
	case "${flag}" in
	a) author=${OPTARG} ;;
	s) since=${OPTARG} ;;
	esac
done

# Create log file path in the format ~/.logs/git/<since>/<author>/
log_dir="$HOME/.logs/git/$since/$author"
mkdir -p "$log_dir" # Ensure the directory structure exists

log_file="$log_dir/${project_name}-${since}.txt"

# Run git log command and save to the file
git log --author="$author" --since="$since" >"$log_file"

# Output the location of the log file
echo "Git log has been saved to: $log_file"
