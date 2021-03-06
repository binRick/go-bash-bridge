export OSH=~/go-bash-bridge/etc/oh-my-bash
export OSH_THEME_FILE=~/go-bash-bridge/etc/modern.theme.sh
OSH_THEMES="90210 agnoster axin bakke base.theme.sh binaryanomaly bobby bobby-python brainy brunton candy clean colours.theme.sh cooperkid cupcake demula dos doubletime doubletime_multiline doubletime_multiline_pyonly dulcie duru emperor envy font gallifrey garo hawaii50 iterate kitsune luan mairan mbriggs minimal modern modern-t morris n0qorg nwinkler nwinkler_random_colors pete powerline powerline-multiline powerline-naked powerline-plain primer pro pure purity rainbowbrite rana rjorgenson roderik sexy simple sirup slick standard THEMES.md tonka tonotdo tylenol wanelo zitron zork"
RANDOM_THEME="$(echo $OSH_THEMES |tr ' ' '\n'|shuf|grep '^[a-z]'|head -n1)"
OSH_THEME="90210"
OSH_THEME="agnoster"
OSH_THEME="axin"
OSH_THEME="bakke"
OSH_THEME="base.theme.sh"
OSH_THEME="binaryanomaly"
OSH_THEME="bobby"
OSH_THEME="bobby-python"
OSH_THEME="brainy"
OSH_THEME="brunton"
OSH_THEME="candy"
OSH_THEME="clean"
OSH_THEME="colours.theme.sh"
OSH_THEME="cooperkid"
OSH_THEME="cupcake"
OSH_THEME="demula"
OSH_THEME="dos"
OSH_THEME="doubletime"
OSH_THEME="doubletime_multiline"
OSH_THEME="doubletime_multiline_pyonly"
OSH_THEME="dulcie"
OSH_THEME="duru"
OSH_THEME="emperor"
OSH_THEME="envy"
OSH_THEME="font"
OSH_THEME="gallifrey"
OSH_THEME="garo"
OSH_THEME="hawaii50"
OSH_THEME="iterate"
OSH_THEME="kitsune"
OSH_THEME="luan"
OSH_THEME="mairan"
OSH_THEME="mbriggs"
OSH_THEME="minimal"
OSH_THEME="modern"
OSH_THEME="modern-t"
OSH_THEME="morris"
OSH_THEME="n0qorg"
OSH_THEME="nwinkler"
OSH_THEME="nwinkler_random_colors"
OSH_THEME="pete"
OSH_THEME="powerline-naked"
OSH_THEME="powerline-plain"
OSH_THEME="primer"
OSH_THEME="pro"
OSH_THEME="pure"
OSH_THEME="purity"
OSH_THEME="rainbowbrite"
OSH_THEME="rana"
OSH_THEME="rjorgenson"
OSH_THEME="roderik"
OSH_THEME="sexy"
OSH_THEME="simple"
OSH_THEME="sirup"
OSH_THEME="slick"
OSH_THEME="standard"
OSH_THEME="THEMES.md"
OSH_THEME="tonka"
OSH_THEME="tonotdo"
OSH_THEME="tylenol"
OSH_THEME="wanelo"
OSH_THEME="zitron"
OSH_THEME="zork"
OSH_THEME="powerline"
OSH_THEME="powerline-multiline"

#>&2 ansi --yellow --bg-black --italic "RANDOM_THEME=$RANDOM_THEME"
#OSH_THEME="$RANDOM_THEME"
completions=(
)
aliases=(
  general
)
plugins=(
)

clear
BASH_BUILTINS_DIR=~/go-bash-bridge/RELEASE/lib/bash
BUILTINS="ln id cut head rm seq sleep sync tee unlink uname mkdir dirname basename"
for B in $BUILTINS; do enable -f $BASH_BUILTINS_DIR/$B $B; done
#ls $BASH_BUILTINS_DIR


source $OSH/oh-my-bash.sh
