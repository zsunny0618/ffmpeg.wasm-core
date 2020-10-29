#!/bin/bash

missingCmds=()

for cmd in autoconf libtool
do
  if ! command -v $cmd &> /dev/null
  then
    missingCmds+=("$cmd")
  fi
done

if [ ${#missingCmds[@]} -ne 0 ];
then
  echo "Install missing dependencies"
  apt-get update
  apt-get install -y ${missingCmds[@]}
fi
