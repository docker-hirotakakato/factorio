#!/bin/bash -eux

file=.github/cache/file

[[ -f $file ]] || install -m 644 -D /dev/null $file

eval "$(cat $file)"
new=$(curl -fSs https://factorio.com/get-download/latest/headless/linux64 | sed 's/^.*factorio_headless_x64_\(.*\)\.tar\.xz.*$/\1/p' -n)

if ! [[ "${cache:-}" == "$new" ]]; then
  curl -fSso /dev/null -X POST $trigger
  echo "cache=$new" > $file
fi
