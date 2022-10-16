#!/bin/bash

echo "This scripts installs portainer and nginx-proxy-manager on ubuntu"
echo ""
echo "The installation will:"
echo "1 - update your OS"
echo "2 - create a docker network for nginx-proxy-manager"
echo "3 - pull and run portainer agent container"
echo "4 - pull and run nginx-proxy-manager container"

echo ""
echo "NOTE: These operations may take a while"
echo ""

#installer
install() {
    echo ""
    echo "OK. proceeding with installations..."
    
    sleep 2s
    echo ""
    
    #The installation log file name
    LOG_FILE="portainer-ce+npm-install.log"
    
    #Stack template url
    STACK_TEMPLATE_URL="https://raw.githubusercontent.com/msandwidi/docker-scripts/main/docker-compose.portainer-agent%2Bnginx-proxy-manager.yml"
    
    #custom name for docker compose file
    DOCKER_COMPOSE_FILE_NAME="portainer-agent+nginx-proxy-manager.yml"
    
    #updated host first
    echo "updating host..."
    echo "this may take a while"
    
    (sudo apt-get update && sudo apt-get upgrade -y) > ~/$LOG_FILE 2>&1
    
    echo ""
    
    #the installed docker version
    DOCKER_VERSION=$( (which docker && docker -v) 2>&1 )
    
    #the installed docker-compose version
    DOCKER_COMPOSE_VERSION=$( (which docker-compose && docker-compose -v) 2>&1 )
    
    #docker and docker-compose are both required
    if ! [[ $DOCKER_VERSION && $DOCKER_COMPOSE_VERSION ]]; then
        echo "You need both docker and docker-compose pre-installed in order to use this script"
        exit;
    else
        echo "$(docker -v) detected"
        echo "$(docker-compose -v) detected"
        
        echo ""
        
        DOCKER_SERVICE_STATUS=$( (sudo systemctl is-active docker ) 2>&1 )
        echo "docker service status: $DOCKER_SERVICE_STATUS"
        
        sleep 2s
        echo ""
        
        #the docker service needs to be running
        if [[ "$DOCKER_SERVICE_STATUS" != "active" ]]; then
            
            echo "attempting to restart docker service"
            (sudo systemctl start docker) >> ~/$LOG_FILE 2>&1
            
            sleep 5s
            
            #update status
            DOCKER_SERVICE_STATUS=$( (sudo systemctl is-active docker ) 2>&1 )
            echo ""
        fi
        
        if [[ "$DOCKER_SERVICE_STATUS" != "active" ]]; then
            #service still not running
            echo "Docker service did not re-start"
            echo "exiting script..."
            exit 1;
        fi
        
        #nginx proxy manager network
        NPM_NET=$( (sudo docker network inspect nginx-proxy) 2>&1 )
        
        if [[ "$NPM_NET" != []* ]]; then
            echo "nginx-proxy docker network probably exists"
            echo "skipping nginx-proxy network creation..."
        else
            echo "Creating nginx proxy manager network: nginx-proxy..."
            sudo docker network create nginx-proxy
            
            sleep 2s
            echo ""
        fi
        
        echo "fetching docker-compose stack template..."
        
        echo ""
        echo "template url: $STACK_TEMPLATE_URL"
        echo ""
        
        mkdir -p docker
        
        cd docker
        
        
        #pull down the template
        (curl $STACK_TEMPLATE_URL -o $DOCKER_COMPOSE_FILE_NAME) >> ~/$LOG_FILE 2>&1
        
        echo "starting nginx-proxy-manager container..."
        echo ""
        
        sudo docker-compose -f $DOCKER_COMPOSE_FILE_NAME up -d
        
        sleep 5s
        echo ""
        
        echo "the container is booting"
        
    fi
    
    echo ""
    echo "All Done."
    
    echo ""
    echo "docker-compose file name: $DOCKER_COMPOSE_FILE_NAME"
    
    echo ""
    echo "use: 'docker-compose -f $DOCKER_COMPOSE_FILE_NAME ps' to check your stack "
    
    echo ""
    echo "Log file: ~/$LOG_FILE"
}

read -rp "Would like to continue the installations? (yes/no): " PURSUE_INSTALLATIONS

case $PURSUE_INSTALLATIONS in
    yes ) install;;
    no ) echo "exiting...";
    exit;;
    * ) echo "invalid response";
    exit 1;;
esac
