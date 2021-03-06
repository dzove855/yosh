#!/bin/bash

# Default is tmp 
function tmp::session::start ()
{

    local id="$1"

    touch $TMPDIR/${id}
}

function tmp::session::check ()
{
    [[ -z "${COOKIE[$default_session_name]}" ]] && return 1
    ! [[ -f "$TMPDIR/${COOKIE[$default_session_name]}" ]] && return 1

    return 0
}

function tmp::session::destroy ()
{
    # redirect stderr to dev null if there is a failure, just to be sure :p
    rm "$TMPDIR/${COOKIE[$default_session_name]}" 2>/dev/null
}

function tmp::session::save ()
{
    local key
    # save session array to a file
    for key in "${!SESSION[@]}"
    do
        # always run, remove from file the old value if exist
        sed -i "/SESSION\['$key'\]=.*/d" $TMPDIR/${COOKIE[$default_session_name]}
        echo "SESSION['$key']=\"${SESSION[$key]}\"" >> $TMPDIR/${COOKIE[$default_session_name]}
    done
}

function tmp::session::set ()
{

    tmp::session::save

}

function tmp::session::unset ()
{

    sed -i "/SESSION\['$key'\]=.*/d" $TMPDIR/${COOKIE[$default_session_name]}

}

function tmp::session::read ()
{
    [[ -f "$TMPDIR/${COOKIE[$default_session_name]}" ]] && source $TMPDIR/${COOKIE[$default_session_name]}
}

function tmp::session::get ()
{
    local key="$1"

    [[ -z "$key" ]] && return

    tmp::session::read

    echo "${SESSION[$key]}"
}
