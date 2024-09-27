# dotbin

A collection of personal shell scripts designed to automate and simplify common development workflows, system setup, and customization. These scripts cover tasks like managing Tmux sessions, toggling terminal themes, handling Kitty window management, and more.

## Scripts Overview

### 1. **dev-session.sh**

Manages Kitty terminal sessions, allowing you to save and restore the state of open tabs and their directories.

-   **Save session**: `./dev-session.sh save [session_name]`
-   **Restore session**: `./dev-session.sh restore [session_name]`
-   **Destroy all but one tab**: `./dev-session.sh destroy`
-   **List sessions**: `./dev-session.sh list`

### 2. **init-config.sh**

Initializes a Tmux session tailored for your development setup.

-   **Usage**: `./init-config.sh [session_name]`
-   Creates a session with custom windows for development tools.

### 3. **init-tmux.sh**

Creates a Tmux session with windows specifically designed for coding and Git/npm management.

-   **Usage**: `./init-tmux.sh [session_name]`
-   Adds windows for code editing and version control.

### 4. **todo.sh**

A simple CLI-based TODO task manager, allowing you to add, list, and mark tasks as completed.

-   **Add a task**: `./todo.sh add`
-   **List pending tasks**: `./todo.sh pending`
-   **Mark task as done**: `./todo.sh finish <id>`
-   **Get task details**: `./todo.sh get <id>`
-   **Delete a task**: `./todo.sh delete <id>`

### 5. **toggle-kitty.sh**

Toggles the Kitty terminal window between active and minimized states.

-   **Usage**: `./toggle-kitty.sh`
-   Requires `xdotool` to be installed.

### 6. **theme-toggle.sh**

Toggles between light and dark themes for Neovim and Kitty by swapping theme configuration files.

-   **Usage**: `./theme-toggle.sh`
-   Customize your themes by modifying templates in `~/.dev-tools/templates/`.

## Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/dotbin.git
    ```

2. Make the scripts executable and move them to a directory in your `$PATH` (e.g., `~/.bin/`):

    ```bash
    chmod +x dotbin/*.sh
    mv dotbin/*.sh ~/.bin/
    ```

3. Ensure that required tools like `xdotool`, `tmux`, and `kitty` are installed.

    For `xdotool` (required by `toggle-kitty.sh`):

    ```bash
    sudo apt install -y xdotool
    ```

## File Structure


dotbin/ 
    ├── dev-session.sh # Manage Kitty terminal sessions 
    ├── init-config.sh # Initialize a Tmux session with development setup 
    ├── init-tmux.sh # Create and manage Tmux windows for dev work 
    ├── todo.sh # Simple task management tool 
    ├── toggle-kitty.sh # Toggle Kitty terminal visibility 
    ├── theme-toggle.sh # Toggle between light and dark themes 
    └── README.md # This README file



## Customization

Each script is designed to be easily customizable:
- Modify theme templates for Neovim and Kitty in the `theme-toggle.sh` script.
- Adjust your workflow setup in `init-config.sh` or `init-tmux.sh` to fit your specific needs.

## License

This repository is licensed under the MIT License.
