if status is-interactive
  # Commands to run in interactive sessions can go here
  abbr -a "got" "git"
  abbr -a "gut" "git"
  abbr -a "nuke" "rm -rf"
  abbr -a "n" "nvim ."
  abbr -a "l" "ls -l"
  abbr -a "ll" "ls -la"
  abbr -a "hx" "helix"
end

set -gx PATH "$HOME/.local/bin" $PATH
set -gx PATH "$HOME/go/bin" $PATH

zoxide init fish | source

set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
set -gx EDITOR helix

# THEME PURE #
set fish_function_path /home/naethiel/.config/fish/functions/theme-pure/functions/ $fish_function_path
source /home/naethiel/.config/fish/functions/theme-pure/conf.d/pure.fish
