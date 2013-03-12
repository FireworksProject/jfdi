_devbox() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(devbox commands)" -- "$word") )
  else
    local command="${COMP_WORDS[1]}"
    local completions="$(devbox completions "$command")"
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -F _devbox devbox
