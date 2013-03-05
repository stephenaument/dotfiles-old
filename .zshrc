# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="wedisagree"

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
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin/:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin:/home/saument/.rvm/gems/ruby-1.9.2-p290@rails/bin:/home/saument/.rvm/gems/ruby-1.9.2-p290@global/bin:/home/saument/.rvm/rubies/ruby-1.9.2-p290/bin:/home/saument/.rvm/bin:/opt/local/bin:/opt/local/sbin:/usr/local/share/python:/usr/local/pgsql/bin:/usr/local/sbin:/usr/local/mysql/bin:/home/saument/ec2-api-tools-1.3-30349/bin:/Developer/usr/bin

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# export EDITOR='subl -w'
export EDITOR='vim'

alias rspec='rspec --color'

echo "Done loading zsh."
