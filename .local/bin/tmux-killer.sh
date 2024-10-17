#!/bin/bash

selected=""
if [[ $# -eq 1 ]]; then
	selected=$1
else
	current_session=$(tmux display-message -p '#S')
	if [[ $current_session == "Main" ]]; then
		menu="$(tmux ls -F "#{session_name}" | grep -v "^Main\|Home")"
	else
		menu="$current_session"
		menu+=" $(tmux ls -F "#{session_name}" | grep -v "^Main\|Home\|$current_session")"
	fi

	if [[ -z $menu ]]; then
		echo "No other sessions to kill"
		exit 0
	fi
	selected+=$(echo "$menu" | tr ' ' '\n' | fzf-tmux -w 90% -h 80% --multi --preview " tmux-preview.sh {}")
fi

if [[ -z $selected ]]; then
	exit 0
fi

while IFS= read -r line; do
	if [[ -z $line ]]; then
		exit 0
	fi
done <<< "$selected"

for i in $selected; do
	echo "Killing session $i"
	selected_name=$(basename "$i" | tr . _)
	if [[ $i == $current_session ]]; then
		if [[ -n $(tmux switch-client -l) ]]; then
			tmux switch-client -t Main
		fi
	fi
	tmux kill-session -t $selected_name
	echo "Session $selected_name killed"
done

tmux_running=$(pgrep tmux)
if [[ -z $tmux_running ]]; then
	echo "No tmux server running, exiting"
	exit 0
else
	echo "Tmux server still running"
	tmux attach-session -t Main
fi

exit 0
