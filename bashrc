# .bashrc
#
# Personal environment variables and startup programs go in .bash_profile.
# User specific aliases and fuctions go in .bashrc. System wide environment
# variables and startup programs are in /etc/profile. System wide aliases
# and functions are in /etc/bashrc.

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

#-------------------------------------------------------------
# Environment
#-------------------------------------------------------------
# Set umask
umask 002

# Enable builtin options
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob # Necessary for programmable completion.

# Prompt
export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h: \[\e[33m\]\w\[\e[0m\]\n\$ '
#export PS1='\h: \[\e[33m\]\w\[\e[0m\]\n\$ '

export EDITOR=vim
export HISTFILESIZE=1000
export HISTCONTROL=ignoredups
export PAGER=less
export SVN_EDITOR=vim
export VISUAL=vim

# Protection
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

#-------------------------------------------------------------
# The 'ls' family
#-------------------------------------------------------------
# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls -hF'
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.

# The ubiquitous 'll': directories first, with alphanumeric sorting:
alias ll="ls -lFv"
alias lm='ll | more'       #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls'

#-------------------------------------------------------------
# Tailored 'less'
#-------------------------------------------------------------
alias more='less'
export PAGER='less'
export LESSCHARSET='utf-8'
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

# less man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#-------------------------------------------------------------
# Environment specific shortcuts
#-------------------------------------------------------------
alias ..='cd ..'
alias doc='cd ~/Documents'
alias dl='cd ~/Downloads'
alias svi='sudo vim'

#-------------------------------------------------------------
# System diagnostics
#-------------------------------------------------------------
# Get memory information
alias meminfo='free -mlt'   

# Get cpu info
alias cpuinfo='lscpu'

# Get the top 10 process consuming memory
alias psmem='ps auxf | sort -nr -k 4 | head -10'

# Process based on user
alias psusr='ps -f -u'

# Process based on command
alias pscmd='ps -f -C'

# Disk usage total
alias dut='du -ahc --time | sort -nr | less'

# Home usage top 20
alias duh='du -ah ~ | sort -rh | head -20'

# Show all open ports
alias ports='sudo netstat -uplant'

# Show unlinked open files
alias lsofdel='lsof +L1'

# Output mounted file systems as columns
alias mountt='mount | column -t'

#-------------------------------------------------------------
# System Activity Report (sar)
#-------------------------------------------------------------
# CPU usage of all CPUs
alias sar_cpu='sar -u 1 10'

# CPU usage of individual CPU or cores
alias sar_cpu_cores='sar -P ALL 1 1'

# Memory free and used
alias sar_mem='sar -r 1 10'

# Swap space used
alias sar_swap='sar -S 1 10'

# Overall I/O activities
alias sar_io='sar -b 1 10'

# Reports run queue and load average
alias sar_load='sar -q 1 10'

# Network device statistics
alias sar_net='sar -n DEV 3 10'

# Network device error statistics
alias sar_net_error='sar -n EDEV 3 10'

#-------------------------------------------------------------
# Useful aliases
#-------------------------------------------------------------
# Edit and source .bashrc
alias virc='vi ~/.bashrc; . ~/.bashrc'

# Progress bar on file copy
alias cpr="rsync --progress -ravz" 

# Pass useful options to wget
alias wgetall='wget -rpkc'

# Generate random password
alias pwgen='pwgen -N 1 -sy 32'

#-------------------------------------------------------------
# Functions
#-------------------------------------------------------------
# Find files and directories newer than specified date 
findnewer() {
  NEWER='/tmp/find-newer'
  if [ $# -ne 2 ]; then
    echo "Usage: findnewer DIR DATE (e.g. 2012-12-05)"
  else
    touch --date $2 "$NEWER"
    find $1 -newer "$NEWER"
    \rm "$NEWER"
  fi
}

# Generate a file using dd
filegen() {
  if [ $# -ne 3 ]; then
    echo "Usage: filegen FILE BS COUNT"
  else
    dd if=/dev/zero of=$1 bs=$2 count=$3
  fi
}

# Burn files to optical media
mkmedia() {
  if [ $# -ne 1 ]; then
    echo "Usage: mkmedia SOURCE"
  else
    growisofs -Z /dev/cdrom -R -J $1
  fi
}

# Puppet apply
puppetapply() {
  puppet_module_path='~/Projects/puppet/modules'
  command -v puppet &> /dev/null
  if [ $? -eq 1 ]; then
    echo "Notice: Puppet is not installed"
  elif [ $# -ne 1 ]; then
    echo "Usage: puppetapply MODULE"
  else
   puppet apply --modulepath=$puppet_module_path -e "include $1"
  fi
}

# Copy via tar pipe
tarcp() {
  if [ $# -ne 2 ]; then
    echo "Usage: tarcp SOURCE DEST"
  else
    SRCDIR="$1"
    DSTDIR="$2"
    tar cvpf - $SRCDIR | "( cd $DSTDIR; tar xvpf - )"
  fi
}

# Copy via tar pipe over SSH
tarscp() {
  if [ $# -ne 3 ]; then
    echo "Usage: tarscp HOSTNAME SOURCE DEST"
  else
    HOST=$1
    SRCDIR=$2
    DSTDIR=$3
    tar cvpf - $SRCDIR | ssh $HOST "( cd $DSTDIR; tar xvpf - )"
  fi
}

# Creates an archive (*.tar) from given directory
mktar() { tar cvf "${1%%/}.tar" "${1%%/}/"; }

# Create a ZIP archive of a file or directory
mkzip() { zip -r "${1%%/}.zip" "$1"; }

# Generate a random password
#pwgen() { openssl rand -base64 32; }

# SSH
rpi() { ssh rpi@0.0.0.0; }
ssh-add-keys() { for i in $(find /Volumes/Private/Keys/ -name "*pem*"); do ssh-add -k $i; done }

# What's my IP
whatsmyip() { dig TXT +short o-o.myaddr.l.google.com @ns1.google.com; }

# macOS maintenance
maintenance() {
  sudo periodic daily weekly monthly
  sudo atsutil databases -remove
  sudo rm -rf ~/Library/{Caches,Logs}/*
  defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock
  sudo killall -HUP mDNSResponder
}

# Update Homebrew
brewski() {
  brew update
  brew upgrade
  brew cask outdated | cut -f 1 | xargs brew cask reinstall
  brew doctor
  brew missing
  brew cleanup -s
}
