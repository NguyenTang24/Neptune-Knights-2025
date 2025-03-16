#!/bin/bash

# Get the current username
USER=$(whoami)

echo "Installing uStreamer and setting up the service for user: $USER..."

# Update package list and install ustreamer
sudo apt update
sudo apt install -y ustreamer

# Move the updated service file
sudo mv ustreamer@.service /etc/systemd/system/

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable and start the ustreamer service for the current user
sudo systemctl enable ustreamer@"$USER"
sudo systemctl start ustreamer@"$USER"

echo "Installation complete. uStreamer is now running as a systemd service for $USER."

