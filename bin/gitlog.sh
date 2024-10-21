#!/bin/bash

# ~/.bin/gitlog.sh

# Create executable binary or use symbolic link (see instructions in previous version)

# Paths and configuration
config_dir="$HOME/.config/gitlog"
config_file="$config_dir/config"
repos_file="$config_dir/repositories.json"
log_base_dir="$HOME/.logs/git"

# Ensure necessary directories exist
mkdir -p "$config_dir" "$log_base_dir"

# Load or initialize the configuration file
if [ ! -f "$config_file" ]; then
	echo "No config file found. Creating a new one at $config_file."
	cat <<EOL >"$config_file"
# Gitlog Configuration
default_author=""
default_since_date=""
EOL
fi

# Source the config file to load default values
source "$config_file"

# Function to set default user and since date
set_default_values() {
	echo "Setting default values for user and since date..."
	read -p "Enter default author (user): " default_author
	read -p "Enter default since date (e.g., '1 month ago'): " default_since_date

	# Update the config file with new values
	cat <<EOL >"$config_file"
# Gitlog Configuration
default_author="$default_author"
default_since_date="$default_since_date"
EOL

	echo "Defaults updated: author='$default_author', since_date='$default_since_date'"
}

# Parse optional flags for overriding values or setting defaults
while getopts a:s:c:d flag; do
	case "${flag}" in
	a) author=${OPTARG} ;;     # Override author
	s) since=${OPTARG} ;;      # Override since date
	c) repos_file=${OPTARG} ;; # Use custom repositories file
	d)
		set_default_values
		exit 0
		;; # Set default values and exit
	esac
done

# Use defaults if author or since are not provided via flags
author=${author:-$default_author}
since=${since:-$default_since_date}

# Check if defaults are set, if not, prompt the user
if [ -z "$author" ] || [ -z "$since" ]; then
	echo "Error: Default author or since date is not set."
	echo "Please set them using the -d flag or provide them via -a and -s flags."
	exit 1
fi

# Check if the repositories file exists, create if missing
if [ ! -f "$repos_file" ]; then
	echo "Repositories file not found at $repos_file. Creating a default repositories.json..."
	cat <<EOL >"$repos_file"
{
  "repositories": []
}
EOL
	echo "A new repositories.json has been created. Please add your repositories."
	exit 0
fi

# Create the log directory based on 'since' and 'author' inputs
log_dir="$log_base_dir/$since/$author"
mkdir -p "$log_dir"

# Extract repositories from the repositories.json file
repos=$(jq -r '.repositories[]' "$repos_file")

# Exit if no repositories are found
if [ -z "$repos" ]; then
	echo "No repositories found in $repos_file. Please add your repositories and try again."
	exit 1
fi

# Loop through each repository and fetch git logs
for repo in $repos; do
	project_name=$(basename "$repo")
	absolute_repo_path=$(realpath "$repo")

	if cd "$absolute_repo_path"; then
		repo_log_dir="$log_dir/$project_name"
		mkdir -p "$repo_log_dir"

		log_file="$repo_log_dir/${project_name}-${since}.txt"

		# Generate the git log
		git log --author="$author" --since="$since" >"$log_file"
		echo "Git log for $project_name has been saved to: $log_file"

		# Return to the previous directory
		cd - >/dev/null
	else
		echo "Error: Unable to access repository at $repo"
	fi
done
