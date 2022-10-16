#!/bin/bash

echo "This scripts installs portainer and nginx-proxy-manager on ubuntu"
echo ""
echo "The installation will:"
echo "1 - update your OS"
echo "2 - create a non-root user"
echo "3 - enalble OpenSSH for ufw firewall"

echo ""

#installer
install() {
    echo ""
    echo "OK. proceeding with installations..."

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

    sleep 1s
    echo ""

    adduser $NEW_USER_USERNAME

    sleep 2s
    echo ""
    echo "adding $NEW_USER_USERNAME to sudo group..."

    usermod -aG sudo $NEW_USER_USERNAME

    sleep 2s
    echo ""

    echo "enabling OpenSSH, HTTPS..."
    (ufw allow OpenSSH) >~/$LOG_FILE 2>&1
    (ufw allow HTTPS) >~/$LOG_FILE 2>&1

    sleep 1s
    echo ""

    echo "enabling ufw..."
    (echo 'y' | ufw enable) >~/$LOG_FILE 2>&1

    rsync --archive --chown=$NEW_USER_USERNAME:$NEW_USER_USERNAME ~/.ssh /home/$NEW_USER_USERNAME

    sleep 2s
    echo ""

    echo "All Done."

    sleep 2s
    echo ""

    echo "NOTE: You may want to try login with the new non-root user: '$NEW_USER_USERNAME'"

    sleep 1s
    echo ""
    echo "NOTE: You may need to reboot your OS to finalize the firewall setup"

    echo ""
    echo "Log file: ~/$LOG_FILE"
}

read -rp "Would like to continue the installations? (yes/no): " PURSUE_INSTALLATIONS

case $PURSUE_INSTALLATIONS in
yes) install ;;
no)
    echo "exiting..."
    exit
    ;;
*)
    echo "invalid response"
    exit 1
    ;;
esac
