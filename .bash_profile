export PATH=/opt/local/bin:$PATH:$EC2_HOME/bin:/Developer/usr/bin
export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:$PATH"
#export PATH=/usr/local/pgsql/bin:$PATH
#export PATH=/usr/local/share/python:$PATH
#export JAVA_HOME=/Library/Java/Home
# export TBB_INSTALL_DIR=/usr/local/tbb22_20090809oss/ia32/cc4.0.1_os10.4.9
# export TBB_INCLUDE_DIR=/usr/local/tbb22_20090809oss/include
# export TBB_LIB_DIR=/usr/local/tbb22_20090809oss/ia32/cc4.0.1_os10.4.9/lib
# export TBB_LIBRARY=/usr/local/tbb22_20090809oss/ia32/cc4.0.1_os10.4.9/lib
# export EDITOR='mate -w'
export EDITOR='subl -w'
#export RUBYOPT=rubygems
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
alias rspec='rspec --color --format doc'
source ~/.git-completion.bash
#source ~/.preexec.bash

#function dropdb {
#  ~/Scripts/dropappdatabases.rb $@
#}

###
## Your previous /Users/saument/.bash_profile file was backed up as /Users/saument/.bash_profile.macports-saved_2011-06-09_at_21:56:23
###

## MacPorts Installer addition on 2011-06-09_at_21:56:23: adding an appropriate PATH variable for use with MacPorts.
#export PATH=/opt/local/bin:/opt/local/sbin:$PATH
## Finished adapting your PATH environment variable for use with MacPorts.

##Setting up the VirtualENV
# export WORKON_HOME=$HOME/.virtualenvs
# export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python2.7
# export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
# export PIP_VIRUTUALENV_BASE=$WORKON_HOME
# export PIP_RESPECT_VIRTUALENV=true

# if [[ -r /usr/local/share/python/virtualenvwrapper.sh ]]; then
#   source /usr/local/share/python/virtualenvwrapper.sh
# else
#   echo "WARNING: Can't find virtualenvwrapper.sh"
# fi

