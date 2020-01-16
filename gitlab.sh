#! /usr/bin/env bash

source gitlab-token

COUNT_PER_PAGE=$(curl --Head -s "$URL/api/v4/projects?private_token=$TOKEN" | grep -i X-Per-Page | awk '{print $2;}' | tr -d '\r')
NUMBER_OF_PAGES=$(curl --Head -s "$URL/api/v4/projects?private_token=$TOKEN" | grep -i X-Total-Pages | awk '{print $2;}' | tr -d '\r')

for ((i =1; i<${COUNT_PER_PAGE}; i++));
do
    # For every repo get it's Projects, Groups and Repo names
    Project_Array+=( $(curl -s "$URL/api/v4/projects?private_token=$TOKEN&per_page=$COUNT_PER_PAGE&page=$i" | jq '.[].ssh_url_to_repo' | sed 's/"//g') )
    Group_Array+=( $(curl -s "$URL/api/v4/projects?private_token=$TOKEN&per_page=$COUNT_PER_PAGE&page=$i" | jq '.[].namespace.full_path' | sed 's/"//g') )
    Repo_Array+=( $(curl -s "$URL/api/v4/projects?private_token=$TOKEN&per_page=$COUNT_PER_PAGE&page=$i" | jq '.[].name' | sed 's/"//g') )
done

