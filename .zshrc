# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

case "$OSTYPE" in
  linux*)
    # keychain
    eval `keychain --eval --agents ssh,gpg --quiet --quick id_ed25519 id_rsa_4096`
    ;;
  darwin*)
    # keychain
    eval `keychain --eval --agents ssh,gpg --quiet --quick --inherit any id_ed25519 id_rsa`
    ;;
esac


# Environment variables overridden by system after .zshenv
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
autoload -Uz fzf-fish-history-widget
# run-help
export HELPDIR=/usr/share/zsh/$ZSH_VERSION/help
unalias run-help && autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-openssl
autoload -Uz run-help-p4
autoload -Uz run-help-sudo
autoload -Uz run-help-svk
autoload -Uz run-help-svn


# Use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit coredumpsize 0
limit -s # Set limits of current shell to previously set limits of children.

umask 022


# Alias
alias antibody-regen='antibody bundle < ~/zdotdir/.zsh_plugins.txt > ~/.zsh_plugins.sh'
alias mv='nocorrect mv'       # no spelling correction
alias cp='nocorrect cp'       # no spelling correction
alias mkdir='nocorrect mkdir' # no spelling correction
alias j=jobs
alias pu=pushd
alias po=popd
alias d='dirs -v'
alias h=history
alias history-all='history -i 1'
alias grep='grep --color=auto'
if [[ "$OSTYPE" =~ '^linux' ]]; then
  alias ls='ls --color=auto --time-style=long-iso'
fi
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -a -l'
alias lsd='ls -d *(-/DN)'
alias lsh='ls -d .*'
alias rmbak='find ~/ -name '\''*~'\'' | xargs --max-args=1 rm -fv'
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
alias ds='du --block-size=1M --max-depth=1 --one-file-system | sort --numeric-sort'
alias battery='upower -e | fgrep -F BAT | xargs -n 1 upower -i'
alias bat='bat --theme="base16" --wrap=never'
alias note='vim ~/Notes/notes-$(date +%Y-%m-%d).md'
alias gitdiff='git diff --no-index'
alias vim='nvim'
alias view='nvim -R'
alias vimdiff='nvim -d'
function Nvim() {
  nohup env --unset TMUX ~/.local/bin/term -e nvim "$@" >/dev/null 2>&1 &!
}
function rgl() {
  rg --color=always --heading --line-number "$@" | less -R
}
alias ltma='tmux new -A -s'
function clean() {
  if [ -z "$1" ]; then
    echo An argument is required. 1>&2
    return 1
  fi

  find $1 -type f \( -name '*~' -o -name 'nohup.out' -o -name '.DS_Store' -o -name '~$*' -o -name 'persp-auto-save*' -o -name '.~*#' \) -exec rm -fv '{}' \;
}
alias clean-home="clean ~/"
# Emacs
alias et='KONSOLE_DBUS_SESSION=1 emacs --no-window-system'
function eg() { emacs --display=${DISPLAY:-:0} "$@"&! }
function egt() {
  env --unset TMUX \
      KONSOLE_DBUS_SESSION=1 \
      ~/dotfiles/term -e emacs --no-window-system "$@"&!
}
# Emacsclient
alias ecg='emacsclient --alternate-editor='' --create-frame --display=${DISPLAY:-:0} --no-wait'
alias ect='KONSOLE_DBUS_SESSION=1 emacsclient --alternate-editor='' --create-frame --tty'
function ec() { if [ -z "$DISPLAY" ]; then ect "$@"; else ecg "$@"; fi }
function ec-ls() { ls --color=never /tmp/emacs$(id -ur) }
function ec-kill() { emacsclient --socket-name="${1:-server}" --eval "(kill-emacs)" }
function ec-killall() { for s in `ec-ls`; do echo "Kill session '$s'"; ec-kill $s; done }
# Mac OS X
case "$OSTYPE" in
  darwin*)
    alias eg='open -a /Applications/Emacs.app'
    alias ecg='emacsclient --alternate-editor='' --create-frame --no-wait'
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
function encrypt() {
  for f in "$@"; do
    gpg --output "$f.gpg" --cipher-algo AES256 -z 0 --symmetric "$f"
  done
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

freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }

# Where to look for autoloaded function definitions
fpath=(~/.zfunc $fpath)

# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
for func in $^fpath/*(N-.x:t); autoload $func

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath


#
# PATH
#
# TODO this takes around 7ms

# Define the base paths
additional_paths=(
  ~/.local/bin
  ~/.poetry/bin
  ~/.cargo/bin
  ~/go/bin
  ~/.yarn/bin
  $NPM_PACKAGES/bin
  ~/.gem/ruby/*/bin(N)
  /usr/local/texlive/2020/bin/x86_64-linux
)

# Add extra paths for macOS
case "$OSTYPE" in
  darwin*)
    additional_paths=(
      ~/Library/Python/3.7/bin
      /usr/local/opt/ruby/bin
      /usr/local/Cellar/git/*/share/git-core/contrib/diff-highlight(N)
      /usr/local/sbin
      $additional_paths
    )
    ;;
esac

# Export PATH
for (( i=${#additional_paths[@]}; i>0; i-- )); do
  d=${additional_paths[i]}
  [[ -d $d ]] && path=($d $path)
done
export PATH

#
# MANPATH
#
manpath=($NPM_PACKAGES/share/man
         /usr/local/texlive/2020/texmf-dist/doc/man
         $MANPATH)
export MANPATH

#
# INFOPATH
#
export INFOPATH="/usr/local/texlive/2020/texmf-dist/doc/info:$INFOPATH"


#
# Environment Variables
#
# History
HISTSIZE=30000
SAVEHIST=30000
HISTFILE=~/.zsh_history

# other variables
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Fix $TERM if a terminfo for the terminal is not available
if ! infocmp "$TERM" >/dev/null 2>&1; then
  if [ "$TERM" = "rxvt-unicode-256color" ]; then
    if infocmp "rxvt-256color" >/dev/null 2>&1; then
      TERM="rxvt-256color"
    fi
  fi
  if [ "$TERM" = "tmux-256color" ]; then
    if infocmp "screen-256color" >/dev/null 2>&1; then
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


#
# Options
#
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
setopt autocd autolist auto_pushd
setopt listtypes
unsetopt listambiguous
setopt cdable_vars check_jobs correct correct_all
setopt equals extended_glob
setopt globdots
setopt long_list_jobs
setopt clobber # Redirection can truncate existing files and create files.
unsetopt notify # Don't report the status of background jobs immediately when background job exits.
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


#
# Modules
#
# Autoload zsh modules when they are referenced
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile
# stat(1) is now commonly an external command, so just load zstat
zmodload -aF zsh/stat b:zstat


# Key Bindings
bindkey -e                  # use emacs key bindings
bindkey '^[[Z' reverse-menu-complete


#
# Completion
#
# Setup new style completion system. To see examples of the old style (compctl
# based) programmable completion, check Misc/compctl-examples in the zsh
# distribution.
autoload -Uz compinit; compinit
autoload -Uz bashcompinit; bashcompinit
if command -v stack >/dev/null 2>&1; then
  eval "$(stack --bash-completion-script stack)"
fi


#
# Completion Styles
#
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

# Antibody
source ~/.zsh_plugins.sh

# OPAM configuration
if [ -e ~/.opam/opam-init/init.zsh ]; then
  source ~/.opam/opam-init/init.zsh >/dev/null 2>/dev/null || true
fi

# Refresh the prompt before executing a command line
function reset-prompt-and-accept-line() { zle reset-prompt; zle accept-line; }
zle -N reset-prompt-and-accept-line
bindkey "\C-m" reset-prompt-and-accept-line

# zsh-notify
# https://github.com/marzocchi/zsh-notify
# https://github.com/yuttie/zsh-notify
export NOTIFY_COMMAND_COMPLETE_TIMEOUT=1
source ~/.zsh.d/zsh-notify/notify.plugin.zsh

# fzf
zle -N fzf-fish-history-widget
bindkey '^[r' fzf-fish-history-widget

# http://qiita.com/Linda_pp/items/9ff801aa6e00459217f7
function list-all-man-pages() {
    local parent dir file
    local paths=("${(s/:/)$(man -aw)}")
    for parent in $paths; do
        for dir in $(/bin/ls -1 $parent 2>/dev/null); do
            local p="${parent}/${dir}"
            if [ -d "$p" ]; then
                IFS=$'\n' local lines=($(/bin/ls -1 "$p"))
                for file in $lines; do
                    echo "${p}/${file}"
                done
            fi
        done
    done
}

function fzf-man() {
    local selected=$(list-all-man-pages | fzf --prompt='man> ')
    zle reset-prompt
    if [[ "$selected" != "" ]]; then
        man "$selected"
    fi
}
zle -N fzf-man
bindkey '^[m' fzf-man


# Insert timestamp
function insert-date-timestamp() {
  LBUFFER="${LBUFFER}\$(date +%Y-%m-%d-%H%M%S)"
}
zle -N insert-date-timestamp
bindkey '^[t' insert-date-timestamp


# Edit a note
ZSH_NOTE_DIR="$HOME/Notes"
function edit-note() {
  # Decide which command to use
  local preview_cmd="cat {}"
  if command -v bat &>/dev/null; then
    preview_cmd="bat --color=always {}"
  fi
  # Choose a note
  local fp=$(cd $ZSH_NOTE_DIR; find . -type f -regextype egrep -regex '.*\.(md|org|rst|asciidoc|adoc|txt)$' | cut -b3- | fzf --preview "$preview_cmd")
  zle reset-prompt
  # Open the chosen note
  if [ -n "$fp" ]; then
    BUFFER="$EDITOR \"$ZSH_NOTE_DIR/$fp\""
    zle accept-line
  fi
}

zle -N edit-note
bindkey '^[n' edit-note


# Properly clear autosuggestions
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=reset-prompt-and-accept-line

# Bind keys for zsh-history-substring-search
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# Activate auto compeltion for aws-cli
if type aws_zsh_completer.sh >/dev/null; then
  source $(which aws_zsh_completer.sh)
fi

# Highlighting
zle_highlight=(region:standout special:standout suffix:bold isearch:fg=magenta,underline paste:standout)

ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[alias]=fg=black
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=black,underline
ZSH_HIGHLIGHT_STYLES[builtin]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[function]=fg=black
ZSH_HIGHLIGHT_STYLES[command]=fg=black
ZSH_HIGHLIGHT_STYLES[precommand]=fg=black,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=yellow,bold
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=black
ZSH_HIGHLIGHT_STYLES[path]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
ZSH_HIGHLIGHT_STYLES[path_prefix]=underline
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
ZSH_HIGHLIGHT_STYLES[globbing]=fg=yellow
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=yellow
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=blue
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=blue
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=blue
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=166
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=166
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=166
ZSH_HIGHLIGHT_STYLES[assign]=none
ZSH_HIGHLIGHT_STYLES[redirection]=fg=yellow,bold
ZSH_HIGHLIGHT_STYLES[comment]=fg=white

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
