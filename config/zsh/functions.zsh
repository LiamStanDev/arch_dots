# Custom functions
function log() {
  echo "[+] $*"
}

function tmux_kill_fzf() {
  local session=$(tmux ls | fzf | awk -F: '{print $1}')
  if [[ -n "$session" ]]; then
    read -q "REPLY?Kill session '$session'? [y/N] "
    echo
    [[ "$REPLY" == [Yy] ]] && tmux kill-session -t "$session"
  fi
}

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

function add_path() {
  # check args is directory and not in PATH
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1:$PATH"
  fi
}

function add_path_append() {
  # check args is directory and not in PATH
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$PATH:$1"
  fi
}
