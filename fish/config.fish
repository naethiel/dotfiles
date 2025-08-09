if status is-interactive
    # Commands to run in interactive sessions can go here
    abbr -a got git
    abbr -a gut git
    abbr -a nuke "rm -rf"
    abbr -a n nvim
    abbr -a l "ls -l"
    abbr -a ll "ls -la"
    abbr -a greset "git reset --soft HEAD^ && git reset -- ."
    abbr -a .... "../.."
    abbr -a ...... "../../.."
    abbr -a ........ "../../../.."
    abbr -a lg lazygit
    abbr -a g git
end

set -gx PATH "$HOME/.local/bin" $PATH
set -gx PATH "$HOME/go/bin" $PATH
set -gx PATH "$HOME/.cargo/bin" $PATH
set -gx PATH "$HOME/bin" $PATH


set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
set -gx EDITOR nano

set -gx MOZ_ENABLE_WAYLAND 1

eval "$(/opt/homebrew/bin/brew shellenv)"

