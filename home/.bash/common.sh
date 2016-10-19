# common.sh
#
# a bundle of functions to be used wherever

COMMON_LOADED="yes";            export COMMON_LOADED

function __bshu_watson() {
    watson_path="$(which watson)"
    if [[ -z "${watson_path}" ]] ; then
        return 1;
    fi

    # Only kill the agent if this is the only session.
    num_sessions=$(w | grep $USER | grep -E "pts|tty" | wc -l)
    if [[ $num_sessions -gt 1 ]] ; then
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

function __bshu_gpgagent_stop() {
    AGENT_INFO="${HOME}/.gpg-agent-info"

    # Only kill the agent if this is the only session.
    # On some Linuxes, `w` does not show all sessions...
    # It's better to use `ps axno user,tty`
    num_sessions=$(ps axno user,tty | awk '$0 ~ /USER.*/ { next }; $1 == '$UID' && $2 != "?" { print $0 }' | uniq | wc -l)
    if [[ $num_sessions -gt 1 ]] ; then
        return 0;
    fi

    [[ -f ${AGENT_INFO} ]] && \
        source ${AGENT_INFO}

    agent_pid=$(ps aux | grep gpg-agent | grep -v grep | awk '$1 == "'$USER'" {print $2}')
    if [[ -z "${agent_pid}" ]] ; then
        # No agent was found running...?
        return 1;
    fi

    # First, try to gracefully terminate the agent
    gpg_resp=$(gpg-connect-agent killagent /bye)

    agent_pid=$(ps aux | grep gpg-agent | grep -v grep | awk '$1 == "'$USER'" {print $2}')
    if [[ -z "${agent_pid}" ]] ; then
        # No agent is running, graceful kill successful!
        logger -p local0.notice -t gpg-agent "Stopped gpg-agent for ${USER}"
    fi

    # Delete the agent info file, if it exists
    [[ -f ${AGENT_INFO} ]] && rm ${AGENT_INFO}

    # Try to kill the agent pid
    [[ ! -z "${agent_pid}" ]] && kill ${agent_pid} 2>&1 1>/dev/null

    # Check the result and log accordingly
    kill_res="$?"
    if [[ "${kill_res}" != "0" ]] ; then
        logger -p local0.warning -t gpg-agent "Could not stop gpg-agent for ${USER}: error code: ${kill_res}"
        return 2;
    fi

    logger -p local0.notice -t gpg-agent "Killed gpg-agent for ${USER}"

    return 0;
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

bshu_add_func __bshu_gpgagent_stop
bshu_add_func __bshu_watson
