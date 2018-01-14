#!/bin/bash

cloneRepository() {
  gitUrl=$1

  if [ -z "$gitUrl" ]; then
    exit 1
  fi

  cd /srv
  git clone $gitUrl
}

configureSaltMasterRoots() {
  gitUrl=$1
  repository=$(echo "$gitUrl" | grep -o "[^/]*.git$" | tr -d '.git')

  if [ -z "$repository" ]; then
    exit 1
  fi

  mkdir -p /etc/salt
  echo -e "file_roots:\n  base:\n    - /srv/$repository/salt\n" > /etc/salt/master
  echo -e "pillar_roots:\n  base:\n    - /srv/$repository/pillar\n" >> /etc/salt/master
}
