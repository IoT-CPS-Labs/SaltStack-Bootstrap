#/bin/bash

usage() {
  echo -n "usage: bash install-node.sh [-n <string>] [-i <string> (optional)] [-r <string> (optional)] [-d (optional)]

Arguments:
  -n (node_type):   The Salt name that will be assigned to the node.
  -i (ip_address):  The ip address of the Salt master node.
  -r (repository):  The git url to a Salt formula repository
  -d:               If set creates a deployment key to add to the repository. Use this argument if the repository is private.

Example Command (for the master node):
  bash install-node.sh -n master

Example Command (for a minion node like the swarm manager):
  bash install-node.sh -n swarm_manager_1 -i 10.1.41.1 -r git@github.com:alanrossx2/SaltStack-Bootstrap.git -d
"
}

while getopts ":n:i:r:d" args; do
  case "${args}" in
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
      deployKey=true
      ;;
  esac
done

if [ -z "$node" ]; then
  usage
  exit 1
fi

if [ -z "$ip" ] && [ "$node" != "master" ]; then
  usage
  exit 1
fi
