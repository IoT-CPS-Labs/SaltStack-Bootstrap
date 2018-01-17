#!/bin/bash

bootstrap_master() {
  curl -L https://bootstrap.saltstack.com -o /tmp/install_salt.sh
  sh /tmp/install_salt.sh -P -M -d
}

bootstrap_minion() {
  curl -L https://bootstrap.saltstack.com -o /tmp/install_salt.sh
  sh /tmp/install_salt.sh -P -d
}
