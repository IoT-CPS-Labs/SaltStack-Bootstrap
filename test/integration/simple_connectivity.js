#!/bin/bash

oneTimeSetUp() {
  service salt-master start
  service salt-minion start

  #Wait for salt-master to start and receive connections from minions
  sleep 60
}

test_salt_minions_auto_connection() {
  actual=$(salt-key)
  expected="Accepted Keys:
Denied Keys:
Unaccepted Keys:
salt_master
salt_minion
Rejected Keys:"

  assertEquals "Automatic Connection" "$expected" "$actual"
}

test_salt_accept_master() {
  actual=$(salt-key -a 'salt_master' -y)
  expected="The following keys are going to be accepted:
Unaccepted Keys:
salt_master
Key for minion salt_master accepted."

  assertEquals "Accept Master" "$expected" "$actual"
}

test_salt_accept_minion() {
  actual=$(salt-key -a 'salt_minion' -y)
  expected="The following keys are going to be accepted:
Unaccepted Keys:
salt_minion
Key for minion salt_minion accepted."

  assertEquals "Accept Salt_Minion" "$expected" "$actual"

  # Wait for keys to be processed
  sleep 20
}

test_salt_ping() {
  actual=$(salt '*' test.ping)
  expected="salt_minion:
    True
salt_master:
    True"

  assertEquals "$expected" "$actual"
}

. /shunit2/shunit2
