# Personal dotfiles

## Required software

- git
- [neovim](https://neovim.io/)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fzf](https://github.com/junegunn/fzf)
- [kitty](https://sw.kovidgoyal.net/kitty/) or [iTerm2](https://iterm2.com/index.html)
- [volta](https://volta.sh/) for node version management
- node, through `volta`
  ```
  volta install eslint_d@latest prettier@latest yarn@latest
  ```
  (chokidar is required to run eslint and/or prettier in watch mode in CLI, which is useful with helix)
- go
- [delta](https://github.com/dandavison/delta)
- [lazyGit](https://github.com/jesseduffield/lazygit)
- [lunarvim](https://www.lunarvim.org/)

## Steps

- Copy/symlink dotfiles to ~
- Install required software through whatever package manager is relevant
- Apply iTerm2 theme if on macOS
