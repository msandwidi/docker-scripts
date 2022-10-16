#!/bin/bash
echo ""

echo "This scripts installs ..." #TODO tell what the script will do
echo ""
echo "The installation will:"
echo "1 - ..." #TODO list of things the script do
echo "2 - ..." #TODO list of things the script do

echo ""

#installer
install() {
    echo ""
    echo "OK. proceeding with installations..."

    sleep 2s
    echo ""

    #The installation log file name
    LOG_FILE="...log" #TODO log file name

    #TODO do something
    sleep 1s
    echo ""

    echo "All Done."

    sleep 2s
    echo ""

    echo "NOTE: ..." #TODO add important notes
    echo "NOTE: ..." #TODO add important notes

    echo ""
    echo "Log file: ~/$LOG_FILE"
    echo ""
}

read -rp "Would you like to continue the installations? (yes/no): " PURSUE_INSTALLATIONS

case $PURSUE_INSTALLATIONS in
yes) install ;;
no)
    echo "exiting..."
    echo ""
    exit
    ;;
*)
    echo "invalid response"
    exit 1
    echo ""
    ;;
esac
