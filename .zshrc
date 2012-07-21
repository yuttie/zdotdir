################################################################
#### Environment Variable
if [ -e ~/.zshenv ] ; then
    source ~/.zshenv
fi

# Command search path
path=(~/bin
      ~/.gem/ruby/1.8
      ~/.gem/ruby/1.9.1
      ~/.cabal/bin
      $path)

# Where to look for autoloaded function definitions
fpath=($fpath ~/.zfunc)

# Man path
manpath=($manpath)

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# default prompt
PROMPT=$'%B%(!.%F{red}.%F{green})%n@%m%f %F{magenta}%$((COLUMNS - (${#USER} + 1 + ${#HOST} + 1)))<...<%~%f
%F{blue}%#%f%b '
# prompt for right side of screen
zstyle ':vcs_info:*' formats       '%F{yellow}(%f%s%F{yellow})-[%F{green}%b%F{yellow}]%f%u%c'
zstyle ':vcs_info:*' actionformats '%F{yellow}(%f%s%F{yellow})-[%F{green}%b%F{yellow}|%F{red}%a%F{yellow}]%f%u%c'
function precmd() { LANG=en_US.UTF-8 vcs_info }
RPROMPT='${vcs_info_msg_0_}'

# History
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# other variables
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# 256-colorization by correcting TERM variable
if [ "$TERM" = "xterm" ]; then
    TERM="xterm-256color"
elif [ "$TERM" = "screen" ]; then
    TERM="screen-256color"
elif [ "$TERM" = "screen-bce" ]; then
    TERM="screen-256color-bce"
fi


# Use hard limits, except for a smaller stack and no core dumps
unlimit
limit coredumpsize 0
limit -s # Set limits of current shell to previously set limits of children.

umask 022


################################################################
#### Alias
# Set up aliases
alias mv='nocorrect mv'       # no spelling correction
alias cp='nocorrect cp'       # no spelling correction
alias mkdir='nocorrect mkdir' # no spelling correction
alias j=jobs
alias pu=pushd
alias po=popd
alias d='dirs -v'
alias h=history
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -a -l'
alias lsd='ls -d *(-/DN)'
alias lsh='ls -d .*'
alias rmbak='rm ~/**/*~'
alias waf='python waf'
alias elc='emacs -batch --load ~/.emacs --funcall batch-byte-compile'
alias eix='nocorrect eix'
alias ssh='nocorrect ssh'
alias screen='screen -U'
alias tmux='tmux -u'
alias watch='noglob watch'
alias jfbterm='LANG=ja_JP.UTF-8 jfbterm -q -f ~/.jfbterm.conf'
#alias jfbterm='jfbterm -q -f ~/.jfbterm.conf'
#alias startx='startx > /tmp/startx_${USER}.log 2>&1 &'
alias startx='startx > /dev/null 2>&1 &'
alias ds=dirsize.sh
alias open='xdg-open'
alias lpxdvi='pxdvi -geometry 1005x711 -paper a4r'
#alias chrm='chromium --memory-model=low'
#alias chrm='chromium --allow-outdated-plugins'

# Global aliases -- These do not have to be
# at the beginning of the command line.
alias -g M='| more'
alias -g L='| less'
alias -g LS='| less -S'
alias -g H='| head'
alias -g T='| tail'
alias -g S='| sort'
alias -g G='| grep'
alias -g X='| xargs'


################################################################
#### Shell functions
function wb() { firefox $* > /dev/null 2>&1 &! }
function fm() { pcmanfm $* > /dev/null 2>&1 &! }
function refe() {
  /usr/bin/refe $1 | iconv -f euc-jp -t utf-8 | less
}
function encrypt() {
  gpg -o ~/${1##*/}.gpg --cipher-algo AES256 --compress-level 0 -c $1
}

freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }

# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
for func in $^fpath/*(N-.x:t); autoload $func

# Set the title and hardstatus of an XTerm or of GNU Screen
# http://grml.org/zsh/zsh-lovers.html
#function title {
#      if [[ $TERM == "screen" ]]; then
#        # Use these two for GNU Screen:
#        print -nR $' 33k'$1$' 33'\
#        print -nR $' 33]0;'$2$''
#      elif [[ $TERM == "xterm" || $TERM == "rxvt" ]]; then
#        # Use this one instead for XTerms:
#        print -nR $' 33]0;'$*$''
#      fi
#}
#function precmd { title zsh "$PWD" }
#function preexec {
#    emulate -L zsh
#    local -a cmd; cmd=(${(z)1})
#    title $cmd[1]:t "$cmd[2,-1]"
#}


################################################################
#### Options

# Other Options
setopt print_eight_bit # show japanese filename correctly on completion

# History Options
setopt hist_ignore_all_dups # Duplicate histories are ignored
setopt hist_save_nodups # Don't save duplicate history
setopt extended_history # Record history with timestamp.
setopt inc_append_history # Append history to file as soon as they're entered.
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_no_store # Don't store history commands
unsetopt share_history

setopt dvorak
setopt ignore_eof # Ignore Ctrl-D and don't logout.
setopt autocd autolist auto_pushd
setopt listtypes
unsetopt listambiguous
setopt cdable_vars check_jobs correct correct_all
setopt equals extended_glob
setopt globdots
setopt long_list_jobs
setopt clobber # Redirection can truncate existing files and create files.
unsetopt notify # Notify immediately when background job exits.
setopt prompt_subst
setopt pushd_ignore_dups pushd_silent pushd_to_home
setopt recexact rcquotes
setopt list_packed
setopt magic_equal_subst
unsetopt beep
unsetopt bgnice
unsetopt global_export
if [ $USER = "root" ]; then
    unsetopt clobber
fi


################################################################
#### Autoloads

autoload -U promptinit; promptinit
autoload -U colors; colors
autoload -Uz vcs_info
autoload -U zcalc
autoload -U zargs
autoload -U url-quote-magic; zle -N self-insert url-quote-magic

# Autoload zsh modules when they are referenced
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile
# stat(1) is now commonly an external command, so just load zstat
zmodload -aF zsh/stat b:zstat


################################################################
#### Completion

# Setup new style completion system. To see examples of the old style (compctl
# based) programmable completion, check Misc/compctl-examples in the zsh
# distribution.
autoload -Uz compinit; compinit

# Completion Styles

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns \
    '*?.o' '*?.c~' '*?.cpp~' \
    '*?.old' '*?.pro'

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'


################################################################
#### Key Bindings

bindkey -e                  # use emacs key bindings
#bindkey -v                  # use vi key bindings
#bindkey -v '' vi-backward-char
#bindkey -v '' vi-forward-char
#bindkey -v '' vi-beginning-of-line
#bindkey -v '' vi-end-of-line
#bindkey -v '' vi-kill-eol
#bindkey -v '' kill-whole-line
#bindkey -v '' history-incremental-search-backward
#bindkey -v '' history-incremental-search-forward
#bindkey -a 'q' push-line
#bindkey -v '' push-line
#bindkey -v 'q' push-line
#bindkey -v 'Q' push-line
#bindkey -v -r '/'
