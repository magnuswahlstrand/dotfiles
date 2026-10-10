# Shared zsh config (macOS laptop + Linux home server).
# Machine-specific settings and secrets go in ~/.zshrc.local (not tracked).

has() { command -v "$1" >/dev/null 2>&1 }

# --- macOS: Homebrew must be on PATH before plugins look for tools ----------
if [[ $OSTYPE == darwin* ]] && [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- oh-my-zsh ---------------------------------------------------------------
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME=bira
zstyle ':omz:update' frequency 13
COMPLETION_WAITING_DOTS="true"

plugins=(
  zsh-autosuggestions
  zsh-completions
  colored-man-pages
  git
)
# Only enable plugins whose tools are installed on this machine
has docker   && plugins+=(docker)
has direnv   && plugins+=(direnv)
has fzf      && plugins+=(fzf)
has autojump && plugins+=(autojump)

set -o vi

fpath+=~/.zfunc

source $ZSH/oh-my-zsh.sh

zstyle ':completion:*' menu select

# --- Editor ------------------------------------------------------------------
if has nvim; then
  export EDITOR=nvim VISUAL=nvim
  alias vim="nvim"
  alias vi="nvim"
else
  export EDITOR=vim VISUAL=vim
fi

alias zshconfig="$EDITOR ~/.zshrc"
alias nvimconfig="$EDITOR ~/.config/nvim/init.lua"
alias src="source ~/.zshrc"

# --- PATH --------------------------------------------------------------------
export PATH="$PATH:$HOME/go/bin:$HOME/.local/bin"

# --- Tools (each only if installed) -----------------------------------------
has mise  && eval "$(mise activate zsh)"
has try   && eval "$(try init)"
has zoxide && eval "$(zoxide init zsh)"

[[ -f $HOME/.config/broot/launcher/bash/br ]] && source $HOME/.config/broot/launcher/bash/br

if [[ $OSTYPE == darwin* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# --- fzf ---------------------------------------------------------------------
if has fd; then
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --color=always'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --color=always'
fi
export FZF_DEFAULT_OPTS="--ansi"

# --- Aliases & functions -----------------------------------------------------
alias re=fuck

alias branches="git reflog show --pretty=format:'%gs ~ %gd' --date=relative | grep 'checkout' | awk '!seen[\$6]++{print \$6, \$8, \$9, \$10}' | awk -F' HEAD@' '{printf \"%-42s %s\\n\", \$1, \$2}' | head"
alias branches_names="git reflog show --pretty=format:'%gs ~ %gd' --date=relative | grep 'checkout' | awk '!seen[\$6]++{print \$6}' | head -n 30 | fzf --reverse"
alias gcl='git checkout $(branches_names)'

gwt() {
  local dir
  dir=$(git worktree list | awk '{print $1}' | fzf) || return
  cd "$dir"
}

# --- macOS only --------------------------------------------------------------
if [[ $OSTYPE == darwin* ]]; then
  export BROWSER=open
fi

# Quick search directory, based on latest from autojump
if has autojump; then
  if [[ $OSTYPE == darwin* ]]; then
    AUTOJUMP_DB=~/Library/autojump/autojump.txt
  else
    AUTOJUMP_DB=${XDG_DATA_HOME:-$HOME/.local/share}/autojump/autojump.txt
  fi
  alias jf='cd $(sort -n -k 1 --reverse $AUTOJUMP_DB | cut -f2 | fzf --no-sort -e --height=20% --border)'
fi

# --- Machine-local overrides & secrets (not tracked) -------------------------
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
