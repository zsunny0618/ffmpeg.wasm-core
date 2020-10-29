#!/bin/bash

cmds=(autoconf libtool)

# for cmd in autoconf libtool
# do
#   if ! command -v $cmd &> /dev/null
#   then
#     missingCmds+=("$cmd")
#   fi
# done

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  apt-get update
  apt-get install -y ${cmds[@]}
else
  brew install ${cmds[@]}
fi
