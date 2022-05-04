########
# CONFIG
########
set -x EDITOR /usr/bin/vim

######
# PATH
######

# clear path: this is a workaround for tmux setting paths twice
set -e PATH

# reset standard paths
set -x PATH /usr/local/bin /usr/local/sbin /usr/bin /bin /usr/sbin /sbin

if test -d /Library/TeX/texbin
  set -x PATH $PATH /Library/TeX/texbin
end

if test -d /snap/bin
  set -x PATH $PATH /snap/bin
end

# user paths
if test -d $HOME/.local/bin
  set -x PATH $HOME/.local/bin $PATH
end

if test -d $HOME/scripts
  set -x PATH $HOME/scripts $PATH
end

###########
# Dev tools
###########

## DIRENV
if test -f ".envrc"
  direnv allow .
end

## RUBY
if test -d $HOME/.rbenv
  set -x PATH $HOME/.rbenv/bin $PATH
end

## PYTHON
if test -d $HOME/.pyenv
  set -x PATH $HOME/.pyenv/bin $PATH
end

## RUST
if test -d $HOME/.cargo
  set -x PATH $HOME/.cargo/bin $PATH
end

## NODE
function nvm
  bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

function load_node
  if test -f ".nvmrc"
    nvm use >/dev/null
  end
end

function __check_nvmrc --on-variable PWD --description "load per-project node version"
  load_node
end

#########
# ALIASES
#########
alias pull='git pull --rebase'
alias push='git push origin (git rev-parse --abbrev-ref HEAD)'
alias forcepush='git push -f origin (git rev-parse --abbrev-ref HEAD)'
alias gamend='git commit --amend'

alias fconf='vim ~/.config/fish/config.fish'

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

alias idris='rlwrap idris2'
alias iddoc='open (idris2 --libdir)/docs/index.html'

alias ports='sudo lsof -i -P -n | grep LISTEN'

##################
# HELPER FUNCTIONS
##################
function to_gem
  cd (bundle show $argv[1])
end

function s!!
  commandline -i 'sudo '
  commandline -i $history[1]
  commandline -f execute
end

function fuck -d 'Correct your previous console command'
  set -l exit_code $status
  set -l eval_script (mktemp 2>/dev/null ; or mktemp -t 'thefuck')
  set -l fucked_up_commandd $history[1]
  thefuck $fucked_up_commandd > $eval_script
  . $eval_script
  rm $eval_script
  if test $exit_code -ne 0
    history --delete $fucked_up_commandd
  end
end

##################
# Initialize tools
##################
eval (direnv hook fish)

if test -d $HOME/.rbenv
  status --is-interactive; and . (rbenv init -|psub)
end

if test -d $HOME/.pyenv
  pyenv init - | source
end

if test -d $HOME/.nvm
  #load_node
end

if test -d $HOME/.sdkman
  sdk version >/dev/null
end
