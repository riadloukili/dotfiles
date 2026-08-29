#!/bin/zsh

BASE_SESSION="default"
CLIENT_SESSION="${BASE_SESSION}-$$"

# If already in tmux, just start a shell
if [[ -n "$TMUX" ]]; then
  exec zsh
fi

if ! tmux has-session -t "$BASE_SESSION" 2>/dev/null; then
  # First terminal: create base session and immediately attach via grouped session
  tmux new-session -d -s "$BASE_SESSION" -c "$(pwd)"
  exec tmux new-session -t "$BASE_SESSION" -s "$CLIENT_SESSION" \; \
    attach-session -t "$CLIENT_SESSION" \; \
    set-option -t "$CLIENT_SESSION" destroy-unattached on
else
  # Additional terminals: create new window in base, then grouped session
  WINDOW_ID=$(tmux new-window -d -t "${BASE_SESSION}:" -c "$(pwd)" -P -F '#{window_id}')
  exec tmux new-session -d -t "$BASE_SESSION" -s "$CLIENT_SESSION" \; \
    select-window -t "$CLIENT_SESSION:$WINDOW_ID" \; \
    attach-session -t "$CLIENT_SESSION" \; \
    set-option -t "$CLIENT_SESSION" destroy-unattached on
fi
