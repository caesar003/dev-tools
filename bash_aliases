# Example Zsh Aliases

 # Source VPN variables
if [ -f ~/.vpnconfig ]; then
    source ~/.vpnconfig
fi

# Shortcuts for navigation
alias cdw='cd ~/workspace'
alias cdb='cd ~/projects'
alias cdo='cd ~/documents'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --decorate --all --graph'

# Shortcuts for commonly used commands
alias ll='ls -lh'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'


alias pku='sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y'

# Docker aliases
alias dps='docker ps'
alias dlogs='docker logs'

# Miscellaneous
alias cls='clear'
alias h='history'
alias c='clear'
alias q='exit'

alias gbr='git branch | cat'


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


alias vpnconnect="sudo openconnect --protocol=gp -u $VPN_USER $VPN_URL --servercert $VPN_SERVER_SHA256"

# Custom functions
# Example: Reload Zsh configuration
reloadzsh() {
  source ~/.zshrc
  echo "Zsh configuration reloaded."
}

