## What is this?

It's my tmux configuration with the following that works very well with vim.

- prefix: `ctrl + space`.
- `ctrl + [h | j | k | l]`: switch between panes left/right/up/down (just like vim)
- `alt + shift + [h | l]`: switch between windows

## How to install

Install tmux package Manager

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then clone this repo,

```sh
git clone https://github.com/caesar003/tmux-config.git ~/.config/tmux
```

Finally, fire tmux do prefix + I
