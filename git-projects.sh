#! /usr/bin/env bash

### Choose between gitlab or stash repositories
function main_menu {
    echo -e "\n\033[0;36m=============================================================================================================================="
    echo -e "\033[1;36m>>> Make sure that right API tokens and/or Passwords are generated and put into the token files as well as the correct URL\n"
    echo -e "\n\033[0;36mPlease choose Git Projects Source: "
    echo -e "\t 1. Gitlab"
    echo -e "\t 2. Bitbucket\Stash"
    echo -e "\t 3. Exit\n"
    echo -e "===============================================================================================================================\033[0m"
    printf "\033[1;36mPlease enter (1/2/3): \033[0m"
    read choice
    
    if [ "$choice" = "1" ]; then
        source gitlab-token
    elif [ "$choice" = "2" ]; then
        source stash-token
    elif [ "$choice" = "3" ]; then
        exit
    else
        while [ "$choice" != "1" ] || [ "$choice" != "2" ] || [ "$choice" != "3" ]
        do
            printf "\033[1;36mPlease enter (1/2/3): \033[0m"
            read choice
            if [ "$choice" = "1" ]; then
                source gitlab-token
                break
            elif [ "$choice" = "2" ]; then
                source stash-token
                break
            elif [ "$choice" = "3" ]; then
                exit
            else
                :
            fi
        done
    fi
    project_location
    printf "\n \033[1;35mPlease wait...\033[0m \n"
}

### Specify the working directory to clone/pull the projects
function project_location {
    printf "\e[1;32mPlease enter the location of your git projects: \e[0m\n" 
    read -p "Either specify full path (eg. /home/user.name/my-projects) or a relative path (eg. ~/my-projects): " PROJECT_PATH
    if [[ "$PROJECT_PATH" =~ ^~ ]]; then
            PROJECT_PATH="$HOME${PROJECT_PATH:1}"
    fi
    if [ ! -d $PROJECT_PATH ]; then
        mkdir -p $PROJECT_PATH
        echo -e "$PROJECT_PATH created ..."
    fi
}

### Git Pull or Clone
function get_projects {
    MAX_PAR_REQS=25             # maximum parallel requests
    COUNTER=0                   # initialize parallel count
    cd $ROOT_DIR

    for ((i=0; i<${#Project_Array[@]}; ++i));
    do
        REPO=${Project_Array[i]}
        GROUP_FOLDER=${Group_Array[i]}
        REPO_FOLDER=${Repo_Array[i]}

        if [ -d $GROUP_FOLDER ]; then
            cd $GROUP_FOLDER
            echo $(pwd)
        else
            mkdir -p $GROUP_FOLDER
            cd $GROUP_FOLDER
            echo $(pwd)
        fi

        if [ -d $REPO_FOLDER ]; then
            if  [ -d $REPO_FOLDER/.git ];
            then
                printf "\n \e[1;36m$REPO :\e[0m Repo already cloned, performing a git pull! \n"
                cd $REPO_FOLDER
                pushd $REPO_FOLDER > /dev/null
                ( git pull ) &
                popd > /dev/null
                cd - &> /dev/null
                COUNTER=$(( $COUNTER + 1 ))
            else
                rm -rf $REPO_FOLDER
                printf "\n \e[1;31m$REPO :\e[0m Folder exists but no git repo found. Cloning again... \n"
                pushd $REPO_FOLDER > /dev/null
                ( git clone $REPO ) &
                popd > /dev/null
                COUNTER=$(( $COUNTER + 1 ))
            fi
        else
            printf "\n \e[1;32m$REPO :\e[0m Cloning the new repo... \n"
            pushd $REPO_FOLDER > /dev/null
            ( git clone $REPO ) &
            popd > /dev/null
            COUNTER=$(( $COUNTER + 1 ))
        fi
        cd $ROOT_DIR

        # if at max parallel requests wait an reset counter
        if [ "$COUNTER" -eq "$MAX_PAR_REQS" ]; then
            echo -e "\e[1;35m === waiting ... \e[0m"
            wait
            COUNTER=0
        fi
    done
}

### MAIN
main_menu

### Call the appropriate gitlab or stash script depending on the choice in the main_menu function:
if [ "$choice" = "1" ]; then
    source gitlab.sh
    mkdir -p $PROJECT_PATH/gitlab
    ROOT_DIR=$PROJECT_PATH/gitlab
elif [ "$choice" = "2" ]; then
    source stash.sh
    mkdir -p $PROJECT_PATH/stash
    ROOT_DIR=$PROJECT_PATH/stash
fi

get_projects
printf "\n \e[1;35mRepositories successfully retrieved... GOODBYE!\e[0m \n\n"


