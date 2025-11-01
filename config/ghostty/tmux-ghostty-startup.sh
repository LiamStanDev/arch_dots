#!/bin/bash
SESSION_NAME="ghostty"

if ! command -v tmux &>/dev/null; then
  echo "tmux is not installed. Falling back to default shell."
  exec $SHELL
fi

if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  tmux new-session -s "$SESSION_NAME" -d || {
    echo "Failed to create tmux session. Falling back to default shell."
    exec $SHELL
  }
fi

tmux attach-session -t "$SESSION_NAME" || {
  echo "Failed to attach to tmux session. Falling back to default shell."
  exec $SHELL
}
