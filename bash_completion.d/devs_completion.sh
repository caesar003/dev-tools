# Bash completion for dev-session.sh

_dev_session_completions() {
	# Check if the user is completing after the "-r" or "restore" argument
	local current prev opts
	current="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD - 1]}"
	opts="save restore destroy list -s -r -d -l"

	# If the previous word is "-r" or "restore", complete with session names
	if [[ "$prev" == "-r" || "$prev" == "restore" ]]; then
		COMPREPLY=($(compgen -W "$(ls ~/.dev-sessions/*.json 2>/dev/null | xargs -n 1 basename | sed 's/\.json$//')" -- "$current"))
	else
		# Default completion for the other options
		COMPREPLY=($(compgen -W "$opts" -- "$current"))
	fi
}

# Register the completion function for the dev-session.sh script
complete -F _dev_session_completions devs
