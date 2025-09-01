# Environment and PATH exports
# Custom functions
source "$HOME/.config/zsh/functions.zsh"

# usr
add_path "$HOME/.local/bin"
add_path "$HOME/.local/share/nvim/mason/bin"

# nodejs
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
export PNPM_HOME="$HOME/.pnpm"
# npm config set strict-ssl false # For the first time (Cathay)
add_path "$PNPM_HOME"

# go
add_path "$HOME/go/bin"

# rust
export RUSTPATH="$HOME/.cargo/bin"
add_path "$RUSTPATH"

# History options
HISTSIZE="10000"
SAVEHIST="10000"
HISTFILE="$HOME/.zsh_history"
setopt HIST_FCNTL_LOCK          # Use file locking for history
unsetopt APPEND_HISTORY         # Don't append history (use with SHARE_HISTORY)
setopt HIST_IGNORE_DUPS         # Ignore consecutive duplicates
unsetopt HIST_IGNORE_ALL_DUPS   # Don't ignore all duplicates
unsetopt HIST_SAVE_NO_DUPS      # Save duplicates to history
unsetopt HIST_FIND_NO_DUPS      # Show duplicates in search
setopt HIST_IGNORE_SPACE        # Ignore commands starting with space
unsetopt HIST_EXPIRE_DUPS_FIRST # Don't expire duplicates first
setopt SHARE_HISTORY            # Share history between sessions
unsetopt EXTENDED_HISTORY       # Don't save timestamps

# Default
export EDITOR="nvim"
export VISUAL="$EDITOR"
. "$HOME/.cargo/env"
