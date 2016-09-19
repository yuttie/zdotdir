# Environment variables that are overridden after .zshenv
export LESSOPEN=""

# Load host-specific configurations
if [ -e ~/.host.zsh ] ; then
    source ~/.host.zsh
fi


# Autoloads
autoload -U promptinit; promptinit
autoload -U colors; colors
autoload -Uz vcs_info
autoload -U zcalc
autoload -U zargs
autoload -U url-quote-magic; zle -N self-insert url-quote-magic
autoload -Uz add-zsh-hook
# run-help
unalias run-help
autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-openssl
autoload -Uz run-help-p4
autoload -Uz run-help-sudo
autoload -Uz run-help-svk
autoload -Uz run-help-svn
HELPDIR=/usr/share/zsh/5.0.5/help


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
alias rmbak='find ~/ -name '\''*~'\'' | xargs rm -v'
alias ps='ps -ejfH'
alias pkill='pkill --exact'
alias waf='python waf'
alias eix='nocorrect eix'
alias ssh='nocorrect ssh'
alias screen='screen -U'
alias watch='noglob watch'
alias jfbterm='LANG=ja_JP.UTF-8 jfbterm -q -f ~/.jfbterm.conf'
alias startx='startx > /dev/null 2>&1 &'
alias open='xdg-open'
alias lpxdvi='pxdvi -geometry 1005x711 -paper a4r'
alias ds='du -m -d1 | sort -n'
alias bat='upower -e | fgrep -F BAT | xargs -n 1 upower -i'
alias vim='NVIM_TUI_ENABLE_CURSOR_SHAPE=1 nvim'
alias view='NVIM_TUI_ENABLE_CURSOR_SHAPE=1 nvim -R'
alias vimdiff='NVIM_TUI_ENABLE_CURSOR_SHAPE=1 nvim -d'
alias nvim='NVIM_TUI_ENABLE_CURSOR_SHAPE=1 nvim'
function Nvim() {
  env --unset TMUX \
      NVIM_TUI_ENABLE_CURSOR_SHAPE=1 \
      ~/dotfiles/launch-st -e nvim "$@"&!
}
# Emacs
alias et='KONSOLE_DBUS_SESSION=1 emacs --no-window-system'
function eg() { emacs --display=${DISPLAY:-:0} "$@"&! }
function egt() {
  env --unset TMUX \
      KONSOLE_DBUS_SESSION=1 \
      ~/dotfiles/launch-st -e emacs --no-window-system "$@"&!
}
# Emacsclient
alias ecg='emacsclient --alternate-editor='' --create-frame --display=${DISPLAY:-:0} --no-wait'
alias ect='KONSOLE_DBUS_SESSION=1 emacsclient --alternate-editor='' --create-frame --tty'
# Mac OS X
case "$OSTYPE" in
  darwin*)
    alias eg='open -a /Applications/Emacs.app'
    alias ecg='emacsclient --alternate-editor='' --create-frame --no-wait'
    alias rsync='rsync --iconv=UTF8-MAC,UTF8'
    unalias ls
    unalias open
    ;;
esac


# Global aliases
alias -g M='| more'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g S='| sort'
alias -g G='| grep'
alias -g X='| xargs'
alias -g C='| DISPLAY=:0 xclip -selection clipboard'
alias -g F='| fzf'


# Shell functions
function ec() { if [ -z "$DISPLAY" ]; then ect "$@"; else ecg "$@"; fi }
function ec-ls() { ls --color=never /tmp/emacs$(id -ur) }
function ec-kill() { emacsclient --socket-name="${1:-server}" --eval "(kill-emacs)" }
function ec-killall() { for s in `ec-ls`; do echo "Kill session '$s'"; ec-kill $s; done }
function wb() { $BROWSER $* > /dev/null 2>&1 &! }
function fm() { pcmanfm $* > /dev/null 2>&1 &! }
function encrypt() {
  gpg --output ~/${1##*/}.gpg --cipher-algo AES256 -z 0 --symmetric $1
}

function call_me_later() {
  local time message title
  time="$1"
  shift
  message="$@"
  if [ -z "$message" ]; then
    title="$time"
  else
    title="$time - $message"
  fi
  echo "notify-send --icon appointment-soon --expire-time=0 --urgency=critical '$title'" | at "$time"
}
alias cml=call_me_later

function freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }

# Where to look for autoloaded function definitions
fpath=($fpath ~/.zfunc)

# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
for func in $^fpath/*(N-.x:t); autoload $func

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath


# default prompt
PROMPT=$'%B%(!.%F{red}root.%F{$host_color}%n)@%m%f %F{magenta}%$((COLUMNS - (${#USER} + 1 + ${#HOST} + 1)))<...<%~%f %F{black}[%D{%Y-%m-%d %H:%M:%S}]%f
%F{blue}❱%f%b '

# prompt for right side of screen
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr   '%F{yellow}+%f'
zstyle ':vcs_info:git:*' unstagedstr '%F{red}!%f'
zstyle ':vcs_info:*' formats       '%B%s:%F{green}%b%f%c%u'
zstyle ':vcs_info:*' actionformats '%B%s:%F{green}%b%f%F{red}>%a%f%c%u'
function precmd_vcs_info() { LANG=en_US.UTF-8 vcs_info }
add-zsh-hook precmd precmd_vcs_info
RPROMPT='${vcs_info_msg_0_}'

# Path
case "$OSTYPE" in
  darwin*)
    additional_path=(/usr/local/opt/ruby/bin)
    # Add GHC 7.8.3 to the PATH, via http://ghcformacosx.github.io/
    export GHC_DOT_APP="/Applications/ghc-7.8.3.app"
    if [ -d "$GHC_DOT_APP" ]; then
      additional_path=("${GHC_DOT_APP}/Contents/bin" $additional_path)
    fi
    ;;
  *)
    additional_path=(~/bin
                     ~/.local/bin
                     ~/.gem/ruby/2.0.0/bin
                     ~/.gem/ruby/2.1.0/bin
                     ~/.gem/ruby/2.2.0/bin
                     ~/.gem/ruby/2.3.0/bin
                     ~/.cabal/bin
                     ~/.cargo/bin
                     ~/$NPM_PACKAGES/bin)
    ;;
esac
for (( i=${#additional_path[@]}; i>0; i-- )); do
  d=${additional_path[i]}
  [[ -d $d ]] && path=($d $path)
done
export PATH

unset MANPATH
manpath=($NPM_PACKAGES/share/man $(manpath))
export MANPATH

# History
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history

# other variables
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Fix $TERM if a terminfo for the terminal is not available
if ! infocmp "$TERM" >/dev/null; then
  if [ "$TERM" = "rxvt-unicode-256color" ]; then
    if infocmp "rxvt-256color" >/dev/null; then
      TERM="rxvt-256color"
    fi
  fi
  if [ "$TERM" = "tmux-256color" ]; then
    if infocmp "screen-256color" >/dev/null; then
      TERM="screen-256color"
    fi
  fi
fi

# Force 256-colorization by correcting TERM variable
if [[ "$TERM" == "xterm" && -e /usr/share/terminfo/x/xterm-256color ]]; then
    TERM="xterm-256color"
elif [[ "$TERM" == "screen" && -e /usr/share/terminfo/s/screen-256color ]]; then
    TERM="screen-256color"
elif [[ "$TERM" == "screen-bce" && -e /usr/share/terminfo/s/screen-256color-bce ]]; then
    TERM="screen-256color-bce"
fi


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
if [[ $USER == "root" ]]; then
    unsetopt clobber
fi


# Autoload zsh modules when they are referenced
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile
# stat(1) is now commonly an external command, so just load zstat
zmodload -aF zsh/stat b:zstat


# Key Bindings
bindkey -e                  # use emacs key bindings


# Completion
# Setup new style completion system. To see examples of the old style (compctl
# based) programmable completion, check Misc/compctl-examples in the zsh
# distribution.
autoload -Uz compinit; compinit
autoload -Uz bashcompinit; bashcompinit
if command -v stack >/dev/null 2>&1; then
  eval "$(stack --bash-completion-script stack)"
fi
# Completion Styles
# colorize
if [ -n "$LS_COLORS" ]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
# Paths to search for a command when sudoing
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
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


# Replace a completion suffix with space when one of the following characters
# are input after the completion
ZLE_SPACE_SUFFIX_CHARS=$'|'


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

  function t() {
    echo -ne "\e]51;open-elscreen;${(j:;:)@}\e\\" > /dev/tty
  }
fi

# OPAM configuration
if [ -e ~/.opam/opam-init/init.zsh ]; then
  source ~/.opam/opam-init/init.zsh >/dev/null 2>/dev/null || true
fi

# Refresh the prompt before executing a command line
function reset-prompt-and-accept-line() { zle reset-prompt; zle accept-line; }
zle -N reset-prompt-and-accept-line
bindkey "\C-m" reset-prompt-and-accept-line

# Show exit codes of commands
function show_last_exit_code() { echo "$fg[white]$?$reset_color"; }
add-zsh-hook precmd show_last_exit_code

# zsh-notify
# https://github.com/marzocchi/zsh-notify
# https://github.com/yuttie/zsh-notify
export NOTIFY_COMMAND_COMPLETE_TIMEOUT=1
source ~/.zsh.d/zsh-notify/notify.plugin.zsh

# fzf
# https://gist.github.com/jimeh/7d94f1000cfc9cba2893
if command -v fzf >/dev/null 2>&1; then
  function fzf_select_history() {
    local tac
    { command -v gtac >/dev/null 2>&1 && tac="gtac" } || \
      { command -v tac >/dev/null 2>&1 && tac="tac" } || \
      tac="tail -r"
    BUFFER=$(fc -l -n 1 | eval $tac | \
                fzf --tiebreak=index --query "$LBUFFER")
    CURSOR=$#BUFFER # move cursor
    zle -R -c       # refresh
  }

  zle -N fzf_select_history
  bindkey '^T' fzf_select_history
fi


# zplug
source ~/.zplug/init.zsh

zplug 'zsh-users/zsh-autosuggestions'
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", nice:10
zplug "zsh-users/zsh-history-substring-search"
zplug "rust-lang/zsh-config"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

# Properly clear autosuggestions
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=reset-prompt-and-accept-line

# Activate auto compeltion for aws-cli
if [ -e `which aws_zsh_completer.sh` ]; then
  source `which aws_zsh_completer.sh`
fi
