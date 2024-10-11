#!/bin/bash

# Default values
author="Khaisar Muksid"
since="2024-09-24"
config_dir="$HOME/.logs/git"
config_file="$config_dir/repos.json"

while getopts a:s:c: flag; do
	case "${flag}" in
	a) author=${OPTARG} ;;
	s) since=${OPTARG} ;;
	c) config_file=${OPTARG} ;;
	esac
done

mkdir -p "$config_dir"

if [ ! -f "$config_file" ]; then
	echo "Configuration file not found at $config_file. Creating a default repos.json..."
	cat <<EOL >"$config_file"
{
  "repositories": []
}
EOL
	echo "A new repos.json has been created. Please add your repositories."
	exit 0
fi

log_base_dir="$HOME/.logs/git/$since/$author"
mkdir -p "$log_base_dir" # Ensure the log directory exists

repos=$(jq -r '.repositories[]' "$config_file")

if [ -z "$repos" ]; then
	echo "No repositories found in $config_file. Please add your repositories and try again."
	exit 1
fi

for repo in $repos; do
	project_name=$(basename "$repo")

	absolute_repo_path=$(realpath "$repo")

	if cd "$absolute_repo_path"; then
		log_dir="$log_base_dir/$project_name"
		mkdir -p "$log_dir"

		log_file="$log_dir/${project_name}-${since}.txt"

		git log --author="$author" --since="$since" >"$log_file"

		echo "Git log for $project_name has been saved to: $log_file"

		cd - >/dev/null
	else
		echo "Error: Unable to access repository at $repo"
	fi
done
