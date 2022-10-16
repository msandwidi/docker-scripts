#!/bin/bash

echo "This scripts installs docker and docker-compose on ubuntu"
echo ""
echo "The installation will:"
echo "1 - update your OS"
echo "2 - install docker commuity edition"
echo "3 - start docker service"
echo "4 - add the current user to the docker group"
echo "5 - install docker-compose"

echo ""
echo "NOTE: These operations may take a while"
echo "NOTE: Packages that are already installed will be skipped"
echo ""

#installer
install() {
    echo ""
    echo "OK. proceeding with installations..."
    
    sleep 2s
    echo ""
    
    #The installation log file name
    LOG_FILE="docker+compose-install.log"
    
    #updated host first
    echo "updating host..."
    echo "this may take a while"
    
    (sudo apt-get update && sudo apt-get upgrade -y) > ~/$LOG_FILE 2>&1
    
    echo ""
    
    #check if docker is installed
    if [[ $( (which docker && docker -v) 2>&1 ) ]]; then
        echo "$(docker -v) is already installed"
        echo "skipping docker installation..."
    else
        #install docker-ce
        echo "installing docker-ce..."
        echo "this may take a while"

        (curl -fsSL https://get.docker.com | sh) >> ~/$LOG_FILE 2>&1
        
        sleep 3s
        echo ""
        
        echo "starting docker service..."
        (sudo systemctl docker start) >> ~/$LOG_FILE 2>&1
        
        sleep 2s
        echo ""
        
        echo "$(docker -v) installed successfully"
        
        sleep 2s
        echo ""
        
        echo "adding current user to docker group..."

        (sudo usermod -aG docker "${USER}") >> ~/$LOG_FILE 2>&1

        echo "you may need re-login for the change to take effect"
    fi
    
    echo ""
    
    #check if docker-compose is installed
    if [[ $( (which docker-compose && docker-compose -v) 2>&1 ) ]]; then
        echo "$(docker-compose -v) is already installed"
        echo "skipping docker-compose installation..."
    else
        #install docker-compose
        echo "installing docker-compose..."
        echo "this may take a while"

        (sudo apt install docker-compose -y) >> ~/$LOG_FILE 2>&1
        
        sleep 2s
        echo ""
        
        echo "$(docker-compose -v) installed successfully"
        sleep 2s
    fi
    
    echo ""
    echo "All Done."
    
    echo ""
    echo "NOTE: You may need to reboot your OS if any of the packages was added"
    
    echo ""
    echo "Log file: ~/$LOG_FILE"
}

read -rp "Would the like to continue the installations? (yes/no): " PURSUE_INSTALLATIONS

case $PURSUE_INSTALLATIONS in
    yes ) install;;
    no ) echo "exiting...";
    exit;;
    * ) echo "invalid response";
    exit 1;;
esac
