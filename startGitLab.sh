#!/bin/bash

GITLAB_HOST="localhost"
GITLAB_URL="http://$GITLAB_HOST"

function sjekkURL
{
  curl -s -o /dev/null --head --fail "$1"
}

function ventPaaGitLab
{
  printf "$2"
  sjekkURL "$1"
  until [[ $? -eq 0 ]]; do
      printf '.'
      sleep 5
      sjekkURL "$1"
  done
  echo .
}

echo "Sjekker GitLab"
sjekkURL $GITLAB_URL
if [[ $? -ne 0 ]]; then
  echo "Starter GitLab"
  docker run --detach \
    --hostname gitlab.example.com \
    --publish 443:443 --publish 80:80 --publish 22:22 \
    --name gitlab \
    --restart always \
    --volume $GITLAB_HOME/config:/etc/gitlab \
    --volume $GITLAB_HOME/logs:/var/log/gitlab \
    --volume $GITLAB_HOME/data:/var/opt/gitlab \
    --shm-size 256m \
    gitlab/gitlab-ee:latest

  ventPaaGitLab $GITLAB_URL 'Vent til gitlab server kjører .'
fi
