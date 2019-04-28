# .bash_profile
#

if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi

PATH=$PATH:$HOME/bin:$HOME/Library/Python/3.7/bin:/usr/local/sbin

export PATH

# Terminal colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

export AWS_CREDENTIAL_FILE=~/.aws/credentials