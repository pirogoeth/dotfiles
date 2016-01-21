#!/usr/bin/env bash

THEME_LOADED="yes";         export THEME_LOADED

# This is a script to abstract away / prettify the configuration
# and compilation of my bash theme, which will help make it easier
# to customize in the future.

# NOTE! Colors do NOT need to be escaped, as the string representations
# themselves contain the escapes (see ~L116)
# When I say escaped, I mean with the \[ \] bracket notation used by bash.

declare -a CONTEXTS
CONTEXTS=( "GIT_CMD" "VENV_CMD" "BATT_CMD" "LAVG_CMD" )

# General settings.
RESET_COLOR="\e[0m"
DIR_COLOR="\e[32m"
CTX_COLOR="\e[32m"

# Colors to represent regular user vs. root user.
USER_COLOR="\e[32m"
ROOT_COLOR="\e[36m"
FALLBACK_COLOR="\e[31m"

# Theme elements.
SEP_CHAR="|" # Separator
BLC_CHAR="→" # Beginning of line
PMT_CHAR="λ" # Prompt line

# Context color
CONTEXT_COLOR="\e[35m"

# Color for theme elements
SEP_COLOR="\e[97m"
BLC_COLOR="\e[32m"

# Host string settings.
UNAME_COLOR="\e[37m"
HNAME_COLOR="\e[35m"
UHSEP_COLOR="\e[35m"

# Special characters.
USER_CHAR="\\u"
HOST_CHAR="\\h"
DIR_CHAR="\\w"
UHSEP_CHAR="@"

# Set short form under 80 columns.
if [[ "$(tput cols)" -lt "80" ]] ; then
    BT_SHORT="YES"
else
    BT_SHORT="NO"
fi

# Check for bracketing setting.
if [[ -z "${COLOR_BRACKETING}" ]] ; then
    COLOR_BRACKETING="NO"
fi

# Helper functions.
function ascii_color() {
    _color=${1}
    _char=${2}
    _reset=${RESET_COLOR}

    if [[ -z ${_color} || -z ${_char} ]] ; then
        echo ""
    fi

    if [[ "${_color}" == "NONE" ]] ; then
        _color=""
        _reset=""
    fi

    if [[ "${NO_COLOR}" == "YES" ]] ; then
        echo -e "${_char}"
        return
    fi

    if [[ "${COLOR_BRACKETING}" == "YES" ]] ; then
        echo -e "\001${_color}\002${_char}\001${_reset}\002"
    else
        echo -e "${_color}${_char}${_reset}"
    fi
}

function expr_eval() {
    _expr=${1}
    echo $(eval "${_expr}" 2>/dev/null)
}

function generate_context() {
    for (( i=0 ; $i<${#CONTEXTS[@]}; i++ ))
    do
        val="${!CONTEXTS[$i]}"
        # Test the context so we're not outputting empty space.
        if [[ -z "$(echo $(eval ${val}) | tr -d [:space:])" ]] ; then
            continue;
        fi
        # Print the separator.
        if [[ ${i} < ${#CONTEXTS[@]} ]] ; then
            if [[ "${NO_COLOR}" == "YES" ]] ; then
                echo -en "$(ascii_color NONE ${_SEP}) "
            else
                echo -en "$(ascii_color NONE ${_SEP}${RESET_COLOR}) "
            fi
        fi
        if [[ "${NO_COLOR}" == "YES" ]] ; then
            echo -en "$(eval ${val}) "
        else
            _tmp="$(eval ${val})"
            echo -en "$(ascii_color ${CTX_COLOR} "${_tmp}") "
        fi
    done
}

function __basename_ps1() {
    _fmt=${1}
    _dir=${2}

    [[ -z "${_fmt}" ]] && _fmt="%s"
    [[ -z "${_dir}" ]] && echo && return

    _dir_bn=$(basename ${_dir})
    [[ -z "${_dir_bn}" ]] && echo && return

    printf "${_fmt}" "${_dir_bn}"
}

function __generate_uidbased_eop() {
    _eop=${1}

    if [[ $EUID == 0 ]] ; then
        echo -en "$(ascii_color ${ROOT_COLOR} ${_eop})"
    else
        echo -en "$(ascii_color ${USER_COLOR} ${_eop})"
    fi
}

function __battery_ps1() {
    _fmt=${1}

    [[ -z "${_fmt}" ]] && _fmt="%s"
    [[ ! -f /sys/class/power_supply/BAT0/capacity ]] && return

    _batt_level="$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)"

    printf "${_fmt}" "${_batt_level}"
}

function __load_averages_ps1() {
    _fmt=${1}

    [[ -z "${_fmt}" ]] && fmt="%s"

    [[ ! -f /proc/loadavg ]] && echo && return

    fivemin="$(cat /proc/loadavg | awk '{print $1}')"

    # We want the five minute load average because why not.
    printf "${_fmt}" "${fivemin}"
}

export -f ascii_color expr_eval generate_context
export -f __basename_ps1 __generate_uidbased_eop
export -f __battery_ps1 __load_averages_ps1

# Separator.
_SEP="`ascii_color ${SEP_COLOR} ${SEP_CHAR}`"

# Settings for the git branch context.
GIT_COLOR="\e[36m"
GIT_SHORT_SYM="\u21cc"
if [[ "${NO_COLOR}" == "YES" ]] ; then
    if [[ "${BT_SHORT}" == "YES" ]] ; then
        GIT_CMD="__git_ps1 \"${GIT_SHORT_SYM}: %s\" 2>/dev/null"
    else
        GIT_CMD="__git_ps1 \"branch: %s\" 2>/dev/null"
    fi
else
    if [[ "${BT_SHORT}" == "YES" ]] ; then
        GIT_CMD="__git_ps1 \"${GIT_SHORT_SYM}: ${GIT_COLOR}%s${RESET_COLOR}\" 2>/dev/null"
    else
        GIT_CMD="__git_ps1 \"branch: ${GIT_COLOR}%s${RESET_COLOR}\" 2>/dev/null"
    fi
fi

# Settings for the virtualenv context.
VENV_COLOR="\e[36m"
VENV_SHORT_SYM="\u267b"
if [[ "${NO_COLOR}" == "YES" ]] ; then
    if [[ "${BT_SHORT}" == "YES" ]] ; then
        VENV_CMD="__basename_ps1 \"${VENV_SHORT_SYM}: %s\" \"\${VIRTUAL_ENV}\""
    else
        VENV_CMD="__basename_ps1 \"virtualenv: %s\" \"\${VIRTUAL_ENV}\""
    fi
else
    if [[ "${BT_SHORT}" == "YES" ]] ; then
        VENV_CMD="__basename_ps1 \"${VENV_SHORT_SYM}: ${VENV_COLOR}%s${RESET_COLOR}\" \"\${VIRTUAL_ENV}\""
    else
        VENV_CMD="__basename_ps1 \"virtualenv: ${VENV_COLOR}%s${RESET_COLOR}\" \"\${VIRTUAL_ENV}\""
    fi
fi

# Settings for battery level context.
BATT_COLOR="\e[36m"
BATT_SHORT_SYM="\u1f50b"
if [[ "${NO_COLOR}" == "YES" ]] ; then
    if [[ "${BT_SHORT}" == "YES" ]] ; then
        BATT_CMD="__battery_ps1 \"${BATT_SHORT_SYM}: %s%%\""
    else
        BATT_CMD="__battery_ps1 \"battery: %s%%\""
    fi
else
    if [[ "${BT_SHORT}" == "YES" ]] ; then
        BATT_CMD="__battery_ps1 \"${BATT_SHORT_SYM}: ${BATT_COLOR}%s%%${RESET_COLOR}\""
    else
        BATT_CMD="__battery_ps1 \"battery: ${BATT_COLOR}%s%%${RESET_COLOR}\""
    fi
fi

# Settings for load averages context.
LAVG_COLOR="\e[36m"
LAVG_SHORT_SYM="\u2300"
if [[ "${NO_COLOR}" == "YES" ]] ; then
    if [[ "${BT_SHORT}" == "YES" ]] ; then
        LAVG_CMD="__load_averages_ps1 \"${LAVG_SHORT_SYM}: %s\""
    else
        LAVG_CMD="__load_averages_ps1 \"load: %s\""
    fi
else
    if [[ "${BT_SHORT}" == "YES" ]] ; then
        LAVG_CMD="__load_averages_ps1 \"${LAVG_SHORT_SYM}: ${LAVG_COLOR}%s${RESET_COLOR}\""
    else
        LAVG_CMD="__load_averages_ps1 \"load: ${LAVG_COLOR}%s${RESET_COLOR}\""
    fi
fi

# Build the colorized dir, hoststring, etc.
_blc="`ascii_color ${BLC_COLOR} ${BLC_CHAR}`"
_uns="`ascii_color ${UNAME_COLOR} ${USER_CHAR}`"
_uhs="`ascii_color ${UHSEP_COLOR} ${UHSEP_CHAR}`"
_hns="`ascii_color ${HNAME_COLOR} ${HOST_CHAR}`"
_dir="`ascii_color ${DIR_COLOR} ${DIR_CHAR}`"
_fb_eop="`ascii_color ${FALLBACK_COLOR} ${PMT_CHAR}`"

GEN_CTX="generate_context 2>/dev/null || echo"
GEN_EOP="__generate_uidbased_eop ${PMT_CHAR} 2>/dev/null || echo -n \"${_fb_eop}\""

# Export the PS1 and backup.
_PS1="${_blc} ${_uns}${_uhs}${_hns} ${_SEP} ${_dir} \$(${GEN_CTX})\n\$(${GEN_EOP}) "; export _PS1
PS1=${_OLD_VIRTUAL_PS1:-${_PS1}}; export PS1; readonly PS1
