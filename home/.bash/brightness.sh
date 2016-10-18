#!/usr/bin/env bash
# -*- coding: utf-8 -*-

#
# adjust monitor brightness via CLI
#

DEFAULT_STEP=5

refscript="${0##*/}"
case "${refscript}" in
    "kbdlight.sh")
        BACKLIGHT_CLASS=${KBD_BACKLIGHT_CLASS:-"smc::kbd_backlight"}
        b_path="/sys/class/leds/${BACKLIGHT_CLASS}"
        ;;
    *)
        BACKLIGHT_CLASS=${BACKLIGHT_CLASS:-"intel_backlight"}
        b_path="/sys/class/backlight/${BACKLIGHT_CLASS}"
        ;;
esac

if [[ ! -d ${b_path} ]] ; then
    echo " [-] Backlight class does not exist at ${b_path}"
    exit 1
fi

cur_brightness="$(< ${b_path}/brightness)"
max_brightness="$(< ${b_path}/max_brightness)"

if [[ -z "$1" ]] ; then
    echo "brightness: ${cur_brightness}"
    echo "max brightness: ${max_brightness}"
    exit 0
else
    if [[ "$(echo $1 | cut -b 1)" == "+" ]] ; then
        # Increase brightness
        amount="$(echo $1 | cut -b 2-)"
        if [[ -z "${amount}" ]] ; then
            amount=${DEFAULT_STEP}
        fi

        new_brightness=$(( ${cur_brightness} + ${amount} ))
        if [[ ${new_brightness} -gt ${max_brightness} ]] ; then
            echo " [!] new brightness > ${max_brightness}"
            exit 1
        else
            sudo chmod 646 ${b_path}/brightness
            echo "${new_brightness}" > ${b_path}/brightness
            if [[ $? != 0 ]] ; then
                echo " [-] Could not write brightness to ${b_path}/brightness"
                exit 1
            fi
            echo "brightness: ${new_brightness}"
            exit 0
        fi
    elif [[ "$(echo $1 | cut -b 1)" == "-" ]] ; then
        # Decrease brightness
        amount="$(echo $1 | cut -b 2-)"
        if [[ -z "${amount}" ]] ; then
            amount=${DEFAULT_STEP}
        fi

        new_brightness=$(( ${cur_brightness} - ${amount} ))
        if [[ ${new_brightness} -lt 0 ]] ; then
            echo " [!] new brightness < 0"
            exit 1
        else
            sudo chmod 646 ${b_path}/brightness
            echo "${new_brightness}" > ${b_path}/brightness
            if [[ $? != 0 ]] ; then
                echo " [-] Could not write brightness to ${b_path}/brightness"
                exit 1
            fi
            echo "brightness: ${new_brightness}"
            exit 0
        fi
    elif [[ " $(echo $1 | cut -b 1)" == "=" ]] ; then
        # Set brightness
        amount="$(echo $1 | cut -b 2-)"
        if [[ -z "${amount}" ]] ; then
            echo " [-] Provide a brightness level when using '='"
            exit 1
        fi

        new_brightness=$(( ${amount} ))
        if [[ ${new_brightness} -lt 0 ]] ; then
            echo " [!] new brightness < 0"
            exit 1
        elif [[ ${new_brightness} -gt ${max_brightness} ]] ; then
            echo " [!] new brightness > ${max_brightness}"
            exit 1
        else
            sudo chmod 646 ${b_path}/brightness
            echo "${new_brightness}" > ${b_path}/brightness
            if [[ $? != 0 ]] ; then
                echo " [-] Could not write brightness to ${b_path}/brightness"
                exit 1
            fi
            echo "brightness: ${new_brightness}"
            exit 0
        fi
    fi
fi

