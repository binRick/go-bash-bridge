#!/usr/bin/env bash

# Emoji-based theme to display source control management and
# virtual environment info beside the ordinary bash prompt.

# Theme inspired by:
#  - Naming your Terminal tabs in OSX Lion - http://thelucid.com/2012/01/04/naming-your-terminal-tabs-in-osx-lion/
#  - Bash_it sexy theme

# Demo:
# ββ virtualenv πuser @ π» host in πdirectory on πΏbranch {1} β1 β1 +1 β’1 β1 β
# ββ― cd .bash-it/themes/cupcake

# virtualenv prompts
VIRTUALENV_CHAR="β "
VIRTUALENV_THEME_PROMPT_PREFIX=""
VIRTUALENV_THEME_PROMPT_SUFFIX=""

# SCM prompts
SCM_NONE_CHAR=""
SCM_GIT_CHAR="[Β±] "
SCM_GIT_BEHIND_CHAR="${red}β${normal}"
SCM_GIT_AHEAD_CHAR="${bold_green}β${normal}"
SCM_GIT_UNTRACKED_CHAR="β"
SCM_GIT_UNSTAGED_CHAR="${bold_yellow}β’${normal}"
SCM_GIT_STAGED_CHAR="${bold_green}+${normal}"

SCM_THEME_PROMPT_DIRTY=""
SCM_THEME_PROMPT_CLEAN=""
SCM_THEME_PROMPT_PREFIX=""
SCM_THEME_PROMPT_SUFFIX=""

# Git status prompts
GIT_THEME_PROMPT_DIRTY=" ${red}β${normal}"
GIT_THEME_PROMPT_CLEAN=" ${bold_green}β${normal}"
GIT_THEME_PROMPT_PREFIX=""
GIT_THEME_PROMPT_SUFFIX=""

# ICONS =======================================================================

icon_start="β"
icon_user="π  "
icon_host=" @ π»  "
icon_directory=" in π  "
icon_branch="πΏ"
icon_end="ββ― "

# extra spaces ensure legiblity in prompt

# FUNCTIONS ===================================================================

# Display virtual environment info
function virtualenv_prompt {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    virtualenv=`basename "$VIRTUAL_ENV"`
    echo -e "$VIRTUALENV_CHAR$virtualenv "
  fi
}

# Rename tab
function tabname {
  printf "\e]1;$1\a"
}

# Rename window
function winname {
  printf "\e]2;$1\a"
}

# PROMPT OUTPUT ===============================================================

# Displays the current prompt
function prompt_command() {
  PS1="\n${icon_start}$(virtualenv_prompt)${icon_user}${bold_red}\u${normal}${icon_host}${bold_cyan}\h${normal}${icon_directory}${bold_purple}\W${normal}\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on ${icon_branch}  \")${white}$(scm_prompt_info)${normal}\n${icon_end}"
  PS2="${icon_end}"
}

# Runs prompt (this bypasses oh-my-bash $PROMPT setting)
safe_append_prompt_command prompt_command
