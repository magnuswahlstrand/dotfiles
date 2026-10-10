# Dotfiles Setup

Each top-level folder is a [stow](https://www.gnu.org/software/stow/) package, laid out as it should appear in `~`.

```sh
git clone git@github.com:magnuswahlstrand/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` links `tmux` and `zsh` everywhere, plus `wezterm` and `karabiner` on macOS.
It also clones oh-my-zsh, its custom plugins and TPM (then press `prefix + I` in tmux).

Required: `git stow zsh tmux fzf`. Optional: `nvim fd zoxide direnv autojump mise`.
On Debian/Ubuntu `fd` is called `fdfind`: `ln -s $(which fdfind) ~/.local/bin/fd`.

Machine-specific settings and secrets go in `~/.zshrc.local`, which is not tracked.
