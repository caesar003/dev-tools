#!/bin/bash

# Directory to start from (passed as argument or defaults to current directory)
log_base_dir="${1:-$HOME/.logs/git}"

# Function to delete empty files
delete_empty_files() {
	find "$1" -type f -name "*.txt" -empty -delete
}

# Function to delete empty directories (after files are removed)
delete_empty_directories() {
	find "$1" -type d -empty -delete
}

# Execute the cleanup
echo "Cleaning up logs in: $log_base_dir"

delete_empty_files "$log_base_dir"       # Remove empty .txt files
delete_empty_directories "$log_base_dir" # Remove empty directories

echo "Cleanup complete!"
