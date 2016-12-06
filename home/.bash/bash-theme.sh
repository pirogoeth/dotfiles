#!/usr/bin/env bash

THEME_LOADED="yes";         export THEME_LOADED

# This is a script to abstract away / prettify the configuration
# and compilation of my bash theme, which will help make it easier
# to customize in the future.

# NOTE! Colors do NOT need to be escaped, as the string representations
# themselves contain the escapes (see ~L116)
# When I say escaped, I mean with the \[ \] bracket notation used by bash.

# External envvars to control display settings:
#   BT_SHORT -> Use symbolic prompt instead of long context names
#   COLOR_BRACKETING -> Enable/disable color bracketing (use of SOH, STX)
#   NO_COLOR -> Disable prompt coloring

declare -a CONTEXTS
CONTEXTS=( "SSH_CMD" "GIT_CMD" "VENV_CMD" "BATT_CMD" "LAVG_CMD" )

# General settings.
RESET_COLOR="\e[0m"
DIR_COLOR="\e[32m"
CTX_COLOR="\e[32m"

# Battery context settings
BATTERY_IDENT=${BATTERY_IDENT:-"BAT0"}

# Colors to represent regular user vs. root user.
USER_COLOR="\e[32m"
ROOT_COLOR="\e[36m"
FALLBACK_COLOR="\e[31m"

# Theme elements.
SEP_CHAR="|" # Separator
BLC_CHAR="☭" # Beginning of line
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
HOSTNAME_VALUE="$(hostname -s)"

# Special characters.
USER_CHAR="\\u"
HOST_CHAR="\\h"
DIR_CHAR="\\w"
UHSEP_CHAR="@"

# Bash non-visible character escape codes
BASH_SOH='\['
BASH_STX='\]'

ASC_SOH="\001"
ASC_STX="\002"

# Line beginning for wrapped contexts
WRAP_BEGIN=".. "

# Size at which the contexts are shrunk to their "rune" form
SHRINK_THRESHOLD="80"

# Set short form under 80 columns.
COLS_CMD="tput cols"
SCR_COLS="$(${COLS_CMD})"
if [[ "$SCR_COLS" -lt "$SHRINK_THRESHOLD" ]] ; then
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
    _bracket=${3}

    _reset=${RESET_COLOR}

    if [[ -z ${_color} || -z ${_char} ]] ; then
        echo ""
    fi

    if [[ -z ${_bracket} ]] ; then
        _bracket="BASH"
    fi

    if [[ "${_bracket}" == "ASCII" ]] ; then
        _open=${ASC_SOH}
        _close=${ASC_STX}
    elif [[ "${_bracket}" == "BASH" ]] ; then
        _open=${BASH_SOH}
        _close=${BASH_STX}
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
        echo -e "${_open}${_color}${_close}${_char}${_open}${_reset}${_close}"
    else
        echo -e "${_color}${_char}${_reset}"
    fi
}

function expr_eval() {
    _expr=${1}
    echo "$(eval "${_expr}" 2>/dev/null)"
}

function get_curpos() {
    exec < /dev/tty
    oldstty=$(stty -g)
    stty raw -echo min 0
    echo -en "\033[6n" > /dev/tty
    IFS=';' read -r -d R -a pos
    stty $oldstty
    row=$(( ${pos[0]:2} - 1 )); export cur_row
    col=$(( ${pos[1]} - 1 )); export cur_col
}

function str_length() {
    echo $* | \
        tr -d '[[:cntrl:]]' | \
        awk '{ gsub(/\\..?m/, ""); print }' | \
        tr -d '\n\\' | \
        wc -c
}

function real_prompt_len() {
    echo $(( \
        $(str_length "$_static") + \
        $(str_length "$USER") + \
        $(str_length "$HOSTNAME_VALUE") + \
        $(str_length "${PWD//$HOME/\~}") \
    ))
}

function generate_context() {
    # Reset the real terminal width
    eval "SCR_COLS=${COLS_CMD}"

    ctx_len=0
    _real_plen=$(real_prompt_len)

    for (( i=0 ; $i<${#CONTEXTS[@]}; i++ ))
    do
        val="${!CONTEXTS[$i]}"
        # Test the context so we're not outputting empty space.
        if [[ -z "$(echo $(eval ${val}) | tr -d [:space:])" ]] ; then
            continue;
        fi

        line_wrap=0
        ctx_len=$(( ctx_len + $(str_length "$(eval ${val})") - $(str_length "$SEP_CHAR") - 2 ))
        prompt_len=$(( $ctx_len + $_real_plen ))
        if [[ $prompt_len -ge ${SCR_COLS} ]] ; then
            # Screen wrap!
            echo -en "\n${WRAP_BEGIN}"
            line_wrap=1
        fi

        # Print the separator.
        if [[ ${i} < ${#CONTEXTS[@]} && $line_wrap == 0 ]] ; then
            if [[ "${NO_COLOR}" == "YES" ]] ; then
                echo -en "$(ascii_color NONE ${SEP_CHAR} ASCII) "
            else
                echo -en "$(ascii_color ${SEP_COLOR} ${SEP_CHAR} ASCII) "
            fi
        fi

        if [[ "${NO_COLOR}" == "YES" ]] ; then
            echo -en "$(eval ${val}) "
        else
            _tmp="$(eval ${val})"
            echo -en "$(ascii_color ${CTX_COLOR} "${_tmp}" ASCII) "
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
        echo -en "$(ascii_color ${ROOT_COLOR} ${_eop} ASCII)"
    else
        echo -en "$(ascii_color ${USER_COLOR} ${_eop} ASCII)"
    fi
}

function __battery_ps1() {
    _fmt=${1}

    [[ -z "${_fmt}" ]] && _fmt="%s"
    [[ ! -f /sys/class/power_supply/${BATTERY_IDENT}/capacity ]] && return

    _batt_level="$(cat /sys/class/power_supply/${BATTERY_IDENT}/capacity 2>/dev/null)"
    if [[ "$(cat /sys/class/power_supply/${BATTERY_IDENT}/status)" == "Charging" ]] ; then
        _batt_charging="(⚡) "
    else
        _batt_charging=""
    fi

    _batt_status="${_batt_charging}${_batt_level}"

    printf "${_fmt}" "${_batt_status}"
}

function __ssh_ps1() {
    _active_out=${1}

    [[ -z "${_active_out}" ]] && _active_out="SSH"
    ( [[ -z "${SSH_CLIENT}" ]] || \
      [[ -z "${SSH_TTY}" ]] || \
      [[ -z "${SSH_CONNECTION}" ]] ) && return

    printf "%s" "${_active_out}"
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
export -f str_length
export -f __basename_ps1 __generate_uidbased_eop
export -f __battery_ps1 __load_averages_ps1
export -f __ssh_ps1

# Separator.
_SEP="$(ascii_color ${SEP_COLOR} ${SEP_CHAR})"

function bt_export_contexts() {
    export SCR_COLS="$(tput cols)"
    if [[ "$AUTO_SHRINK" == "YES" ]] ; then
        if [[ "$SCR_COLS" -lt "$SHRINK_THRESHOLD" ]] ; then
            BT_SHORT="YES"
        else
            BT_SHORT="NO"
        fi
    fi

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

    export GIT_CMD

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

    export VENV_CMD

    # Settings for battery level context.
    BATT_COLOR="\e[36m"
    BATT_SHORT_SYM="\u2622"
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

    export BATT_CMD

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

    export LAVG_CMD

    # Settings for SSH notification context.
    SSH_COLOR="\e[31m"
    SSH_SHORT_SYM="\u260e"
    if [[ "${NO_COLOR}" == "YES" ]] ; then
        if [[ "${BT_SHORT}" == "YES" ]] ; then
            SSH_CMD="__ssh_ps1 \"${SSH_SHORT_SYM}\""
        else
            SSH_CMD="__ssh_ps1 \"SSH\""
        fi
    else
        if [[ "${BT_SHORT}" == "YES" ]] ; then
            SSH_CMD="__ssh_ps1 \"${SSH_COLOR}${SSH_SHORT_SYM}${RESET_COLOR}\""
        else
            SSH_CMD="__ssh_ps1 \"${SSH_COLOR}SSH${RESET_COLOR}\""
        fi
    fi

    export SSH_CMD
}

export -f bt_export_contexts

bt_export_contexts

trap "bt_export_contexts" WINCH

# Build the colorized dir, hoststring, etc.
_blc="$(ascii_color ${BLC_COLOR} ${BLC_CHAR})"
_uns="$(ascii_color ${UNAME_COLOR} ${USER_CHAR})"
_uhs="$(ascii_color ${UHSEP_COLOR} ${UHSEP_CHAR})"
_hns="$(ascii_color ${HNAME_COLOR} ${HOST_CHAR})"
_dir="$(ascii_color ${DIR_COLOR} ${DIR_CHAR})"
_fb_eop="$(ascii_color ${FALLBACK_COLOR} ${PMT_CHAR})"

GEN_CTX="generate_context 2>/dev/null || echo"
GEN_EOP="__generate_uidbased_eop ${PMT_CHAR} 2>/dev/null || echo -n \"${_fb_eop}\""

# Export the PS1 and backup.
_static="${_blc} ${_uns}${_uhs}${_hns} ${_SEP} ${_dir}"
_PS1="${_static} \$(${GEN_CTX})\n\$(${GEN_EOP}) "; export _PS1
PS1=${_OLD_VIRTUAL_PS1:-${_PS1}}; export PS1; readonly PS1
