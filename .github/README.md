# dotfiles
Useful scipts and conf files
- nvim
- tmux
- zsh
- i3
- dunst
- i3-lock
- alacritty
- polybar
- rofi
- polybar
- picom
- flameshot 
- other automation scripts...

## Requirements

Beyond the programs themselves:

- **nvim** — `git`, a C compiler, and the [`tree-sitter` CLI] on `$PATH`.
  The CLI is new: nvim-treesitter's `main` branch shells out to it to build
  parsers, where the old `master` branch compiled them itself.
- **zsh** — oh-my-zsh at `$ZDOTDIR/ohmyzsh`, plus `zsh-syntax-highlighting`
  and `zsh-autosuggestions` under its `custom/plugins`.
- **tmux** — [tpm] at `~/.config/tmux/plugins/tpm`, then `prefix + I`.
- **alacritty** — JetBrains Mono Nerd Font.

`$ZDOTDIR` is set by `.zshenv`, so that file has to live at `~/.zshenv`.

[`tree-sitter` CLI]: https://github.com/tree-sitter/tree-sitter/releases
[tpm]: https://github.com/tmux-plugins/tpm
