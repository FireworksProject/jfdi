if [[ ! -o interactive ]]; then
    return
fi

compctl -K _devbox devbox

_devbox() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(devbox commands)"
  else
    completions="$(devbox completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
