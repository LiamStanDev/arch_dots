# Aliases
# system
alias -- ..="cd .."
alias -- ...="cd ../.."
alias -- ....="cd ../../.."
alias -- rm='echo "This is not the command you are looking for."; false'
alias -- sys="sudo systemctl"
alias -- sysu="systemctl --user"
alias -- j="journalctl --no-pager -u"
alias -- ju="journalctl --user --no-pager -u"
alias -- cp="cp --interactive"
alias -- mv="mv --interactive"
alias -- mkdir="mkdir -p"
alias -- c="clear"
alias -- poweroff="systemctl poweroff"
alias -- reboot="systemctl reboot"

# edit
alias -- e="$EDITOR"
alias -- E="sudo -e"

# ls
if command -v eza &>/dev/null; then
  alias -- ls="eza"
  alias -- ll="eza -l"
  alias -- la="eza -la"
  alias -- lt="eza --tree"
  alias -- lR="eza -lR"
else
  log "missing eza"
fi

# cd
if command -v z &>/dev/null; then
  alias -- cd="z"
else
  log "missing zoxide"
fi

# trash-cli
if command -v trash-put &>/dev/null; then
  alias -- del="trash-put"
  alias -- emptytrash="trash-empty"
  alias -- undel="trash-restore"
else
  log "missing trash-cli"
fi

# rg
if command -v rg &>/dev/null; then
  alias -- rg="rg --hidden --smart-case --glob='!.git/' --no-search-zip --trim --colors=line:fg:black --colors=line:style:bold --colors=path:fg:magenta --colors=match:style:nobold"
else
  log "missing ripgrep"
fi

# pnpm
if command -v pnpm &>/dev/null; then
  alias -- pn="pnpm"
else
  log "missing pnpm"
fi

# tmux
if command -v tmux &>/dev/null; then
  alias -- tn="tmux new -s"
  alias -- ta="tmux attach -t"
  alias -- tls="tmux ls"
  alias -- tk="tmux_kill_fzf"
  alias -- ts='tmux attach -t $(tmux ls | fzf | awk -F: "{print \$1}")'
else
  log "missing tmux"
fi

# lazygit
if command -v lazygit &>/dev/null; then
  alias -- lzg="lazygit"
else
  log "missing lazygit"
fi

# lazydocker
if command -v lazygit &>/dev/null; then
  alias -- lzd="lazydocker"
else
  log "missing lazydocker"
fi

# git
if command -v git &>/dev/null; then
  alias -- gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n"'
  alias -- gs="git status --short"

  alias -- ga="git add"
  alias -- gap="git add --patch"
  alias -- gA="git add --all"
  alias -- gd="git diff --output-indicator-new=' ' --output-indicator-old=' '"
  alias -- gds="gd --staged"

  alias -- gc="git commit"
  alias -- gce="gc --amend"
  alias -- gca="gc --amend --no-edit"

  alias -- gu="git pull"
  alias -- gp="git push"

  alias -- gt="git stash"
  alias -- gtp="git stash pop"
else
  log "missing git"
fi

# docker
if command -v docker &>/dev/null; then
  alias -- dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.ID}}\t{{.Image}}"'
  alias -- dsh="docker exec -it"
  alias -- dl="docker logs --tail=100"
  alias -- dc="docker compose"
else
  log "missing docker"
fi
