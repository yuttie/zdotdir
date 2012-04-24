# .zshenv is sourced on all invocations of the
# shell, unless the -f option is set.  It should
# contain commands to set the command search path,
# plus other important environment variables.
# .zshenv should not contain commands that product
# output or assume the shell is attached to a tty.

export LANG='en_US.UTF-8'
export EDITOR='vim'
export DICTIONARY=en_US

export LESS='-R --ignore-case'
export JLESS='-R --ignore-case'
export JLESSCHARSET='ja'
export LV='-c'

export BC_ENV_ARGS="-l ${HOME}/.bc"
