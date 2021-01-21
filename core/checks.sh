#!/usr/bin/env bash

checks::executable_check() {
  local EXE=$1
  local NAME=$2
  if [ "$EXE" == "0" ]; then
      log::error "No '${NAME}' command found"
      exit 1
  fi

  if [ ! -e ${EXE} ]; then
      log::error "'${NAME}' is installed but not executable"
  fi
}

checks::version_check() {
  local VERSION=$1
  local MINIMUM=$2
  local SYSTEM=$3
  local CHECK=`echo "$VERSION>=$MINIMUM" | bc -l`
  if [ "$CHECK" == "0" ]; then
      log::error "'${SYSTEM}' version mismatch, please upgrade"
      exit 1
  fi
}
