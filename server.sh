#!/usr/bin/env bash

set -Eeuo pipefail
trap _cleanup SIGINT SIGTERM ERR EXIT

BLACK=$(tput -Txterm setaf 0)
RED=$(tput -Txterm setaf 1)
GREEN=$(tput -Txterm setaf 2)
YELLOW=$(tput -Txterm setaf 3)
BLUE=$(tput -Txterm setaf 4)
MAGENTA=$(tput -Txterm setaf 5)
CYAN=$(tput -Txterm setaf 6)
WHITE=$(tput -Txterm setaf 7)
RESET=$(tput -Txterm sgr0)

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  SERVER_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$SERVER_DIR/$SOURCE"
done
export SERVER_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

source "$SERVER_DIR/core/_main.sh"

_usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") ${MAGENTA}[OPTIONS]${RESET} ${BLUE}COMMAND${RESET}

${CYAN}This script aims to manage a home server based on Docker, Docker Compose, Make and Bash.${RESET}

${WHITE}Available options:${RESET}
  ${YELLOW}-h, --help      ${GREEN}Print this help and exit${RESET}

${WHITE}Available commands:${RESET}
  ${YELLOW}install         ${GREEN}Install all services${RESET}
  ${YELLOW}uninstall       ${GREEN}Uninstall all services${RESET}
  ${YELLOW}start           ${GREEN}Start all services${RESET}
  ${YELLOW}stop            ${GREEN}Stop all services${RESET}
  ${YELLOW}restart         ${GREEN}Restart all services${RESET}
  ${YELLOW}status          ${GREEN}Get the status of all services${RESET}
  ${YELLOW}services        ${GREEN}Open a menu based on FZF to manage the services separately${RESET}

EOF
  exit
}

_cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
}

_parse_params() {
  allowed_commands=(install uninstall start stop restart status services)

  while :; do
    case "${1-}" in
    -h | --help) _usage ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  [[ ${#args[@]} -eq 0 ]] && die "Missing script command"
  [[ ! " ${allowed_commands[@]} " =~ " ${args[0]} " ]] && die "Unknown script command '${args[0]}'"

  return 0
}

_check_requirements() {
  DOCKER_EXE=$(/usr/bin/which docker || echo 0)
  checks::executable_check ${DOCKER_EXE} "docker"
  DOCKER_VERSION=$(${DOCKER_EXE} --version | cut -f 3 -d' ' | cut -f 1,2 -d '.');
  checks::version_check ${DOCKER_VERSION} ${MINIMUM_DOCKER_VERSION} "Docker"

  DOCKER_COMPOSE_EXE=$(/usr/bin/which docker-compose || echo 0)
  checks::executable_check ${DOCKER_COMPOSE_EXE} "docker-compose"
  DOCKER_COMPOSE_VERSION="$(${DOCKER_COMPOSE_EXE} --version | cut -f 3 -d' ' | cut -f 1,2 -d '.')";
  checks::version_check ${DOCKER_COMPOSE_VERSION} ${MINIMUM_DOCKER_COMPOSE_VERSION} "Docker Compose"

  MAKE_EXE=$(/usr/bin/which make || echo 0)
  checks::executable_check ${MAKE_EXE} "make"
  MAKE_EXE_VERSION="$(${MAKE_EXE} --version | head -n 1 | cut -f 3 -d' ' | cut -f 1,2 -d '.')";
  checks::version_check ${MAKE_EXE_VERSION} ${MINIMUM_MAKE_VERSION} "Make"
}

_is_enabled() {
  [[ ! -f "$SERVER_DIR/services/$1/.disabled" ]]
}

_install() {
  _check_requirements
  docker network create traefik-network
  for service in "${SERVICES[@]}"
  do
    if _is_enabled $service; then
      make -s -C "$SERVER_DIR/services/$service" install
    fi
  done
}

_uninstall() {
  for service in "${SERVICES[@]}"
  do
    if _is_enabled $service; then
      make -s -C "$SERVER_DIR/services/$service" uninstall
    fi
  done
  docker network rm traefik-network
}

_start() {
  for service in "${SERVICES[@]}"
  do
    if _is_enabled $service; then
      make -s -C "$SERVER_DIR/services/$service" up
    fi
  done
}

_stop() {
  for service in "${SERVICES[@]}"
  do
    if _is_enabled $service; then
      make -s -C "$SERVER_DIR/services/$service" down
    fi
  done
}

_restart() {
  for service in "${SERVICES[@]}"
  do
    if _is_enabled $service; then
      make -s -C "$SERVER_DIR/services/$service" restart
    fi
  done
}

_status() {
  printf "\n%-30s %-10s %-10s\n" "SERVICE" "ENABLED" "STATUS"
  printf "%0.s-" {1..50} && printf "\n"
  for service in "${SERVICES[@]}"
  do
    service_status=$(make -s -C "$SERVER_DIR/services/$service" health)
    output_color=$([[ $service_status == "UP" ]] && echo "\e[32m" || echo "\e[31m")
    status_icon=$([[ $service_status == "UP" ]] && echo "✔" || echo "✖")
    is_enabled=$(_is_enabled $service && echo "YES" || echo "NO")
    printf "$output_color%-30s %-10s %-10s\e[0m\n" $service $is_enabled $status_icon
  done
  printf "%0.s-" {1..50} && printf "\n"
}

_services() {
  for service in "${SERVICES[@]}"
    do
      if _is_enabled $service; then
        services_string+="$(make -pRrq -C "$SERVER_DIR/services/$service" : 2>/dev/null | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ && !/Makefile/ {split($1,A,/ /);for(i in A)print A[i]}' | uniq | sort | awk -v service_prefix="${service} " '{ print service_prefix $0}' || true)\n"
      else
        services_string+="$service enable\n"
      fi
    done
  target=($(echo -e "$services_string" | awk 'NF' | xargs -I % sh -c 'echo %' | fzf --height 50% \
            --preview 'make -s -C "$SERVER_DIR/services/"$(echo {} | cut -d" " -f 1) help'))
  log::note "Executing 'make ${target[1]}' for service '${target[0]}'"
  make -s -C "$SERVER_DIR/services/${target[0]}" ${target[1]}
}

## Global variables ##
SERVICES=($(ls $SERVER_DIR/services))
MINIMUM_DOCKER_VERSION=19.03
MINIMUM_DOCKER_COMPOSE_VERSION=1.25
MINIMUM_MAKE_VERSION=4.2

## Logic ##
_parse_params "$@"

case "${args[0]-}" in
  install) _install ;;
  uninstall) _uninstall ;;
  start) _start ;;
  stop) _stop ;;
  restart) _restart ;;
  status) _status ;;
  services) _services ;;
  -?*) die "Unknown option: $1" ;;
  *) echo "none" ;;
esac

