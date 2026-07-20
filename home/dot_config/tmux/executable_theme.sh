#!/bin/sh

# Match Ghostty's system-aware Catppuccin theme.
if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
  base='#1e1e2e'
  text='#cdd6f4'
  surface0='#313244'
  surface1='#45475a'
  overlay0='#6c7086'
  subtext0='#a6adc8'
  blue='#89b4fa'
  yellow='#f9e2af'
  red='#f38ba8'
  mauve='#cba6f7'
  green='#a6e3a1'
  sky='#89dceb'
  sapphire='#74c7ec'
else
  base='#eff1f5'
  text='#4c4f69'
  surface0='#ccd0da'
  surface1='#bcc0cc'
  overlay0='#9ca0b0'
  subtext0='#6c6f85'
  blue='#1e66f5'
  yellow='#df8e1d'
  red='#d20f39'
  mauve='#8839ef'
  green='#40a02b'
  sky='#04a5e5'
  sapphire='#209fb5'
fi

tmux set-option -g status-style "bg=$base,fg=$text"
tmux set-option -g message-style "bg=$surface0,fg=$text"
tmux set-option -g message-command-style "bg=$surface0,fg=$text"
tmux set-option -g mode-style "bg=$surface1,fg=$text"

tmux set-option -g pane-border-style "fg=$surface0"
tmux set-option -g pane-active-border-style "fg=$blue"
tmux set-option -g window-style default
tmux set-option -g window-active-style default

tmux set-option -g window-status-format "#[fg=$overlay0,bg=$base] #I:#W#{?window_flags,#{window_flags}, } "
tmux set-option -g window-status-current-format "#[fg=$base,bg=$blue,bold] #I:#W#{?window_flags,#{window_flags}, } "
tmux set-option -g window-status-activity-style "fg=$yellow,bg=$base"
tmux set-option -g window-status-bell-style "fg=$base,bg=$red,bold"

tmux set-option -g status-left "#[fg=$base,bg=$mauve,bold] #S #[default] "
tmux set-option -g status-right "#[fg=$subtext0,bg=$base]#{?client_prefix,#[fg=$base]#[bg=$red] PREFIX ,} #[fg=$base,bg=$green] #{pane_current_command} #[fg=$base,bg=$sky] %Y-%m-%d #[fg=$base,bg=$sapphire] %H:%M "
