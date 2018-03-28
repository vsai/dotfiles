# Colors from http://wiki.archlinux.org/index.php/Color_Bash_Prompt
# misc
NO_COLOR='\e[0m' #disable any colors
# regular colors
BLACK='\e[0;30m'
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
MAGENTA='\e[0;35m'
CYAN='\e[0;36m'
WHITE='\e[0;37m'
# emphasized (bolded) colors
EBLACK='\e[1;30m'
ERED='\e[1;31m'
EGREEN='\e[1;32m'
EYELLOW='\e[1;33m'
EBLUE='\e[1;34m'
EMAGENTA='\e[1;35m'
ECYAN='\e[1;36m'
EWHITE='\e[1;37m'
# underlined colors
UBLACK='\e[4;30m'
URED='\e[4;31m'
UGREEN='\e[4;32m'
UYELLOW='\e[4;33m'
UBLUE='\e[4;34m'
UMAGENTA='\e[4;35m'
UCYAN='\e[4;36m'
UWHITE='\e[4;37m'
# background colors
BBLACK='\e[40m'
BRED='\e[41m'
BGREEN='\e[42m'
BYELLOW='\e[43m'
BBLUE='\e[44m'
BMAGENTA='\e[45m'
BCYAN='\e[46m'
BWHITE='\e[47m'

force_color_prompt=yes

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\[$RED\]vsai \[$YELLOW\]\W\[$CYAN\]\$(parse_git_branch) \[$YELLOW\]\$ \[$GREEN"

#make directory colors ligher
export LSCOLORS='Exfxcxdxbxegedabagacad'

export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"
export PATH="/usr/local/sbin:/usr/sbin:/sbin:$PATH"
export PATH="/usr/X11/bin:/usr/local/git/bin:/usr/texbin:$PATH"

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

alias cunix="ssh vhd@unix.andrew.cmu.edu"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export PATH=$PATH:/Users/vishalsai/bin

export PATH=$PATH:~/bin

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# MacPorts Installer addition on 2015-02-18_at_14:23:42: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# add git autocompletion to command line
test -f ~/.git-completion.bash && . $_

#export PATH=$PATH:/Users/vishalsaidaswani/buildingscraper/node_modules/phantomjs/lib/phantom/bin
#export PATH=$PATH:/Users/vishalsaidaswani/buildingscraper/node_modules/casperjs/bin

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vishalsaidaswani/Documents/google-cloud-sdk/path.bash.inc' ]; then source '/Users/vishalsaidaswani/Documents/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/vishalsaidaswani/Documents/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/vishalsaidaswani/Documents/google-cloud-sdk/completion.bash.inc'; fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
