#!/bin/bash
echo ""

#this script is for root user
if [[ "$(whoami)" != root ]]; then
    echo "Please run this script as root"
    echo "exiting..."
    exit 1
fi

echo "This scripts installs is an assistant for ubuntu initial setup"
echo ""
echo "The installation will:"
echo "1 - update your OS"
echo "2 - create a non-root user"
echo "3 - enable OpenSSH for ufw firewall"
echo "4 - enable HTTPS for ufw firewall"

echo ""

#installer
install() {
    echo ""
    echo "OK. proceeding with setup..."

    sleep 2s
    echo ""

    #The installation log file name
    LOG_FILE="ubuntu-initial-setup.log"

    #updated host first
    echo "updating host..."
    echo "this may take a while"

    (sudo apt-get update && sudo apt-get upgrade -y) >~/$LOG_FILE 2>&1

    echo ""
    read -rp "What is the username of your non-root user: " NEW_USER_USERNAME

    sleep 1s
    echo ""
    echo "'$NEW_USER_USERNAME' got it..."

    #check if user exists
    if id -u "$NEW_USER_USERNAME" >~/$LOG_FILE 2>&1; then
        echo "user $NEW_USER_USERNAME already exists"
        echo "exitting..."
        echo ""
        exit 1
    else
        echo "Great! This username is available"
    fi

    sleep 1s
    echo ""

    echo "creating user: $NEW_USER_USERNAME..."

    adduser $NEW_USER_USERNAME

    sleep 1s
    echo ""
    echo "adding $NEW_USER_USERNAME to sudo group..."

    usermod -aG sudo $NEW_USER_USERNAME

    sleep 1s
    echo ""

    echo "enabling OpenSSH and HTTPS..."
    (ufw allow OpenSSH) >~/$LOG_FILE 2>&1
    (ufw allow HTTPS) >~/$LOG_FILE 2>&1

    sleep 1s
    echo ""

    echo "enabling ufw..."
    (echo 'y' | ufw enable) >~/$LOG_FILE 2>&1

    rsync --archive --chown=$NEW_USER_USERNAME:$NEW_USER_USERNAME ~/.ssh /home/$NEW_USER_USERNAME

    sleep 1s
    echo ""

    echo "All Done."

    sleep 1s
    echo ""

    echo "NOTE: You may want to login with the new non-root user '$NEW_USER_USERNAME' to make sure the access is properly configured"

    sleep 1s
    echo ""
    echo "NOTE: You may need to reboot your OS to finalize the firewall setup"

    echo ""
    echo "Log file: ~/$LOG_FILE"
    echo ""
}

read -rp "Would you like to continue the setup? (yes/no): " PURSUE_SETUP

case $PURSUE_SETUP in
yes) install ;;
no)
    echo "exiting..."
    echo ""
    exit
    ;;
*)
    echo "invalid response"
    echo ""
    exit 1
    ;;
esac
