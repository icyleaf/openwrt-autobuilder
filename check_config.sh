#!/bin/bash


ABORT_ON_ERROR='false'
function validate_config() {
  FILE=$1
  echo "  Enter ${FILE} file"
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
  done < $FILE
}

echo "Checking .config"
validate_config $CONFIG_FILE
validate_config "common.config"

if [[ "$ABORT_ON_ERROR" == 'true' ]]; then
  echo 'Fail and exit run action.'
  exit 1
fi

echo "Well done, All passed."
