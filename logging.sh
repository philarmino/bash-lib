 #!/usr/bin/env bash
: "${BASH_LIB_DIR:?BASH_LIB_DIR must be set. Please source bash-lib/init before other scripts from bash-lib.}"

export BASH_LIB_LOG_LEVEL=info

# Add logging functions here

function bl_announce() {
  echo "++++++++++++++++++++++++++++++++++++++"
  echo " "
  echo "$@"
  echo " "
  echo "++++++++++++++++++++++++++++++++++++++"
}

function bl_check_log_level(){
  local level="${1}"
  if [[ ${level} =~ debug|info|warn|error|fatal ]];
  then
    return 0
  else
    echo "${level} is not a valid BASH_LIB_LOG_LEVEL, it should be debug|info|warn|error|fatal"
    return 1
  fi
}

function bl_log {
  declare -A BASH_LIB_LOG_LEVELS=( [debug]=1 [info]=2 [warn]=3 [error]=4 [fatal]=5 )
  declare -A BASH_LIB_LOG_COLOURS=( [debug]="0;37;40" [info]="0;36;40" [warn]="0;33;40" [error]="1;31;40" [fatal]="1;37;41" )
  local runtime_log_level="${BASH_LIB_LOG_LEVEL}"
  local write_log_level="${1}"
  local msg="${2}"
  local out="${3:-stdout}"

  bl_check_log_level "${runtime_log_level}"
  bl_check_log_level "${write_log_level}"

  local runtime_level_num="${BASH_LIB_LOG_LEVELS[${runtime_log_level}]}"
  local write_level_num="${BASH_LIB_LOG_LEVELS[${write_log_level}]}"

  if (( write_level_num < runtime_level_num )); then
    return
  fi

  if [[ "${out}" == "stderr" ]]; then
    echo -e "\e[${BASH_LIB_LOG_COLOURS[${write_log_level}]}m${msg}\e[0m" 1>&2
  else
    echo -e "\e[${BASH_LIB_LOG_COLOURS[${write_log_level}]}m${msg}\e[0m"
  fi
}

function bl_debug(){
  bl_log debug "${*}"
}

function bl_info(){
  bl_log info "${*}"
}

function bl_warn(){
  bl_log warn "${*}"
}

function bl_error(){
  bl_log error "${*}"
}

function bl_fatal(){
  bl_log fatal "${*}"
}
