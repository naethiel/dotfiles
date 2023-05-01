if status is-interactive
  # Commands to run in interactive sessions can go here
  abbr -a "got" "git"
  abbr -a "gut" "git"
  abbr -a "nuke" "rm -rf"
  abbr -a "n" "nvim ."
  abbr -a "l" "ls -l"
  abbr -a "ll" "ls -la"
end

set -gx PATH "$HOME/.local/bin" $PATH
set -gx PATH "$HOME/go/bin" $PATH

if type -q zoxide
  zoxide init fish | source
end

set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
