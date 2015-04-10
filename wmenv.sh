unset WMENV_CURRENT_ENVFILE
unset WMENV_WARNING_LAST_PRINTED_IN

function wmenv_debug() {
  if [[ -n "$WMENV_DEBUG" ]]; then
    echo "$1"
  fi
}

function wmenv_load_envfile() {
  local new_envpath="$1" old_envpath="${WMENV_CURRENT_ENVFILE}_unset"
  if [[ -n "$WMENV_CURRENT_ENVFILE" && -e "$old_envpath" ]]; then
    wmenv_debug "Sourcing unset file $old_envpath"
    source "$old_envpath"
  fi

  WMENV_CURRENT_ENVFILE="$new_envpath"

  if [[ -e "$new_envpath" ]]; then
    wmenv_debug "Sourcing $new_envpath"
    source "$new_envpath"
  fi
}

function wmenv_find_nearest() {
  local dir="$PWD/" found target

  if [[ -n "$1" ]]; then
    target="$1"
  else
    target=".wmenv"
  fi

  until [[ -z "$dir" ]]; do
    dir="${dir%/*}"

    found="$dir/$target"

    if [[ -e "$found" ]]; then
      echo "$found"
      return 0
    fi
  done
  return 1
}

function wmenv_current_environment_source() {
  local global_env shell_env local_env envfilepath
  global_env="$(wmenv_global 2>/dev/null)"
  shell_env="$(wmenv_shell 2>/dev/null)"
  local_env="$(wmenv_local 2>/dev/null)"
  if [[ -n "$shell_env" ]]; then
    echo "shell"
  elif [[ -n "$local_env" ]]; then
    envfilepath="$(wmenv_find_nearest .wmenv-local)"
    echo "local ($envfilepath)"
  elif [[ -n "$global_env" ]]; then
    echo "global (~/.wmenv-global)"
  else
    return 1
  fi
}

function wmenv_current_environment() {
  local global_env shell_env local_env
  global_env="$(wmenv_global 2>/dev/null)"
  shell_env="$(wmenv_shell 2>/dev/null)"
  local_env="$(wmenv_local 2>/dev/null)"
  if [[ -n "$shell_env" ]]; then
    echo "$shell_env"
  elif [[ -n "$local_env" ]]; then
    echo "$local_env"
  elif [[ -n "$global_env" ]]; then
    echo "$global_env"
  else
    return 1
  fi
}

function wmenv_shell() {
  local shell_env="${1%%[[:space:]]}"
  if [[ -n "$shell_env" ]]; then
    export WMENV_SHELL_ENV="$shell_env"
    echo "Current shell's environment is now \"$shell_env\""
    wmenv_auto
  else
    # no args, echo current state
    shell_env="${WMENV_SHELL_ENV%%[[:space:]]}"
    if [[ -n "$shell_env" ]]; then
      echo "$shell_env"
      return 0
    else
      >&2 echo "Shell environment isn't set for current session"
      return 1
    fi
  fi
}

function wmenv_global() {
  local global_env="${1%%[[:space:]]}" target_file="$HOME/.wmenv-global"
  if [[ -n "$global_env" ]]; then
    echo "$global_env" > "$target_file"
    echo "Global environment is now \"$global_env\""
    wmenv_auto
    return $?
  else
    # no args, echo current state
    if { read -r global_env <"$target_file"; } 2>/dev/null || [[ -n "$global_env" ]]; then
      global_env="${global_env%%[[:space:]]}"
      echo "$global_env"
      return 0
    else
      >&2 echo "Global environment isn't set"
      return 1
    fi
  fi
}

function wmenv_local() {
  local local_env="${1%%[[:space:]]}" target_file
  if [[ -n "$local_env" ]]; then
    echo "$local_env" > ".wmenv-local"
    echo "Local environment is now \"$local_env\""
    wmenv_auto
    return $?
  else
    # no args, echo current state
    target_file="$(wmenv_find_nearest .wmenv-local)"
    if [[ -n "$target_file" ]] && { read -r local_env <"$target_file"; } 2>/dev/null || [[ -n "$local_env" ]]; then
      local_env="${local_env%%[[:space:]]}"
      echo "$local_env"
      return 0
    else
      >&2 echo "Local environment isn't set"
      return 1
    fi
  fi
}

function wmenv_revert() {
  local current_env
  if [[ $# == 0 ]]; then
    # no specific context given, revert most specific
    current_env="$(wmenv_current_environment_source)"
    if [[ "$current_env" =~ ^shell ]]; then
      # current environment determined by shell, revert it
      wmenv_revert_shell
    elif [[ "$current_env" =~ ^local ]]; then
      # current environment determined by local, revert it
      wmenv_revert_local
    elif [[ "$current_env" =~ ^global ]]; then
      wmenv_revert_global
    else
      >&2 echo "No environment specification found, nothing to revert."
      return 1
    fi
  elif [[ "$1" == "shell" ]]; then
    wmenv_revert_shell
    return $?
  elif [[ "$1" == "local" ]]; then
    wmenv_revert_local
    return $?
  elif [[ "$1" == "global" ]]; then
    wmenv_revert_global
    return $?
  else
    >&2 echo "Unrecognized context '$1'; must be either 'shell', 'local', or 'global'".
    return 1
  fi
}

function wmenv_revert_global() {
  local envfilepath="$HOME/.wmenv-global"
  if [[ -e "$envfilepath" ]]; then
    echo "This will delete $envfilepath"
    read -p "Are you sure? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      rm "$envfilepath"
      if wmenv_auto; then
        echo "Reverted global environment specification. Using $(wmenv_current_environment_source)"
      else
        echo "Reverted global environment, but no other context found."
        echo "Run 'wmenv help' to see how to set one up"
      fi
    fi
  else
    echo "No global environment set, skipping."
    return 1
  fi
}

function wmenv_revert_local() {
  local envfilepath="$(wmenv_find_nearest .wmenv-local)"
  if [[ -n "$envfilepath" ]]; then
    echo "This will delete $envfilepath"
    read -p "Are you sure? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      rm "$envfilepath"
      if wmenv_auto; then
        echo "Reverted local environment specification. Using $(wmenv_current_environment_source)"
      else
        echo "Reverted local environment, but no other context found."
        echo "Run 'wmenv help' to see how to set one up"
      fi
    fi
  else
    echo "No local environment set, skipping."
    return 1
  fi
}

function wmenv_revert_shell() {
  if [[ -n "$WMENV_SHELL_ENV" ]]; then
    unset WMENV_SHELL_ENV
    if wmenv_auto; then
      echo "Reverted shell environment specification. Using $(wmenv_current_environment_source)"
    else
      echo "Reverted shell-specific environment, but no other context found."
      echo "Run 'wmenv help' to see how to set one up"
    fi
  else
    echo "No shell-specific environment set, skipping."
    return 1
  fi
}

function wmenv_info() {
  local current_env="$(wmenv_current_environment)"
  wmenv_auto
  if [[ -z "$current_env" ]]; then
    echo "Environment not set yet; set one with 'wmenv <env>'"
    return 0
  fi
  echo   "Current environment is: $current_env"
  echo   "               Context: $(wmenv_current_environment_source)"
  if [[ -n "$WMENV_CURRENT_ENVFILE" ]]; then
    echo "           Loaded from: ${WMENV_CURRENT_ENVFILE}"
  elif [[ -n "$current_env" ]]; then
    echo "           Loaded from: N/A (no .wmenv/$current_env file present in current directory or any of its parents)"
  fi
}

function wmenv_help() {
  cat << EOF
Usage: wmenv <command> [<args>]

Available wmenv commands are:
  info                    Show the current environment and its origin
  global [ENVIRONMENT]    Set or show the global environment
  local [ENVIRONMENT]     Set or show the current directory-specific environment
  shell [ENVIRONENT]      Set or show the current shell-specific enviroment
  revert                  Unsets the current environment specification
  [ENVIRONMENT]           Shortcut for "wmenv shell [ENVIRONMENT]"

<command> defaults to "info"

EOF
}

function wmenv() {
  if [[ "$#" == "0" || "$1" == "info" ]]; then
    wmenv_info
    return $?
  elif [[ "$1" == "help" || "$1" == "--help" || "$1" == "-h" ]]; then
    wmenv_help
    return $?
  elif [[ "$1" == "global" ]]; then
    shift
    wmenv_global $@
    return $?
  elif [[ "$1" == "local" ]]; then
    shift
    wmenv_local $@
    return $?
  elif [[ "$1" == "revert" ]]; then
    shift
    wmenv_revert $@
    return $?
  elif [[ "$1" == "shell" ]]; then
    shift
  fi

  wmenv_shell $@
}

function wmenv_reset() {
  local prior_unsetpath="${WMENV_CURRENT_ENVFILE}_unset"
  if [[ -e "$prior_unsetpath" ]]; then
    wmenv_debug "Sourcing unset file $prior_unsetpath"
    source "$prior_unsetpath"
  fi
  unset WMENV_CURRENT_ENVFILE
}

function wmenv_print_warning() {
  if [[ "$WMENV_WARNING_LAST_PRINTED_IN" != "$1" ]]; then
    WMENV_WARNING_LAST_PRINTED_IN="$1"

    >&2 echo "$2"
  fi
}

function wmenv_auto() {
  local parent_dir envpath envfilename

  parent_dir="$(wmenv_find_nearest .wmenv)"

  # check if environment has corresponding file in parent_dir
  if [[ $? == 0 ]]; then
    envfilename="$(wmenv_current_environment)"
    if [[ $? != 0 ]]; then
      wmenv_print_warning "$parent_dir" "Can't determine environment; please run \"wmenv help\" to get going"
      return 1
    fi

    envpath="$parent_dir/$envfilename"

    # check that env file exists
    if [[ ! -e "$envpath" ]]; then
      wmenv_print_warning "$parent_dir" "WARNING: wmenv cannot resolve environment \"$envfilename\""
      wmenv_reset
      return 1
    else
      if [[ "$envpath" == "$WMENV_CURRENT_ENVFILE" ]]; then return
      else
        wmenv_load_envfile "$envpath"
        return $?
      fi
    fi
  else
    wmenv_reset
  fi
}

function wmenv_handler() {
  local command
  if [[ -n "$ZSH_VERSION" ]]; then
    command="${history[$HISTCMD]}"
  elif [[ -n "$BASH_VERSION" ]]; then
    command="$BASH_COMMAND"
  fi
  if [[ "$command" =~ ^wmenv( .*)?$ ]]; then return
  else
    wmenv_auto
  fi
}

if [[ -n "$ZSH_VERSION" ]]; then
  zmodload zsh/parameter
  if [[ ! "$preexec_functions" == *wmenv_handler* ]]; then
    preexec_functions+=("wmenv_handler")
  fi
elif [[ -n "$BASH_VERSION" ]]; then
  trap '[[ "$BASH_COMMAND" != "$PROMPT_COMMAND" ]] && wmenv_handler' DEBUG
fi
