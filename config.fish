### FUNDLE
if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end
fundle plugin 'edc/bass'
fundle init

###############
# PATH
###############

# clear path: this is a workaround for tmux setting paths twice
set -e PATH

# reset standard paths
set -x PATH /usr/local/bin /usr/local/sbin /usr/bin /bin /usr/sbin /sbin

if test -d /Library/TeX/texbin
  set -x PATH $PATH /Library/TeX/texbin
end

# user paths
if test -d $HOME/.local/bin
  set -x PATH $HOME/.local/bin $PATH
end

if test -d $HOME/.rbenv
  set -x PATH $HOME/.rbenv/bin $PATH
end

if test -d $HOME/.pyenv
  set -x PATH $HOME/.pyenv/bin $PATH
  status --is-interactive; and source (pyenv init -|psub)
end

# direnv
if test -f ".envrc"
  direnv allow .
end

######
set -x EDITOR /usr/bin/vim

# direnv
eval (direnv hook fish)

# nvm
function nvm
  bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

function load_node
  if test -f ".nvmrc"
    nvm use >/dev/null
  else
    nvm use default >/dev/null
  end
end

if test -d ".nvm"
  load_node
end

function __check_nvmrc --on-variable PWD --description "load per-project node version"
  load_node
end

# rbenv
status --is-interactive; and . (rbenv init -|psub)

#### ALIASES
alias pull='git pull --rebase'
alias push='git push origin (git rev-parse --abbrev-ref HEAD)'
alias forcepush='git push -f origin (git rev-parse --abbrev-ref HEAD)'

alias fconf='vim ~/.config/fish/config.fish'

#### FUNCTIONS
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
