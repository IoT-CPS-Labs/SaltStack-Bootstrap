#!/bin/bash

createDeployKey() {
  ssh-keygen -t rsa -b 4096 -C "SaltStack - Repository" -f $HOME/.ssh/saltkey -q -N ""
  echo -e "\nHost github.com\n IdentityFile ~/.ssh/saltkey" >> $HOME/.ssh/config
}

cloneRepository() {
  gitUrl=$1

  if [ -z "$gitUrl" ]; then
    exit 1
  fi

  ssh -o StrictHostKeyChecking=no git@github.com

  cd /srv
  git clone $gitUrl
}

configureSaltMasterRoots() {
  gitUrl=$1
  repository=$(echo "$gitUrl" | grep -o "[^/]*.git$" | sed 's/.git$//g')

  if [ -z "$repository" ]; then
    exit 1
  fi

  mkdir -p /etc/salt
  echo -e "file_roots:\n  base:\n    - /srv/$repository/salt\n" > /etc/salt/master
  echo -e "pillar_roots:\n  base:\n    - /srv/$repository/pillar\n" >> /etc/salt/master
}
