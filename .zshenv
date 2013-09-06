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

if [ -n "$DISPLAY" ]; then
  export BROWSER='firefox'
else
  export BROWSER='links'
fi

# freetype-infinality
export INFINALITY_FT_FILTER_PARAMS="11 33 44 33 11"
export INFINALITY_FT_GRAYSCALE_FILTER_STRENGTH=0
export INFINALITY_FT_FRINGE_FILTER_STRENGTH=0
export INFINALITY_FT_AUTOHINT_HORIZONTAL_STEM_DARKEN_STRENGTH=10
export INFINALITY_FT_AUTOHINT_VERTICAL_STEM_DARKEN_STRENGTH=25
export INFINALITY_FT_WINDOWS_STYLE_SHARPENING_STRENGTH=5
export INFINALITY_FT_CHROMEOS_STYLE_SHARPENING_STRENGTH=0
export INFINALITY_FT_STEM_ALIGNMENT_STRENGTH=25
export INFINALITY_FT_STEM_FITTING_STRENGTH=25
export INFINALITY_FT_GAMMA_CORRECTION="0 100"
export INFINALITY_FT_BRIGHTNESS="0"
export INFINALITY_FT_CONTRAST="0"
export INFINALITY_FT_USE_VARIOUS_TWEAKS=false
export INFINALITY_FT_AUTOHINT_INCREASE_GLYPH_HEIGHTS=false
export INFINALITY_FT_AUTOHINT_SNAP_STEM_HEIGHT=0
export INFINALITY_FT_STEM_SNAPPING_SLIDING_SCALE=40
export INFINALITY_FT_USE_KNOWN_SETTINGS_ON_SELECTED_FONTS=false
