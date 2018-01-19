#!/bin/bash

SUDO="sudo"
DC="docker-compose"
for SUDO_CMD in "gksudo" "kdesudo"; do
    if [ -x  "$(command -v ${SUDO_CMD} )" ]; then
        SUDO=${SUDO_CMD}
        break
    fi
done


if ! [ -x "$(command -v ${DC})" ] ; then
    echo "Will download and install docker-compose (root required)"
    read
    ${SUDO} curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
        && ${SUDO} chmod +x /usr/local/bin/docker-compose
fi

SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" docker-compose up
