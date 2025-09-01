# Early initialization - Zinit plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Completions
FPATH="$HOME/.zfunc:$FPATH"
zi light "zsh-users/zsh-completions"

# Enable completion
autoload bashcompinit && bashcompinit # for support bash style completion
autoload -Uz compinit && compinit     # U: autoload, z: autoload completion functions
# complete -C "$(which aws_completer)" aws # this is bash style completion

# Plugins
zi light "zsh-users/zsh-history-substring-search"
zi light "zsh-users/zsh-autosuggestions"
zi light "zdharma/fast-syntax-highlighting"
zi light "hlissner/zsh-autopair"
zi light "jeffreytse/zsh-vi-mode"
zi light "Aloxaf/fzf-tab"

# Run third-party tools
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
else
  log "missing zoxide"
fi
if command -v fzf &>/dev/null; then
  eval "$(fzf --zsh)"
else
  log "missing fzf"
fi
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
else
  log "missing direnv"
fi
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  log "missing starship"
fi

# Aliases and functions
source "$HOME/.config/zsh/alias.zsh"
