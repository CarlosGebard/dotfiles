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

# ---------- TOOLS ----------

# mise (tu manager principal)
[ -f "$HOME/.local/share/mise/activate" ] && source "$HOME/.local/share/mise/activate"

# zoxide (cd inteligente)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# starship prompt (si lo usas)
command -v starship >/dev/null && eval "$(starship init zsh)"

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

export PATH="$HOME/.local/share/mise/installs/node/24.14.1/bin:$PATH"

# ---------- STARTUP ----------
if [[ $- == *i* ]]; then
    command -v fastfetch >/dev/null && fastfetch
fi
