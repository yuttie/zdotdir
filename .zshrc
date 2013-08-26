# Environment Variable
if [ -e ~/.zshenv ] ; then
    source ~/.zshenv
fi

# Path
path=(~/bin
      ~/.gem/ruby/1.8
      ~/.gem/ruby/1.9.1
      ~/.cabal/bin
      $path)
fpath=($fpath ~/.zfunc)  # Where to look for autoloaded function definitions
manpath=($manpath)
typeset -U path cdpath fpath manpath  # automatically remove duplicates from these arrays


# Autoloads
autoload -U promptinit; promptinit
autoload -U colors; colors
autoload -Uz vcs_info
autoload -U zcalc
autoload -U zargs
autoload -U url-quote-magic; zle -N self-insert url-quote-magic
autoload -Uz add-zsh-hook
# Autoload zsh modules when they are referenced
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile
# stat(1) is now commonly an external command, so just load zstat
zmodload -aF zsh/stat b:zstat


# default prompt
PROMPT=$'%B%(!.%F{red}.%F{green})%n@%m%f %F{magenta}%$((COLUMNS - (${#USER} + 1 + ${#HOST} + 1)))<...<%~%f
%F{blue}%#%f%b '

# prompt for right side of screen
zstyle ':vcs_info:*' formats       '%F{yellow}(%f%s%F{yellow})-[%F{green}%b%F{yellow}]%f%u%c'
zstyle ':vcs_info:*' actionformats '%F{yellow}(%f%s%F{yellow})-[%F{green}%b%F{yellow}|%F{red}%a%F{yellow}]%f%u%c'
function precmd_vcs_info() { LANG=en_US.UTF-8 vcs_info }
add-zsh-hook precmd precmd_vcs_info
RPROMPT='${vcs_info_msg_0_}'

# History
HISTSIZE=1000000
SAVEHIST=1000000
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


# Alias
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
alias elc='emacs --quick -batch --funcall batch-byte-compile'
alias eix='nocorrect eix'
alias ssh='nocorrect ssh'
alias screen='screen -U'
alias watch='noglob watch'
alias jfbterm='LANG=ja_JP.UTF-8 jfbterm -q -f ~/.jfbterm.conf'
alias startx='startx > /dev/null 2>&1 &'
alias ds=dirsize.sh
alias open='xdg-open'
alias lpxdvi='pxdvi -geometry 1005x711 -paper a4r'


# Global aliases
alias -g M='| more'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g S='| sort'
alias -g G='| grep'
alias -g X='| xargs'


# Shell functions
function ecg() { emacsclient --alternate-editor='' --create-frame --no-wait "$@" }
function ect() { emacsclient --alternate-editor='' --create-frame --tty "$@" }
function ec() { if [ -z "$DISPLAY" ]; then ect "$@"; else ecg "$@"; fi }
function ec-ls() { ls --color=never /tmp/emacs$(id -ur) }
function ec-kill() { emacsclient --socket-name="${1:-server}" --eval "(kill-emacs)" }
function wb() { $BROWSER $* > /dev/null 2>&1 &! }
function fm() { pcmanfm $* > /dev/null 2>&1 &! }
function encrypt() {
  gpg -o ~/${1##*/}.gpg --cipher-algo AES256 --compress-level 0 -c $1
}

function tm() {
  if [ -n "$1" ]; then
    command tmux -u attach -t $1 || command tmux -u new -s $1
  else
    command tmux -u
  fi
}

function freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }

# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
for func in $^fpath/*(N-.x:t); autoload $func


# Options
# History Options
setopt hist_ignore_all_dups # Duplicate histories are ignored
setopt hist_save_nodups # Don't save duplicate history
setopt extended_history # Record history with timestamp.
setopt inc_append_history # Append history to file as soon as they're entered.
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_no_store # Don't store history commands
unsetopt share_history
# Other Options
setopt print_eight_bit # show japanese filename correctly on completion
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


# Completion
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
# Disable completion for some commands.
compdef -d p4


# Key Bindings
bindkey -e                  # use emacs key bindings


# Cooperate with the term+ mode of Emacs.
if [[ -n "$INSIDE_EMACS" ]]; then
  echo -ne "\e]51;host;$(hostname)\e\\" > /dev/tty
  echo -ne "\e]51;user;$(id -run)\e\\" > /dev/tty

  function precmd_emacs_term_cwd () {
      echo -ne "\e]51;cd;$(pwd)\e\\" > /dev/tty
  }
  add-zsh-hook precmd precmd_emacs_term_cwd

  function e() {
    echo -ne "\e]51;open;${(j:;:)@}\e\\" > /dev/tty
  }

  function v() {
    echo -ne "\e]51;view;${(j:;:)@}\e\\" > /dev/tty
  }
fi
