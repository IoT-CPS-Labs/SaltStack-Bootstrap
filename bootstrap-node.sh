#/bin/bash

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

if [ -n "$isMaster" ] && [ -n "$node" ]; then
  echo "Bootstrap Master"
  if [ -n "$generateKey" ] && [ -n "$repository" ]; then
    echo "Create Deploy Key"
  fi
  if [ -n "$repository" ]; then
    echo "Clone Repository"
    echo "Configure SaltMaster Roots"
  fi
elif [ -n "$node" ] && [ -n "$ip" ]; then
  echo "Bootstrap Minion"
else
  usage
  exit 1
fi
