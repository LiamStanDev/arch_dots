# Environment and PATH exports

# usr
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

# nodejs
export PNPM_HOME="$HOME/.pnpm"
PATH="$PNPM_HOME:$PATH"

# go
PATH=$HOME/go/bin:$PATH

# rust
export RUSTPATH="$HOME/.cargo/bin"
PATH="$RUSTPATH:$PATH"

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
