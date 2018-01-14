#!/bin/bash

oneTimeSetUp() {
  source /tools/install-custom-saltstack-repository.sh

  # Verify sourced functions exist
  condition=$(declare -f createDeployKey cloneRepository configureSaltMasterRoots > /dev/null)
  assertTrue "[ $? = 0 ]"
}

test_create_deploy_key() {
  createDeployKey

  actual=$(head -n 1 ~/.ssh/saltkey)
  expected="-----BEGIN RSA PRIVATE KEY-----"
  assertEquals "$expected" "$actual"

  actual=$(tail -n 1 ~/.ssh/saltkey)
  expected="-----END RSA PRIVATE KEY-----"
  assertEquals "$expected" "$actual"

  actual=$(cat ~/.ssh/saltkey)
  expected="
Host github.com
 IdentityFile ~/.ssh/saltkey
"
}

test_clone_repository() {
  # Swap generated deploy key with hardcoded test key
  mkdir -p ~/.ssh
  cp /test/test-saltkey ~/.ssh/saltkey
  cp /test/test-saltkey.pub ~/.ssh/saltkey.pub

  cloneRepository "git@github.com:alanrossx2/SaltStack-Bootstrap.git"

  actual=$(ls /srv)
  expected="SaltStack-Bootstrap"

  assertEquals "$expected" "$actual"
}

test_configure_salt_roots() {
  configureSaltMasterRoots "git@github.com:alanrossx2/SaltStack-Bootstrap.git"

  actual=$(cat /etc/salt/master)
  expected="file_roots:
  base:
    - /srv/SaltStack-Bootstrap/salt

pillar_roots:
  base:
    - /srv/SaltStack-Bootstrap/pillar"

  assertEquals "$expected" "$actual"
}

. /shunit2/shunit2
