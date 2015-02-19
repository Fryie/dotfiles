###############
# PATH
###############

# reset
set -e PATH
# standard paths
# SET STANDARD PATHS HERE

# SET ADDITIONAL PATHS HERE

###############
# OTHER CONFIG
###############

# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish

# Theme
set fish_theme bira

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-fish/plugins/*)
# Custom plugins may be added to ~/.oh-my-fish/custom/plugins/
set fish_plugins git rails emoji-clock gem localhost tmux vi-mode rbenv

# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish

set PATH $HOME/scripts $PATH
set PATH $HOME/.rbenv/bin $PATH
bash "rbenv init -"

set -x EDITOR /usr/bin/vim

test -s /home/piru/.nvm-fish/nvm.fish; and source /home/piru/.nvm-fish/nvm.fish

# direnv
eval (direnv hook fish)
