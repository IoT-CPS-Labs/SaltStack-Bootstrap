#!/bin/bash

addHost () {
  domain=$1
  ip=$2

  if [ -z "$domain" ] || [ -z "$ip" ]; then
    exit 1
  fi

  if ! grep -q $domain /etc/hosts; then
    echo "$ip $domain" >> /etc/hosts
  fi
}

configureMasterHost() {
  echo -e "master: master.saltstack.com" >> /etc/salt/minion
}

configureMinionId() {
  minion_id=$1
  echo -e "$minion_id" >> /etc/salt/minion_id
}
