# common.sh
#
# a bundle of functions to be used wherever

COMMON_LOADED="YES";            export COMMON_LOADED

function __bshu_watson() {
    watson_path="$(which watson)"
    if [[ -z "${watson_path}" ]] ; then
        return 1;
    fi

    ## Make sure this is the only session left before stopping
    _num_sessions="$(w | grep ${USER} | wc -l)"
    if [[ "${_num_sessions}" != "1" ]] ; then
        return 0;
    fi

    _status="$(${watson_path} status | tr -d '\n')"
    if [[ "${_status}" == "No project started" ]] ; then
        return 0;
    fi

    if [[ ! -z "$(which logger)" ]] ; then
        logger -p local0.warning -t watson "${USER} forgot to stop all Watson projects!"
    fi

    ${watson_path} stop
    if [[ "$?" != 0 ]] ; then
        logger -p local0.warning -t watson "Something happened while stopping projects for ${USER}.."
    else
        logger -p local0.notice -t watson "Stopped projects for ${USER}."
    fi
}

function unworkon() {
    # Check that deactivate() is defined.
    _defined="$(type deactivate | head -n 1 | grep -q "function" 2>/dev/null)"
    if [[ ! -z ${_defined} ]] ; then
        deactivate 2>&1 1>/dev/null
    fi

    if [[ ! -z "${VIRTUAL_ENV}" ]] ; then
        unset VIRTUAL_ENV
    fi

    if [[ ! -z "${__PATH}" ]] ; then
        unset PATH
        export PATH="${__PATH}"
    fi
}

bshu_add_func __bshu_watson
