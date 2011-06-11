# .zshenv is sourced on all invocations of the
# shell, unless the -f option is set.  It should
# contain commands to set the command search path,
# plus other important environment variables.
# .zshenv should not contain commands that product
# output or assume the shell is attached to a tty.

export EDITOR='vim'
#export GIT_EDITOR='gvim -f'
export BC_ENV_ARGS="-l ${HOME}/.bc"
#export PAGER='less'
export LESS='-R --ignore-case'
export JLESS='-R --ignore-case'
export LV='-c'
export JLESSCHARSET='ja'
export RUBYLIB=$HOME/ruby/lib
export VTE_CJK_WIDTH=1
export DICTIONARY=en_US
