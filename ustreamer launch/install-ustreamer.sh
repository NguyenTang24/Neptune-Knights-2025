#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Get username for the service
read -p "Enter username to run the services: " USERNAME

# Copy service files to systemd directory
cp ustreamer-*.service /etc/systemd/system/

# Replace %i with actual username in all service files
sed -i "s/%i/$USERNAME/g" /etc/systemd/system/ustreamer-*.service

# Create log files with appropriate permissions
touch /var/log/ustreamer-frontcam.log
touch /var/log/ustreamer-leftcam.log
touch /var/log/ustreamer-rightcam.log
touch /var/log/ustreamer-tethercam.log
chown $USERNAME:$USERNAME /var/log/ustreamer-*.log

# Reload systemd, enable and start services
systemctl daemon-reload
systemctl enable ustreamer-frontcam.service ustreamer-leftcam.service ustreamer-rightcam.service ustreamer-tethercam.service
systemctl start ustreamer-frontcam.service ustreamer-leftcam.service ustreamer-rightcam.service ustreamer-tethercam.service

echo "All uStreamer services installed and started."