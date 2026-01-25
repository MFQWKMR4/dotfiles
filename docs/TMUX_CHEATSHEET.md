# tmux Cheatsheet (basic)

Prefix key: `Ctrl-b`

## Sessions

- Start a session -> `tmux` (create a new tmux workspace in this terminal)
- Detach -> `Ctrl-b d` (leave tmux running in the background)
- List sessions -> `Ctrl-b s` (show running tmux sessions)
- Attach -> `tmux a` (re-open the last session in the current terminal)

## Panes

- Split left/right -> `Ctrl-b %`
- Split up/down -> `Ctrl-b "`
- Move between panes -> `Ctrl-b` + arrows
- Close pane -> `exit` (or `Ctrl-d`)

## Windows (tabs)

- New window -> `Ctrl-b c`
- Next/Prev window -> `Ctrl-b n` / `Ctrl-b p`
- List windows -> `Ctrl-b w`
