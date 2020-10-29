#!/bin/bash

cmds=()

for cmd in autoconf automake libtool
do
  if ! command -v $cmd &> /dev/null
  then
    cmds+=("$cmd")
  fi
done

if [ ${#cmds[@]} -ne 0 ];
then
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    apt-get update
    apt-get install -y ${cmds[@]}
  else
    brew install ${cmds[@]}
  fi
fi
