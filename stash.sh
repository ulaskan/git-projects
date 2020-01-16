#! /usr/bin/env bash

source stash-token

Projects_List=( $(curl -s -X GET -u "$USER:$PASSWORD" -H "Content-Type: application/json" "$URL/rest/api/1.0/projects?size=1000&limit=1000" | jq -r '.values[].key') )


for i in "${Projects_List[@]}"
do 
    # For every repo get it's Projects, Groups and Repo names
    Project_Array+=( $(curl -s -X GET -u "$USER:$PASSWORD" -H "Content-Type: application/json" "$URL/rest/api/1.0/projects/$i/repos/?limit=1000" | jq '.values[].links.clone[].href' | grep "ssh://" | sed 's/"//g') )
    Group_Array+=( $(curl -s -X GET -u "$USER:$PASSWORD" -H "Content-Type: application/json" "$URL/rest/api/1.0/projects/$i/repos/?limit=1000" | jq '.values[].project.key' | sed 's/"//g') )
    Repo_Array+=( $(curl -s -X GET -u "$USER:$PASSWORD" -H "Content-Type: application/json" "$URL/rest/api/1.0/projects/$i/repos/?limit=1000" | jq '.values[].slug' | sed 's/"//g') )
done

