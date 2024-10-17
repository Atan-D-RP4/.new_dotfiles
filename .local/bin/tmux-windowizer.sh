#!/usr/bin/env bash

branch_name=$(basename $1)
session_name=$(tmux display-message -p "#S")
clean_name=$(echo $branch_name | tr "./" "__")
target="$session_name:$clean_name"

echo "$session_name $clean_name $target"

if ! tmux has-session -t $target 2> /dev/null; then
	echo "Creating new window for $clean_name in $session_name"
	tmux neww -dn $clean_name
fi

shift
tmux send-keys -t $target "$*"
