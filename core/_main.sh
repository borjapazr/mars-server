#!/usr/bin/env bash

if ! ${SERVER_MAIN_SOURCED:-false}; then
  for file in $SERVER_DIR/core/{checks,log}.sh; do
    source "$file";
  done;
  unset file;

  readonly SERVER_MAIN_SOURCED=true
fi
