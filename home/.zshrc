# ---------- ENV ----------
export EDITOR="nvim"
export VISUAL="nvim"
export PATH="$HOME/.local/bin:$PATH"

# Go XDG-style paths
export GOPATH="$HOME/.local/share/go"
export GOBIN="$GOPATH/bin"
export GOMODCACHE="$GOPATH/pkg/mod"
export GOCACHE="$HOME/.cache/go-build"
export PATH="$GOBIN:$PATH"

# ---------- HISTORY ----------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt hist_ignore_all_dups
setopt share_history
setopt inc_append_history

# ---------- BEHAVIOR ----------
setopt autocd
setopt interactivecomments
PROMPT='%2~ %# '
# keybindings (emacs)
bindkey -e

# ---------- COMPLETION ----------
autoload -Uz compinit
compinit

# ---------- YAZI (reemplazo ranger) ----------
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if [ -f "$tmp" ]; then
        local cwd="$(cat "$tmp")"
        [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && cd "$cwd"
    fi
    rm -f "$tmp"
}

# ---------- ALIASES ----------
alias ll="ls -lah"
alias la="ls -A"
alias gs="git status"
alias v="nvim"

# ---------- TOOLS (Inicialización al final para respetar el PATH) ----------

# mise (Activación dinámica oficial)
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
elif [ -f "$HOME/.local/share/mise/activate" ]; then
    # Fallback si mise no está en el PATH global todavía
    eval "$($HOME/.local/share/mise/bin/mise activate zsh)"
fi

# zoxide (cd inteligente)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# starship prompt (si lo usas)
command -v starship >/dev/null && eval "$(starship init zsh)"

  # personal-os habit tracker
export PERSONAL_OS="$HOME/Documents/01-Proyects/personal-os"
export VICTUS_HABITS_DB="$PERSONAL_OS/data/tracker.db"

alias habit="$PERSONAL_OS/.venv/bin/habit"
alias habit-timer="$PERSONAL_OS/.venv/bin/habit-timer"

# ---------- STARTUP ----------
if [[ $- == *i* ]]; then
    command -v fastfetch >/dev/null && fastfetch
fi
