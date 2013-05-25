if [[ ! -o interactive ]]; then
    return
fi

compctl -K _jfd jfd

_jfd() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(jfd commands)"
  else
    completions="$(jfd completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
