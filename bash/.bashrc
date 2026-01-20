# Common shell settings for macOS + Linux

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

if [ -f "$HOME/.bash_aliases" ]; then
  . "$HOME/.bash_aliases"
fi
