#!/bin/bash

# Configuration Directories and Paths
CONFIG_DIR="$HOME/.config/editorconfig"
THEME_CONF="$CONFIG_DIR/theme.conf"

# Paths to individual theme files
NVIM_THEME="$CONFIG_DIR/nvim-theme.lua"
KITTY_THEME="$CONFIG_DIR/kitty-theme.conf"

# Paths to template files
NVIM_DARK_TEMPLATE="$CONFIG_DIR/templates/nvim-dark"
NVIM_LIGHT_TEMPLATE="$CONFIG_DIR/templates/nvim-light"
KITTY_DARK_TEMPLATE="$CONFIG_DIR/templates/kitty-dark"
KITTY_LIGHT_TEMPLATE="$CONFIG_DIR/templates/kitty-light"

# Function to set the dark theme
set_dark_theme() {
	# Copy the dark templates to the actual theme files
	cp "$NVIM_DARK_TEMPLATE" "$NVIM_THEME"
	cp "$KITTY_DARK_TEMPLATE" "$KITTY_THEME"

	# Update theme.conf to indicate dark theme
	echo "current_theme=dark" >"$THEME_CONF"

	echo "Switched to dark theme."
}

# Function to set the light theme
set_light_theme() {
	# Copy the light templates to the actual theme files
	cp "$NVIM_LIGHT_TEMPLATE" "$NVIM_THEME"
	cp "$KITTY_LIGHT_TEMPLATE" "$KITTY_THEME"

	# Update theme.conf to indicate light theme
	echo "current_theme=light" >"$THEME_CONF"

	echo "Switched to light theme."
}

# Main Logic: Check current theme and toggle
if [ -f "$THEME_CONF" ]; then
	source "$THEME_CONF"
else
	# Default to dark theme if theme.conf does not exist
	current_theme="dark"
fi

# Toggle the theme based on the current setting
if [ "$current_theme" = "dark" ]; then
	set_light_theme
else
	set_dark_theme
fi
