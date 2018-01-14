#!/bin/bash

oneTimeSetUp() {
  source /tools/install-custom-saltstack-repository.sh

  # Verify sourced functions exist
  condition=$(declare -f addAndConfigureRepository configureSaltMasterRoots > /dev/null)
  assertTrue "[ $? = 0 ]"
}

test_clone_repository() {
  cloneRepository "https://github.com/saltstack-formulas/mongodb-formula.git"

  actual=$(ls /srv)
  expected="mongodb-formula"

  assertEquals "$expected" "$actual"
}

test_configure_salt_roots() {
  configureSaltMasterRoots "https://github.com/saltstack-formulas/mongodb-formula.git"

  actual=$(cat /etc/salt/master)
  expected="file_roots:
  base:
    - /srv/monodb-formula/salt

pillar_roots:
  base:
    - /srv/monodb-formula/pillar"

  assertEquals "$expected" "$actual"
}

. /shunit2/shunit2
