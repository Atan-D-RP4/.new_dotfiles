# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# Enable Vi mode
# set -o vi                             # don't put duplicate lines or lines starting with space in the history.

# Run kanata to remap Caps Lock to Escape
# if [ -f $HOME/.local/bin/kanata.sh ]; then
# 	$HOME/.local/bin/kanata.sh > /dev/null 2>&1
# fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color) color_prompt=yes;;
esac

# If in Tmux session, set $TERM to screen-256color or tmux-256color
if [ -n "$TMUX" ]; then
	case "$TERM" in
		screen-256color) ;;
		*) export TERM=screen-256color;;
	esac
fi

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
	. ~/.bash_wsl
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# bash theme - partly inspired by https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/robbyrussell.zsh-theme
__bash_prompt() {
	local userpart='\[\033[0;32m\]\u'
	if [ ! -z "${GITHUB_USER}" ]; then
		userpart+="@\[\033[0;32m\]${GITHUB_USER}"
	fi
	local xit="$?"
	if [ "$xit" -ne "0" ]; then
		userpart+="\[\033[1;31m\]"
	else
		userpart+="\[\033[0m\]"
	fi

	local gitbranch=""
	if [ "$(git config --get devcontainers-theme.hide-status 2>/dev/null)" != 1 ] && [ "$(git config --get codespaces-theme.hide-status 2>/dev/null)" != 1 ]; then
		local branch="$(git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git --no-optional-locks rev-parse --short HEAD 2>/dev/null)"
		if [ ! -z "${branch}" ]; then
			gitbranch+="\[\033[0;36m\](\[\033[1;31m\]${branch}"
			if [ "$(git config --get devcontainers-theme.show-dirty 2>/dev/null)" = 1 ] && git --no-optional-locks ls-files --error-unmatch -m --directory --no-empty-directory -o --exclude-standard ":/*" > /dev/null 2>&1; then
				gitbranch+=" \[\033[1;33m\]✗"
			fi
			gitbranch+="\[\033[0;36m\]) "
		fi
	fi

	PS1="${userpart}\[\033[0;32m\]@\h➜ \[\033[1;34m\]\w ${gitbranch}\[\033[0m\]\$ "
}
__bash_prompt

# Function to update prompt when changing directories
update_prompt() {
	local dir="$PWD"
	while [ "$dir" != "/" ]; do
		if [ -d "$dir/.git" ]; then
			__bash_prompt
			return
		fi
		dir="$(dirname "$dir")"
	done
	PS1='\[\033[0;32m\]\u@\h➜ \[\033[1;34m\]\w \$ \[\033[0m\]'
}

# Flag to track if ssh-agent has been started within the tmux session
SSH_AGENT_STARTED_FLAG="/tmp/ssh_agent_started_$USER"

# Function to start or use an existing SSH agent and add the SSH key
function setgit() {
	# Check if ssh-agent has been started within the current tmux session
	if [ ! -f "$SSH_AGENT_STARTED_FLAG" ]; then
		echo "Starting SSH agent"
		if ! pgrep -U "$USER" ssh-agent > /dev/null; then
			eval "$(ssh-agent -s)"
			echo "SSH agent started"
			# Set the flag to indicate that ssh-agent has been started within the tmux session
			touch "$SSH_AGENT_STARTED_FLAG"
		fi
	fi
	ssh-add ~/.ssh/Github/id_ed25519
}

function fzf_preview() {
	if [ -f "$1" ]; then
		if [[ "$1" == *.gz ]]; then
			zcat "$1"
			batcat --style=numbers --color=always --line-range :100 "$1"
		else
			batcat --style=numbers --color=always --line-range :100 "$1"
		fi
	elif [ -d "$1" ]; then
		ls -l "$1"
	fi
}

# Create a function for this alias: alias setdate='sudo date -s "$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d" " -f5-8)Z"'
function set_date() {
	sudo date -s "$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d" " -f5-8)Z"
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ~/DOTFILES/scripts/update_git.sh &

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
