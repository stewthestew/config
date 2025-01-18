#!/bin/bash

echo "I am about to run the following:

=========================================================
rpm-ostree update
rpm-ostree install bspwm sxhkd picom xinput nvim chromium
=========================================================

Is this fine? (yes/no)"

# Prompt for input
read -p "Please enter your choice: " choice

# Handle user input
case "$choice" in
    yes|y|Y|YES|Yes)
        echo "Setup started."
        echo "You have 5 seconds to cancel. Press Ctrl+C to stop."
        sleep 5
        echo "Running the commands now..."
        # Execute commands with sudo
        sudo rpm-ostree update
        sudo rpm-ostree install bspwm sxhkd picom xinput nvim chromium
        echo "Installed everything. Rebooting in 3 seconds..."
        sleep 3
        echo "Now you can copy the config files"
        sudo reboot
        ;;
    no|n|N|NO|No)
        echo "Operation canceled by the user."
        ;;
    *)
        echo "Invalid input. Please run the script again and answer yes or no."
        ;;
esac
