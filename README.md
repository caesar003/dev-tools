# dotfiles

This repository contains my personal configuration files and scripts for system setup, development environments, and terminal workflows. The structure is organized to keep everything modular, allowing for easy management and scalability.

## Repository Overview

### 1. **/bin**
This directory holds custom utility scripts that automate tasks related to Tmux, Kitty, and general development workflows.

- **dev-session.sh**: Save and restore Kitty sessions.
- **init-config.sh**: Start a customized Tmux session for development.
- **init-tmux.sh**: Initialize Tmux with specific windows for Git and development work.
- **todo.sh**: A simple CLI-based TODO manager.
- **toggle-kitty.sh**: Toggle Kitty terminal window between active and minimized.
- **toggle-theme.sh**: Toggle between light and dark themes for Kitty and Neovim.

### 2. **/config**
Contains the configuration files for core tools such as Kitty, Neovim, Tmux, and Vim. Each tool’s configuration is organized into its own directory for better modularity.

#### a. **/config/kitty**
Configuration files for Kitty terminal.

- **kitty.conf**: Main configuration file for Kitty.
- **neighboring_window.py** & **pass_keys.py**: Custom scripts to manage Kitty window behavior.
- **theme.conf**: Stores the current theme setting (dark or light).
- **themes/**: A collection of pre-configured themes for Kitty (e.g., 1984_Dark, AdventureTime).
- **Templates**: Templates for quickly toggling between dark and light themes.

#### b. **/config/nvim**
Configuration for Neovim, organized for easy extension.

- **init.lua**: Main Neovim configuration file, written in Lua.
- **colors/**: Stores custom color schemes (e.g., `monochrome.vim`).
- **lua/**: Contains custom Lua scripts for Neovim, including:
    - **config/**: Core Neovim settings such as keymaps, options, and plugin configuration.
    - **plugins/**: Plugin-specific configurations (e.g., `auto-pairs.lua`).
- **snippets/**: Stores code snippets for various languages (e.g., `php.json`).
- **Templates**: Similar to Kitty, dark and light theme templates for Neovim.
- **lazy-lock.json**: Stores the lock file for the Neovim plugin manager `lazy.nvim`.

#### c. **/config/tmux**
Configuration for Tmux, along with plugins for added functionality.

- **tmux.conf**: Tmux configuration file.
- **plugins/**: Tmux plugin manager with essential plugins like `tmux-resurrect` (session restoration), `tmux-sensible`, and `minimal-tmux-status`.

#### d. **/config/vim**
For legacy Vim users, this directory includes a basic `init.vim` configuration file to ensure Vim remains functional and synced with Neovim settings.

### 3. **/templates**
Contains dark and light theme templates for Kitty and Neovim. These templates are used by `toggle-theme.sh` to switch between themes dynamically.

### 4. **Miscellaneous Files**
- **bashaliases**: Personal Bash aliases for quick command shortcuts.
- **bashenv**: Environment variable settings.
- **bashrc**: The main Bash startup file, loading other scripts and settings.
- **theme.conf**: Stores the current theme configuration (dark or light).

### 5. **setup.sh**
A script to automate the installation and setup of all necessary dependencies (e.g., Kitty, Tmux, Neovim, and custom scripts). It helps in bootstrapping a new system setup quickly.

### 6. **README.md**
This file, providing an overview of the repository.

## Getting Started

1. **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/dotbin.git ~/.dotfiles
    ```

2. **Run the setup script**:
    ```bash
    ~/.dotfiles/setup.sh
    ```
    This will install dependencies like Kitty, Tmux, Neovim, and other necessary tools, as well as set up the configurations.

3. **Make custom scripts executable**:
    ```bash
    chmod +x ~/.dotfiles/bin/*.sh
    ```

4. **Add the `bin` folder to your PATH**:
    Add the following line to your `~/.bashrc` or `~/.zshrc`:
    ```bash
    export PATH="$HOME/.dotfiles/bin:$PATH"
    ```

## Tools

### 1. **Kitty**
Kitty is a fast, feature-rich, and highly customizable terminal. My Kitty configuration includes theme management, custom scripts, and window management.

- **Theme Management**: Switch between dark and light themes using `toggle-theme.sh`.
- **Key Configurations**: Use `kitty.conf` to define window splitting, font, and behavior settings.

### 2. **Neovim**
Neovim is my editor of choice, highly customized with Lua scripts and plugins.

- **Plugins**: Managed by `lazy.nvim`, with essential plugins for development (auto-pairs, buffer management, and more).
- **Themes**: Dynamic dark/light theme switching using `toggle-theme.sh`.
- **Key Bindings**: Found in `keymaps.lua`, designed for productivity and ease of use.

### 3. **Tmux**
Tmux is a terminal multiplexer, allowing multiple terminal sessions to be managed simultaneously.

- **Custom Sessions**: Use `init-tmux.sh` to start a pre-configured session with windows for code and version control.
- **Plugins**: Tmux plugins include session management (`tmux-resurrect`), basic settings (`tmux-sensible`), and a minimal status bar.

## Custom Scripts

The `/bin` folder contains scripts that automate various tasks, including:
- **Session Management**: Save and restore terminal sessions.
- **Theme Toggling**: Dynamically switch between dark and light themes for Kitty and Neovim.
- **TODO Management**: Simple CLI task manager for keeping track of tasks from the terminal.

## License

This repository is licensed under the MIT License.
