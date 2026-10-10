#!/usr/bin/env bash
# Link dotfiles with stow and fetch the git-based dependencies (oh-my-zsh, plugins, TPM).
# Safe to re-run.
set -euo pipefail

cd "$(dirname "$0")"

packages=(tmux zsh)
if [[ $OSTYPE == darwin* ]]; then
  packages+=(wezterm karabiner)
fi

clone() { # clone <repo> <dir>, skipped if already present
  [[ -d $2 ]] || git clone --depth 1 "https://github.com/$1" "$2"
}

missing=()
for cmd in git stow zsh tmux fzf; do
  command -v "$cmd" >/dev/null || missing+=("$cmd")
done
if (( ${#missing[@]} )); then
  echo "Missing required tools: ${missing[*]}" >&2
  exit 1
fi

# oh-my-zsh + custom plugins
ZSH_DIR=$HOME/.oh-my-zsh
clone ohmyzsh/ohmyzsh "$ZSH_DIR"
clone zsh-users/zsh-autosuggestions "$ZSH_DIR/custom/plugins/zsh-autosuggestions"
clone zsh-users/zsh-completions "$ZSH_DIR/custom/plugins/zsh-completions"

# tmux plugin manager (then press prefix + I inside tmux)
clone tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

# Move pre-existing real files out of stow's way
for f in .zshrc .zshenv; do
  if [[ -f $HOME/$f && ! -L $HOME/$f ]]; then
    mv "$HOME/$f" "$HOME/$f.pre-dotfiles"
    echo "Moved ~/$f to ~/$f.pre-dotfiles"
  fi
done

stow --restow "${packages[@]}"
echo "Linked: ${packages[*]}"

for cmd in nvim fd zoxide direnv autojump mise; do
  command -v "$cmd" >/dev/null || echo "Optional, not installed: $cmd"
done
