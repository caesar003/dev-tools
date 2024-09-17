#!/bin/bash


# ~/.bin/dotbin/toggle-kitty.sh

# Fist of all, ensure you have xdotool installed,
# It isn't by default, so you need to install,
# sudo apt install -y xdotool

# Check if Kitty is running
if pgrep -x "kitty" > /dev/null
then
  # Get the ID of the active window
  active_win_id=$(xdotool getactivewindow)

    # Get the ID of the Kitty window, if any
    kitty_win_id=$(xdotool search --class kitty)

    if [ "$kitty_win_id" = "" ]; then
      exit 0
    fi

    # Check if Kitty is the active window
    if [ "$active_win_id" = "$kitty_win_id" ]; then
      # If Kitty is active, minimize it
      xdotool windowminimize "$kitty_win_id"
    else
      # If Kitty is not active, bring it to front
      xdotool windowactivate "$kitty_win_id"
    fi
fi
