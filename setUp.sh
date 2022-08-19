#!/bin/bash

export GITLAB_HOME=$PWD

GITLAB_HOST="localhost"
GITLAB_URL="http://$GITLAB_HOST"

./startGitLab.sh

PASSORD=$(docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password | tr '\r' '\n' | awk '{print $2}')

TOKEN_DATA="{\"grant_type\":\"password\", \"username\":\"root\", \"password\":\"$PASSORD\"}"
TOKEN_JSON=$(curl -s -X POST -H 'Content-type: application/json' -d "$TOKEN_DATA" "$GITLAB_URL/oauth/token")
TOKEN=$(echo "$TOKEN_JSON" | jq '.access_token' -r)

if [[ -n $TOKEN ]]; then
  echo "Token: $TOKEN"
fi

BRUKER_IDS=$(curl -s -X GET -H "Authorization: Bearer $TOKEN" "$GITLAB_URL/api/v4/users" | jq '.[].id')

for a in $BRUKER_IDS; do
  if [[ $a != "1" ]]; then
    echo "Sletter bruker $a"
    curl -s -X DELETE -H "Authorization: Bearer $TOKEN" "$GITLAB_URL/api/v4/users/$a"
  fi
done

printf 'Venter på at brukerne er slettet'
until [[ -z $(curl -s -X GET -H "Authorization: Bearer $TOKEN" "$GITLAB_URL/api/v4/users" | jq '.[].username' | grep -v 'root' | grep -v 'ghost') ]]; do
  echo -en '.'
  sleep 0.1
done
echo .

echo "Oppretter buker 'du'"
DEG_ID=$(curl -s -X POST -H "Authorization: Bearer $TOKEN" -H 'Content-type: application/json' -d '{"email":"degselv@example.com", "name": "Deg Selv", "username": "du", "password": "password", "skip_confirmation": true}' $GITLAB_URL/api/v4/users  | jq '.id')
echo "Oppretter buker 'annen'"
ANNEN_ID=$(curl -s -X POST -H "Authorization: Bearer $TOKEN" -H 'Content-type: application/json' -d '{"email":"annenbruker@example.com", "name": "Annen Bruker", "username": "annen", "password": "password", "skip_confirmation": true}' $GITLAB_URL/api/v4/users  | jq '.id')

function hentProsjektet
{
  curl -s -X GET -H "Authorization: Bearer $TOKEN" "$GITLAB_URL/api/v4/projects/root%2fProsjektet"
}

PROSJEKT_FINNES=$(hentProsjektet | jq '.id')
if [[ -n $PROSJEKT_FINNES ]]; then
  printf "Sletter Prosjektet"
  curl -s -o /dev/null -X DELETE -H "Authorization: Bearer $TOKEN" "$GITLAB_URL/api/v4/projects/root%2fProsjektet"
fi

function opprettProsjekt
{
  curl -s -X POST -H "Authorization: Bearer $TOKEN" -H 'Content-type: application/json' -d '{"name":"Prosjektet", "initialize_with_readme": true, "visibility": "public"}' $GITLAB_URL/api/v4/projects
}

echo "Oppretter Prosjektet"
PROSJEKT_ID=$(opprettProsjekt | jq '.id')
printf 'Venter på at Prosjektet skal opprettes'
until [[ $(hentProsjektet | jq '.message') == "null" ]]; do
  printf '.'
  sleep 1
  PROSJEKT_ID=$(opprettProsjekt | jq '.id')
done
echo .
echo "ProsjektID: $PROSJEKT_ID"

sleep 1

echo "Slår av beskyttelse på 'main'"
curl -s -o /dev/null -X DELETE -H "Authorization: Bearer $TOKEN" "$GITLAB_URL/api/v4/projects/$PROSJEKT_ID/protected_branches/main"

echo "Legger til brukere på prosjektet"
curl -s -o /dev/null -X POST -H "Authorization: Bearer $TOKEN" -H 'Content-type: application/json' -d "{\"user_id\":\"$DEG_ID,$ANNEN_ID\", \"access_level\": 40}" "$GITLAB_URL/api/v4/projects/$PROSJEKT_ID/members"


rm -rf ditt
git clone http://du:password@${GITLAB_HOST}/root/Prosjektet.git ditt

#./oppdaterAnnen &