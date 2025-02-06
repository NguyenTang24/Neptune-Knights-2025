#!/bin/bash

echo "Installing ustreamer and setting up uStreamer service..."

sudo apt update
sudo apt install -y ustreamer 

# Move the service file
sudo mv ustreamer.service /etc/systemd/system/

# Reload systemd
sudo systemctl daemon-reload

# Enable and start the service
sudo systemctl enable ustreamer
sudo systemctl start ustreamer

echo "Installation complete. uStreamer is now running."
