#!/bin/bash

#
# Customize the following for your project/server
#
docRoot="/var/www/html/foobooks"
usernameServer="root@server.ip.address"


# Helper output functions
line () {
    info "--------------------------------------"
    echo ""
}

info () {
    echo $(tput bold)$(tput setaf 4)$@ $(tput sgr 0)
}

# Function to handle git actions locally
welcome () {
    echo ""
    info "Running git status -------------------"
    git status
    line
    info "How would you like to proceed?"
    info " (1) Push and deploy any pending commits."
    info " (2) Stage and commit all changed files, then push and deploy any pending commits."
    info " (3) Exit"
    info "Enter your choice: "
    read -${BASH_VERSION+e}r choice

     case $choice in
        1)
            git push
            ssh -t $usernameServer "$docRoot/bash/deploy.sh"
            ;;
        2)
            info "Enter a commit message: "
            read -${BASH_VERSION+e}r msg
            line
            git add --all
            git commit -m "$msg"
            git push
            line
            ssh -t $usernameServer "$docRoot/bash/deploy.sh"
            ;;
        3)
            info "Ok, goodbye!";
            exit
            ;;
        *)
            echo "Unknown command";
            ;;
    esac
}


# Function to deploy: pull changes, run composer install
# This function is invoked when this script is invoked on your server
deploy () {
    cd $docRoot;
    info "git pull ---------------"
    haystack=$(git pull)
    needle="config"
    if [[ "$haystack" == *"$needle"* ]]; then
        info "Detected change in config directory, running artisan cache:clear"
        php artisan cache:clear
    fi
    line
    info "composer install --no-dev ------------"
    composer install --no-dev
    line
}


# If this script is run on the server (docRoot exists), it should deploy
if [ -d "$docRoot" ]; then
    info "Detected location: server - running deployment"
    deploy
# Otherwise, if this script is run locally,
# it should invoke `welcome` to determine whether to deploy
else
    info "Detected location: local"
    welcome
fi