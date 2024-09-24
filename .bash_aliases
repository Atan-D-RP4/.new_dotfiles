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

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some aliases for cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# safety for rm
alias rm='rm -I'

# some more ls aliases
alias ll='ls -thlFHGgr'
alias la='ls -A'
alias l='ls -CF'
alias lsize='ls -A | xargs du -sh | sort -hr'

# alias of batcat
alias bcat='batcat'

#alias for go
alias go='~/Software/go/bin/go'

#alias for lazygit
alias lg='lazygit'

#alias for vim with fzf
alias vim?='vim $(fzf-tmux $FZF_TMUX_OPTS)'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Search for Command-Line Utilities
alias fzcmd='compgen -c | sort -gr | fzf -m --header "Available Command Utilities" | xargs man'

# Fuzzy Search across all available man pages
fzman='find /usr/share/man/ -type f -name "*.gz" | sed "s#.*/##" | sed "s/\.gz$//" | sort -hr | fzf --preview="zcat /usr/share/man/{}.gz" | xargs -r man'

# For deleting selected node-modules
alias findnode='find . -name 'node-modules' -type d |  xargs du -sh |  sort -hr | fzf -m --header "Select which ones to delete" --preview "cat $(dirname {})/package.json"'

# Fuzzy Search History
alias fzhst='history | awk "{print $2}" | sort | uniq -c | sort -nr | fzf-tmux -p80%,60% --no-preview'

# Configuration command alias
alias conf='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME/'
