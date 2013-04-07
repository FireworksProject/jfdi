if [[ ! -o interactive ]]; then
    return
fi

compctl -K _remote remote

_remote() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(remote commands)"
  else
    completions="$(remote completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
