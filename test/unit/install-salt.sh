#!/bin/bash

oneTimeSetUp() {
  source /tools/install-saltstack.sh

  # Verify sourced functions exist
  condition=$(declare -f bootstrap_master bootstrap_minion > /dev/null)
  assertTrue "[ $? = 0 ]"
}

skip_test_install_minion() {
  bootstrap_minion

  which salt-master
  assertTrue "[ $? = 1 ]"

  which salt-minion
  assertTrue "[ $? = 0 ]"
}

skip_test_install_master() {
  bootstrap_master

  which salt-master
  assertTrue "[ $? = 0 ]"

  which salt-minion
  assertTrue "[ $? = 0 ]"
}

. /shunit2/shunit2
