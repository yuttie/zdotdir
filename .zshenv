# .zshenv is sourced on all invocations of the
# shell, unless the -f option is set.  It should
# contain commands to set the command search path,
# plus other important environment variables.
# .zshenv should not contain commands that product
# output or assume the shell is attached to a tty.

export LANG='en_US.UTF-8'
export EDITOR='nvim'
export DICTIONARY=en_US

export LESS='--RAW-CONTROL-CHARS --ignore-case --chop-long-lines'

# Colored man pages
export GROFF_NO_SGR=1
export LESS_TERMCAP_mb=$'\E[01;31m'     # begin blinking
export LESS_TERMCAP_md=$'\E[01;31m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'         # end mode
export LESS_TERMCAP_so=$'\E[01;44;33m'  # begin standout-mode - info box
export LESS_TERMCAP_se=$'\E[0m'         # end standout-mode
export LESS_TERMCAP_us=$'\E[01;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'         # end underline

export BC_ENV_ARGS="-l ${HOME}/.bc"

export PYTHONSTARTUP=~/.pythonstartup

export GPG_TTY=`tty`

if [ -n "$DISPLAY" ]; then
  export BROWSER='firefox'
else
  export BROWSER='links'
fi

export RUST_SRC_PATH=~/rust/src
export NPM_PACKAGES="$HOME/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

if [[ `uname` == 'Darwin' ]]; then
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$(find /usr/local/Cellar -name 'pkgconfig' -type d | sed -n -e '1h; 1!H; ${ x; s/\n/:/g; p; }')
fi

if [ -f ~/.dir_colors ]; then
  if which dircolors >/dev/null 2>&1; then
    eval $(dircolors ~/.dir_colors)
  fi
fi
