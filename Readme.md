
## Git-project
This script clones and/or pulls the projects you have access to from A Bitbucket (stash) and/or Gitlab server. This
is a bash script and is only tested on Mac or Linux. The script will only get the repositories your credentials has
access to. The script is currently only tested with SSH connection.   


## Pre-requites:
In order to use the scripts the following need to be set up first:
1. Make sure you have `jq` package installed on your Mac or Linux
2. In order use the script on a Gitlab server make sure:  
    a. set up an ssh connection. For further info please refer to: https://docs.gitlab.com/ee/ssh/  
    b. set up a personal access token. For further info please refer to https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html  
    c. Input the URL and the token in the `gitlab-token` file inside the double quotes as follows:  
    ```
       export URL="https://mygitlab.server.com"
       export TOKEN="MySecretT0ken"
   ```

3. In order use the script on a Bitbucket (stash) server make sure:  
    a. set up the ssh connection. For further info please refer to: https://confluence.atlassian.com/bitbucket/set-up-an-ssh-key-728138079.html  
    b. Input the URL, Username and Password in the `stash-token` file inside the double quotes as follows:  
    ```
       export URL="https://mybitbucket.server.com"
       export USER="user.name"
       export PASSWORD="MyPassw0rd"
   ```



## How to use the script

1. Clone the script, change into the saved location and run the main script: 
    ```
        ./git-projects.sh
    ```
2. The script will then present you with the menu to follow 

---


