#!/bin/bash

usage() {
  echo -n "-------- Bootstrap Master --------

usage (bootstrap master):
  bash bootstrap-node.sh [-m] [-n <string>]

Arguments:
  -m:               Indicates the master node bootstrap configuration is being used.
  -n (node_type):   The SaltMinion name that will be assigned to the master node.

Example Command:
  bash install-node.sh -m -n salt_master

-------- Bootstrap Minion -------

usage (bootstrap minion):
  bash install-node.sh [-n <string>] [-i <string>] [-r <string> (optional)] [-d (optional)]

Arguments:
  -n (node_type):   The SaltMinion name that will be assigned to the node.
  -i (ip_address):  The ip address of the Salt master node.
  -r (repository):  The git url to a Salt formula repository.
  -d:               An argument that indicates whether a deployment key needs to be generated for a private repoitory.


Example Command (for a minion node like the swarm manager):
  bash bootstrap-node.sh -n swarm_manager_1 -i 10.1.41.1 -r git@github.com:alanrossx2/SaltStack-Bootstrap.git -d
"
}

while getopts "mn:i:r:dt" args; do
  case "${args}" in
    m)
      isMaster=true
      ;;
    n)
      node=${OPTARG}
      ;;
    i)
      ip=${OPTARG}
      ;;
    r)
      repository=${OPTARG}
      ;;
    d)
      generateKey=true
      ;;
    t)
      testmode=true
      ;;
  esac
done

domain="master.saltstack.com"

if [ -n "$testmode" ]; then
  eval "$(curl https://raw.githubusercontent.com/alanrossx2/SaltStack-Bootstrap/master/tools/mock-tools.sh)"
else
  eval "$(curl https://raw.githubusercontent.com/alanrossx2/SaltStack-Bootstrap/master/tools/configure-host.sh)"
  eval "$(curl https://raw.githubusercontent.com/alanrossx2/SaltStack-Bootstrap/master/tools/install-custom-saltstack-repository.sh)"
  eval "$(curl https://raw.githubusercontent.com/alanrossx2/SaltStack-Bootstrap/master/tools/install-saltstack.sh)"
fi

if [ -n "$isMaster" ] && [ -n "$node" ]; then
  if [ -n "$generateKey" ] && [ -n "$repository" ]; then
    createDeployKey
    waitForUserToCopyDeployKey
  fi
  if [ -n "$repository" ]; then
    cloneRepository $repository
    configureSaltMasterRoots $repository
  fi
  addHost $domain "127.0.0.1"
  configureMasterHost
  configureMinionId $node
  bootstrap_master
elif [ -n "$node" ] && [ -n "$ip" ]; then
  addHost $domain $ip
  configureMasterHost
  configureMinionId $node
  bootstrap_minion
else
  usage
  exit 1
fi
