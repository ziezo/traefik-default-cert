#!/bin/bash

function copy_files {
  IFS=':' read -r -a array <<< "$2"
  for fn in "${array[@]}"
  do
    echo "cp $1 $fn"
    cp "$1" "$fn"
    echo "chmod 644 $fn"
    chmod 644 "$fn"
  done
}

copy_files /cert/fullchain.pem "${COPY_FULLCHAIN}"
copy_files /cert/privkey.pem "${COPY_PRIVKEY}"
copy_files /cert/chain.pem "${COPY_CHAIN}"
copy_files /cert/cert.pem "${COPY_CERT}"

if [ -n "$RESTART" ] ; then
  echo docker restart $RESTART
  docker restart $RESTART
fi

