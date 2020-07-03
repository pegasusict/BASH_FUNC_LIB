#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools  #      BashFrame #
# (C)2017-2018 Mattijs Snepvangers    #         pegasus.ict@gmail.com #
# License: MIT              #  Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="Header Generator Script"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=1
# VER_PATCH=15
# VER_STATE="ALPHA"
# BUILD=20180807
# LICENSE="MIT"
################################################################################

# mod: pbfl::header
# txt: This script contains functions to generate headers & lines

# fun: header
# txt: generates a complete header
# use: header [$CHAR [$LEN [$SPACER]]]
# opt: $CHAR: defaults to "#"
# opt: $LEN: defaults to 80
# opt: $SPACER: defaults to " "
# api: pbfl::header
header() {
  dbg_pause
  local _CHAR    ;  _CHAR=${1:-#}
  local _LEN    ;  _LEN=${2:-80}
  local _SPACER  ;  _SPACER=${2:-" "}
  local _HEADER  ;  _HEADER="$(make_line "$_CHAR" "$_LEN")\n"
  _HEADER+="$(header_line "$PROGRAM_SUITE" "$SCRIPT_TITLE" "$_CHAR" "$_LEN" "$_SPACER")\n"
  _HEADER+="$(header_line "$COPYRIGHT" "$MAINTAINER_EMAIL" "$_CHAR" "$_LEN" "$_SPACER")\n"
  _HEADER+="$(header_line "$SHORT_VER" "Build $BUILD" "$_CHAR" "$_LEN" "$_SPACER")\n"
  _HEADER+="$(header_line "License: $LICENSE" "Please keep my name in the credits" "$_CHAR" "$_LEN" "$_SPACER")\n"
  _HEADER+="$(make_line $_CHAR $_LEN)\n"
  echo -e "${_HEADER}"
  dbg_restore
}

# fun: header_line
# txt: generates a headerline, eg: # <MAINTAINER>             <MAINTAINEREMAIL> #
# use: header_line  $PART1 $PART2 [$CHAR [$LEN [$SPACER]]]
# opt: $CHAR: defaults to "#"
# opt: $LEN: defaults to 80
# opt: $SPACER: defaults to " "
# api: pbfl::header::internal
header_line() {
  local _PART1    ;  _PART1="$1"
  local _PART2    ;  _PART2="$2"
  local _CHAR      ;  _CHAR=${3:-#}
  local _LEN      ;  _LEN=${4:-80}
  local _SPACER    ;  _SPACER=${5:-" "}
  local _SPACERS    ;  _SPACERS=""
  local _HEADER_LINE  ;  _HEADER_LINE="${_CHAR} ${_PART1}${_SPACERS}${_PART2} ${_CHAR}"
  local _HEADER_LINE_LEN  ;  _HEADER_LINE_LEN=${#_HEADER_LINE}
  local _SPACERS_LEN  ;  _SPACERS_LEN=$((_LEN-_HEADER_LINE_LEN))
  _SPACERS=$( printf "%0.s$_SPACER" $( seq 1 $_SPACERS_LEN ) )
  _HEADER_LINE="${_CHAR} ${_PART1}${_SPACERS}${_PART2} ${_CHAR}"
  echo -e "${_HEADER_LINE}"
}

# fun: make_line
# txt: generates a line
# use: make_line [$CHAR [$LEN]]
# opt: $CHAR: defaults to "#"
# opt: $LEN: defaults to 80
# api: pbfl::header
make_line() {
  local _CHAR    ;  _CHAR=${1:-#}
  local _LEN    ;  _LEN=${2:-80}
  local _LINE    ;  _LINE=$( printf "%0.s$_CHAR" $( seq 1 $_LEN ) )
  echo -e "${_LINE}"
}
