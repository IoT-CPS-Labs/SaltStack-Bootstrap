#!/bin/bash

oneTimeSetUp() {
  source /tools/configure-host.sh

  # Verify addHost function exists
  condition=$(declare -f addHost > /dev/null)
  assertTrue "[ $? = 0 ]"
}

test_add_host_success() {
  domain="master.saltstack.com"
  ip="10.1.1.1"

  # Verify domain is not in /etc/hosts
  condition=$(grep -q $domain /etc/hosts)
  assertTrue "[ $? = 1 ]"

  addHost "$domain" "$ip"

  # Verify host is added
  condition=$(grep -q $domain /etc/hosts)
  assertTrue "[ $? = 0 ]"

  # Verify last line of /etc/hosts contains the ip and the domain
  condition=$(grep "." /etc/hosts | tail -n1)
  echo $condition | grep "$ip" | grep -q "$domain"
  assertTrue "[ $? = 0 ]"
}

test_add_host_no_arguments() {
  condition=$(addHost)
  assertTrue "[ $? = 1 ]"
}

test_add_host_one_argument() {
  domain="master.saltstack.com"

  condition=$(addHost "$domain")
  assertTrue "[ $? = 1 ]"
}

. /shunit2/shunit2
