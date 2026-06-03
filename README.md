# dotfiles

Personal macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/).

This repository is the source of truth for user configuration. It does not try to
fully provision the machine: command-line tools and fonts are installed directly
from official release binaries and documented in `~/.codex/TOOLS.md`.

## Managed files

| Source | Target | Purpose |
| --- | --- | --- |
| `home/dot_zshrc` | `~/.zshrc` | zsh PATH, Starship init, nvm, SSH compatibility wrapper |
| `home/dot_gitconfig` | `~/.gitconfig` | Git identity, Hunk pager, diff and merge settings |
| `home/dot_tmux.conf` | `~/.tmux.conf` | tmux ergonomics, clipboard, Ghostty RGB, Catppuccin status bar |
| `home/dot_config/ghostty/config` | `~/.config/ghostty/config` | Ghostty Catppuccin theme, JetBrainsMono Nerd Font, Option-as-Alt |
| `home/dot_config/starship.toml` | `~/.config/starship.toml` | compact prompt: cwd, git branch, prompt character |
| `home/dot_config/nvim/init.lua` | `~/.config/nvim/init.lua` | Neovim config, plugins, LSP, formatting, linting |
| `home/dot_codex/AGENTS.md` | `~/.codex/AGENTS.md` | Codex user preferences |
| `home/dot_codex/TOOLS.md` | `~/.codex/TOOLS.md` | local CLI inventory and update notes |
| `home/dot_codex/private_config.toml` | `~/.codex/config.toml` | Codex approval/sandbox defaults and trusted workspace |
| `home/dot_ssh/private_config` | `~/.ssh/config` | SSH host config |

## Manual installs

Installed binaries live in `~/bin`. Prefer direct official release binaries over
Homebrew. When adding or updating a CLI, update `home/dot_codex/TOOLS.md`.

Current notable manual installs include:

- Ghostty app
- JetBrains Mono and JetBrainsMono Nerd Font in `~/Library/Fonts`
- Hunk in `~/bin/hunk`
- Neovim in `~/bin/nvim-macos-arm64` with `~/bin/nvim` symlink

Neovim plugins and Mason-managed language tools live under Neovim data
directories and are bootstrapped by `~/.config/nvim/init.lua`.

## Apply

```sh
chezmoi apply
```

For a focused apply:

```sh
chezmoi apply ~/.zshrc ~/.tmux.conf ~/.config/ghostty/config
```

## Review

```sh
chezmoi diff
git status --short
```
