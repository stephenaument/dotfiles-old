# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="step-server"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(rails3 git github)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/$HOME/bin:/usr/local/bin:/usr/local/sbin/:/usr/bin:/bin:/usr/sbin:/sbin:/$HOME/.rvm/gems/ruby-1.9.2-p290@rails/bin:/$HOME/.rvm/gems/ruby-1.9.2-p290@global/bin:/$HOME/.rvm/rubies/ruby-1.9.2-p290/bin:/$HOME/.rvm/bin:/usr/local/share/python:/usr/local/pgsql/bin:/usr/local/mysql/bin

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# export EDITOR='subl -w'
export EDITOR='vim'

alias rspec='rspec --color'
alias s3ls='s3ls --no-vhost'
alias s3put='s3put --no-vhost'
alias s3get='s3get --no-vhost'

echo "Done loading zsh."

# Bind the up and down arrows to auto complete history
# bindkey '^[OA' history-beginning-search-backward
# bindkey '^[OB' history-beginning-search-forward
bindkey '^[OA' up-line-or-search
bindkey '^[OB' down-line-or-search

# Check to see if SSH Agent is already running
agent_pid="$(ps -ef | grep "ssh-agent" | grep -v "grep" | awk '{print($2)}')"
  
# If the agent is not running (pid is zero length string)
if [[ -z "$agent_pid" ]]; then
  # Start up SSH Agent
       
  # this seems to be the proper method as opposed to `exec ssh-agent bash`
  eval "$(ssh-agent)"
                
  # if you have a passphrase on your key file you may or may
  # not want to add it when logging in, so comment this out
  # if asking for the passphrase annoys you
  ssh-add
                                 
# If the agent is running (pid is non zero)
else
  # Connect to the currently running ssh-agent
                                      
  # this doesn't work because for some reason the ppid is 1 both when
  # starting from ~/.profile and when executing as `ssh-agent bash`
  #agent_ppid="$(ps -ef | grep "ssh-agent" | grep -v "grep" | awk '{print($3)}')"
  agent_ppid="$(($agent_pid - 1))"
                                                       
  # and the actual auth socket file name is simply numerically one less than
  # the actual process id, regardless of what `ps -ef` reports as the ppid
  agent_sock="$(find /tmp -path "*ssh*" -type s -iname "agent.$agent_ppid")"
                                                                    
  echo "Agent pid $agent_pid"
  export SSH_AGENT_PID="$agent_pid"
                                                                             
  echo "Agent sock $agent_sock"
  export SSH_AUTH_SOCK="$agent_sock"
fi
