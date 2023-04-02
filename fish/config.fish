if status is-interactive
  # Commands to run in interactive sessions can go here
  abbr -a "got" "git"
  abbr -a "gut" "git"
  abbr -a "lv" "lvim"
  abbr -a "n" "nvim"
  abbr -a "nuke" "rm -rf"
  abbr -a "l" "ls -l"
  abbr -a "ll" "ls -la"
end

set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

set -gx PATH "$HOME/.local/bin" $PATH
set -gx PATH "$HOME/go/bin" $PATH

set -g hydro_symbol_prompt "❯"
set -g hydro_color_pwd "brgreen"
set -g hydro_color_prompt "brgreen"
set -g hydro_color_git "brblack"
