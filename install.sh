#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
}
os_name="$(uname -s)"
case "$os_name" in
Darwin) git_local="$DOTFILES_DIR/git/.gitconfig-personal" ;;
Linux) git_local="$DOTFILES_DIR/git/.gitconfig-personal" ;;
*) git_local="$DOTFILES_DIR/git/.gitconfig-personal" ;;
esac

link "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
link "$DOTFILES_DIR/bash/.bash_profile" "$HOME/.bash_profile"
link "$DOTFILES_DIR/bash/.bash_aliases" "$HOME/.bash_aliases"
link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link "$DOTFILES_DIR/git/.gitconfig-work" "$HOME/.gitconfig-work"
link "$DOTFILES_DIR/git/.gitconfig-personal" "$HOME/.gitconfig-personal"
link "$git_local" "$HOME/.gitconfig-local"
link "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
link "$DOTFILES_DIR/bin/git-profile" "$HOME/.local/bin/git-profile"
link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

echo "Linked dotfiles from $DOTFILES_DIR"
