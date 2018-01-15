#!/bin/bash

test_bootstrap_master() {
  actual=$(bash /bootstrap-node.sh -m -n salt_master -t)
  expected="Bootstrap Master"

  assertEquals "$expected" "$actual"
}

test_bootstrap_master_with_repo() {
  actual=$(bash /bootstrap-node.sh -m -n salt_master -r git@some-repository.github.com -t)
  expected="Bootstrap Master
Clone Repository
Configure SaltMaster Roots"

  assertEquals "$expected" "$actual"
}

test_bootstrap_master_with_deploy_key_and_repo() {
  actual=$(bash /bootstrap-node.sh -m -n salt_master -d -r git@some-repository.github.com -t)
  expected="Bootstrap Master
Create Deploy Key
Clone Repository
Configure SaltMaster Roots"

  assertEquals "$expected" "$actual"
}

test_bootstrap_minion() {
  actual=$(bash /bootstrap-node.sh -n salt_master -i 10.1.1.1 -t)
  expected="Bootstrap Minion"

  assertEquals "$expected" "$actual"
}

. /shunit2/shunit2
