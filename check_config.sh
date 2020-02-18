#!/bin/bash

echo "Checking .config"
ABORT_ON_ERROR='false'
while IFS= read -r line
do
  if [[ -n $line ]]; then
    config=`echo $line | grep '^CONFIG'`
    if [[ -n $config ]]; then
      has_config=`cat openwrt/.config | grep $line`
      if [[ -z $has_config ]]; then
        echo "Missing config: $config"
        ABORT_ON_ERROR='true'
      fi
    fi
  fi
done < $CONFIG_FILE

if [[ "$ABORT_ON_ERROR" == 'true' ]]; then
  echo 'Fail and exit run action.'
  exit 1
fi
