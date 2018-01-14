#!/bin/bash

addHost () {
  domain=$1
  ip=$2

  if [ -z "$domain" ] && [ -z "$ip" ]; then
    exit 1
  fi

  if ! grep -q $domain /etc/hosts; then
    echo "$ip $domain" >> /etc/hosts
  fi
}
