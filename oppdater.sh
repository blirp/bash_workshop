#!/bin/bash

function main
{
  tolkKommandolinje "$@"

  if [[ $BRUKER == "annen" ]]; then
    initAnnen
  fi

  while true; do
    RND=$((1 + RANDOM % 6))
    case $RND in
      1)
        nyFil
        ;;
      2)
        lagBranch
        ;;
      3)
        byttBranch
        ;;
      4)
        mergeBranch
        ;;
      *)
        oppdaterFil
        ;;
    esac
    vent $SLEEP
  done
}

function tolkKommandolinje
{
  SLEEP=$1
  if [[ $((SLEEP - 1)) -lt 0 ]]; then
    BRUKER=$1
    SLEEP=$2
  else
    BRUKER=$2
  fi

  if [[ -z $BRUKER ]]; then
    BRUKER="du"
  fi
  if [[ -z $SLEEP ]]; then
    SLEEP=10
  fi

  if [[ $BRUKER != "du" && $BRUKER != "annen" ]]; then
    echo "Ukjent bruker: $BRUKER"
    exit
  fi
}

function initAnnen
{
  rm -rf annen
  git clone http://annen:password@gitlab.kantega.lab/root/Prosjektet.git annen
  cd annen

  git config user.name "Annen Bruker"
  git config user.email "annenbruker@example.com"

  lagBranch
}

function vent
{
  local SEKUNDER=$1
  while [[ $SEKUNDER > 0 ]]; do
    echo -ne "Venter $SEKUNDER \r"
    SEKUNDER=$((SEKUNDER-1))
    sleep 1
  done
  echo -ne "Venter 0\r"
  echo
}

function aktivBranch
{
  git branch --show-current
}

function skrivTil
{
  local FIL=$1
  echo "Skriver til $FIL"
  echo "Tidspunkt: $(date)" >> $FIL
  git add $FIL
  git commit -m "Oppdatering av $FIL i $(aktivBranch)"
  git push
}

function nyFil
{
  local BRANCH=$(aktivBranch | cut -d '/' -f 2)
  local FIL=$(basename $(mktemp -p . -t ${BRANCH}_XXXXXX.md))
  echo "Opprettet fil $FIL"
  skrivTil $FIL
}

function oppdaterFil
{
  local BRANCH=$(aktivBranch | cut -d '/' -f 2)
  local ANTALL=$(ls ${BRANCH}*.md | wc -l)
  if [[ $ANTALL > 0 ]]; then
    local FIL_RND=$((1 + RANDOM % ANTALL))
    local FIL=$(ls ${BRANCH}*.md | head -n $FIL_RND | tail -n 1)
    skrivTil $FIL
  else
    nyFil
  fi
}

function lagBranch
{
  if [[ $BRUKER == "du" ]]; then
    return
  fi
  echo "Lag branch"
  local BRANCH_RND=$((1 + RANDOM % 4))
  if [[ $BRANCH_RND > 2 ]]; then
    git checkout main
  fi

  echo "Lager branch fra $(aktivBranch)"
  local BRANCH=$(basename $(mktemp -p . -t 'XXXXXXXX' -u))
  git checkout -b "branch/$BRANCH"
  git push --set-upstream origin "branch/$BRANCH"
  nyFil
  git branch --all | grep 'remotes.* '
}

function byttBranch
{
  if [[ $BRUKER == "du" ]]; then
    return
  fi

  echo "Bytt branch"
  local ANTALL=$(git branch --all | grep -v 'origin/' | grep -v 'main' | wc -l)
  if [[ $ANTALL > 0 ]]; then
    local BRANCH_RND=$((1 + RANDOM % ANTALL))
    local BRANCH=$(git branch --all | grep -v 'origin/' | grep -v 'main' | head -n $BRANCH_RND | tail -n 1)
    git checkout $BRANCH
    if [[ $? -ne 0 ]]; then
      git checkout main
      byttBranch
    fi
    git branch --all | grep 'remotes.* '
  else
    lagBranch
  fi
}

function mergeBranch
{
  if [[ $BRUKER == "du" ]]; then
    return
  fi

  echo "Merge branch"
  local CURRENT_BRANCH=$(aktivBranch)
  git checkout main
  git pull
  if [[ $? -ne 0 ]]; then
    echo "Merge-konflikt i pull. Avbryter"
    git merge --abort
    exit 1
  fi

  git merge $CURRENT_BRANCH --commit --no-edit

  if [[ $? -ne 0 ]]; then
    echo "Merge-konflikt. Avbryter"
    git merge --abort
    exit 2
  fi
  git push
  git push origin :$CURRENT_BRANCH
  git branch -d $CURRENT_BRANCH

  byttBranch
}

main "$@"