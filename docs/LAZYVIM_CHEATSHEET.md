# LazyVim Cheatsheet (VSCode -> Neovim)

Default leader key: `Space`

## VSCode-like actions

- `Ctrl+P` (Quick Open) -> `Space Space` or `:Telescope find_files`
- `Ctrl+F` (Find in file) -> `/` (then type) or `Space /`
- `Shift+F` (Find in workspace) -> `Space s g` or `:Telescope live_grep`
- New file -> `:e path/to/new_file` (creates on save), or `Space f n`
- New directory -> `:!mkdir -p path/to/dir` (then open file)

## File tree (Explorer)

- Toggle tree -> `Space e`
- Focus tree -> `Space E`

## Basics (LazyVim)

- Command palette -> `Space s p`
- Recent files -> `Space f r`
- Buffers list -> `Space ,`
- Next/Prev buffer -> `] b` / `[ b`
- Close buffer -> `Space b d`
- Tabs (if you use them): `:tabnew`, `gt` / `gT`
- Save file -> `:w`
- Quit -> `:q`

## Buffers vs Tabs (short idea)

- Buffer = opened file in memory (most navigation is buffer-based)
- Tab = a layout of windows, not a file itself

## LSP / Diagnostics

- Go to definition -> `g d`
- References -> `g r`
- Hover -> `K`
- Code action -> `Space c a`
- Rename symbol -> `Space c r`
- Diagnostics list -> `Space x x`

## Search

- Search in file -> `/` (repeat: `n` / `N`)
- Search files -> `Space f f`
- Search word under cursor -> `Space s w`

## Tips

- If a key doesn't work, open `:Lazy` and install/update plugins.
- Run `:checkhealth` to troubleshoot.

