source ~/.bashrc

# Sets the Dotfiles directory
export DOTFILES="$HOME/.dotfiles"

# Sets local bin directory
export PATH="$HOME/.local/bin/:$PATH"

# Sets user config directory
export XDG_CONFIG_HOME="$HOME/.config"

# Changes ls output colors
export LS_COLORS=$LS_COLORS":ow=30;103"

# Set PROMPT_COMMAND to call update_prompt function
export PROMPT_COMMAND="update_prompt; $PROMPT_COMMAND"

# =============SDKs==========================
# Sets cargo path
source "$HOME/.cargo/env"

# Sets Go path
export PATH="$HOME/go/bin:$PATH"

# Sets Mojo/Modular path
export MODULAR_HOME="$HOME/.modular"
export PATH="$HOME/.modular/pkg/packages.modular.com_mojo/bin:$PATH"

export PATH="$HOME/.flutter/bin:$PATH"

# =============SDKs==========================

# ================HISTORY====================

# Share history between shell sessions
export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

shopt -s histappend                                 # append to the history file, don't overwrite it

export HISTTIMEFORMAT="%F %T "                      # show the date and time of each command in the history
export HISTCONTROL="ignoreboth:ignorespace:erasedups:ignoredups"
# don't put duplicate lines or lines starting with space in the history.
export HISTSIZE=5000000
export HISTFILESIZE=5000000                         # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTIGNORE="ls:ll:cd:vim:clear:history*"
# don't put these commands in the history

# ================HISTORY====================

# Sets default editor
export EDITOR="vim"
export VISUAL="vim"

# Sets Timezone
export PROMPT_DIRTRIM=4
export TZ=Asia/Kolkata

# Sets Display for WSL browser
export DISPLAY=:0
export BROWSER=/usr/bin/wslview

# If built from source
# Enable keybindings and auto-completion for FZF
##[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# If Installed with APT
# Enable keybindings for FZF
if [[ -e /usr/share/doc/fzf/examples/key-bindings.bash ]]; then
	source /usr/share/doc/fzf/examples/key-bindings.bash
	# source $DOTFILES/keybindings.bash
fi

# Enable auto-completion for FZF
if [[ -e /usr/share/bash-completion/completions/fzf ]]; then
	source /usr/share/bash-completion/completions/fzf
	# source $DOTFILES/completions.fzf
fi

if type rg &> /dev/null; then
	export FZF_COMPLETION_TRIGGER="@"
	export FZF_TMUX_OPTS='-p80%,60%' # This does indeed work
	export FZF_DEFAULT_COMMAND="rg -L --files --no-ignore | sort"
	export FZF_CTRL_T_COMMAND="rg -L --files --no-ignore | sort"
	export FZF_ALT_C_COMMAND="find -L . -maxdepth 3 -type d -not -path '*/\.git*'"
	export FZF_ALT_C_OPTS="--preview 'ls -l {}'"
	# Using the preview function
	export FZF_DEFAULT_OPTS="-m --height 50% --border --reverse --preview \
		'if file --mime-type {} | grep -q gzip; then
			zcat {} | batcat --style=numbers --color=always --line-range :100
		elif file --mime-type {} | grep -qiE audio\|video\|image; then
			exiftool {}
		elif [[ -f {} ]]; then
			batcat --style=numbers --color=always --line-range :100 {}
		elif [[ -d {} ]]; then
			ls -lh {}
		fi'"
fi

# fortune -a | cowsay | lolcat
