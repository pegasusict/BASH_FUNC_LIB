#!/bin/bash -p
################################################################################
# Pegasus' Linux Administration Tools  #      BashFrame #
# (C)2017-2018 Mattijs Snepvangers    #         pegasus.ict@gmail.com #
# License: MIT              #  Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="Process Mutex Lock Script"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=0
# VER_PATCH=7
# VER_STATE="PRE-ALPHA"
# BUILD=20180710
# LICENSE="MIT"
################################################################################

do_mutex() {
  # lock dirs/files
  LOCKDIR="/tmp/PLAT-lock"
  PIDFILE="${LOCKDIR}/PID"

  # exit codes and text
  ENO_SUCCESS=0  ;  ETXT[0]="ENO_SUCCESS"
  ENO_GENERAL=1  ;  ETXT[1]="ENO_GENERAL"
  ENO_LOCKFAIL=2  ;  ETXT[2]="ENO_LOCKFAIL"
  ENO_RECVSIG=3  ;  ETXT[3]="ENO_RECVSIG"

  ###
  ### start locking attempt
  ###

  trap 'ECODE=$?; echo "[PLAT mutex] Exit: ${ETXT[ECODE]}($ECODE)" >&2' 0
  echo -n "[PLAT mutex] Locking: " >&2

  if mkdir "${LOCKDIR}" &>/dev/null; then

    # lock succeeded, install signal handlers before storing the PID just in case
    # storing the PID fails
    trap 'ECODE=$?;
        echo "[PLAT mutex] Removing lock. Exit: ${ETXT[ECODE]}($ECODE)" >&2
        rm -rf "${LOCKDIR}"' 0
    echo "$$" >"${PIDFILE}"
    # the following handler will exit the script upon receiving these signals
    # the trap on "0" (EXIT) from above will be triggered by this trap's "exit" command!
    trap 'echo "[PLAT mutex] Killed by a signal." >&2
        exit ${ENO_RECVSIG}' 1 2 3 15
    echo "success, installed signal handlers"

  else

    # lock failed, check if the other PID is alive
    OTHERPID="$(cat "${PIDFILE}")"

    # if cat isn't able to read the file, another instance is probably
    # about to remove the lock -- exit, we're *still* locked
    #  Thanks to Grzegorz Wierzowiecki for pointing out this race condition on
    #  http://wiki.grzegorz.wierzowiecki.pl/code:mutex-in-bash
    if [ $? != 0 ]; then
      echo "lock failed, PID ${OTHERPID} is active" >&2
      exit ${ENO_LOCKFAIL}
    fi

    if ! kill -0 $OTHERPID &>/dev/null; then
      # lock is stale, remove it and restart
      echo "removing stale lock of nonexistant PID ${OTHERPID}" >&2
      rm -rf "${LOCKDIR}"
      echo "[PLAT mutex] restarting myself" >&2
      exec "$0" "$@"
    else
      # lock is valid and OTHERPID is active - exit, we're locked!
      echo "lock failed, PID ${OTHERPID} is active" >&2
      exit ${ENO_LOCKFAIL}
    fi

  fi
}
