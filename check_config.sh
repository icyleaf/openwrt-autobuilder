#!/bin/bash

FILE="$1"

ABORT_ON_ERROR='false'
function validate_config() {
  local file=$1
  echo "  Enter ${file} file"
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
  done < $file
}

echo "Checking .config"
validate_config $CONFIG_FILE
validate_config $FILE

if [[ "$ABORT_ON_ERROR" == 'true' ]]; then
  echo 'Fail and exit run action.'
  exit 1
fi

echo "Well done, All passed."
