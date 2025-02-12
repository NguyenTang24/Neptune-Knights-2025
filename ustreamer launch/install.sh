#!/bin/bash

# Get the current username
USER=$(whoami)

echo "Installing uStreamer and setting up persistent camera names..."

# Update package list and install ustreamer
sudo apt update
sudo apt install -y ustreamer

# Create a udev rules file
UDEV_RULES_FILE="/etc/udev/rules.d/99-usb-cameras.rules"
echo "# Persistent USB camera names" | sudo tee "$UDEV_RULES_FILE" > /dev/null

# Reload systemd to recognize new services
sudo systemctl daemon-reload

# Counter for assigning ports dynamically
PORT=8082
CAMERAS=($(ls /devvideo* 2>/dev/null))

if [ ${#CAMERAS[@]} -eq 0 ]; then
    echo "no cameras detected. Exiting."
    exit 1
fi


# Detect connected cameras
for device in "${#CAMERAS[@]}"; do
        echo "Detected camera: $device"
        
        # Get camera details
        DEVICE_PATH=$(udevadm info -q path -n "$device")
        ID_VENDOR=$(udevadm info -a -p "$DEVICE_PATH" | grep 'ATTRS{idVendor}' | head -n 1 | awk -F'==' '{print $2}' | tr -d '"')
        ID_PRODUCT=$(udevadm info -a -p "$DEVICE_PATH" | grep 'ATTRS{idProduct}' | head -n 1 | awk -F'==' '{print $2}' | tr -d '"')

        # Ask the user to name the camera
        echo -n "Enter a custom name for this camera (e.g., 'cam_front', 'cam_rear'): "
        read CAM_NAME

        # Write the udev rule
        echo "SUBSYSTEM==\"video4linux\", ATTRS{idVendor}==\"$ID_VENDOR\", ATTRS{idProduct}==\"$ID_PRODUCT\", SYMLINK+=\"$CAM_NAME\"" | sudo tee -a "$UDEV_RULES_FILE" > /dev/null

        # Create and enable systemd service for this camera
        SERVICE_FILE="/etc/systemd/system/ustreamer_$CAM_NAME.service"
        echo "[Unit]
Description=uStreamer Service for $CAM_NAME
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/bin/bash -c 'ustreamer --device=/dev/$CAM_NAME --host=\$(hostname -I | awk \"{print \$1}\") --port=$PORT'
Restart=always
User=$USER
WorkingDirectory=/home/$USER
StandardOutput=append:/var/log/ustreamer_$CAM_NAME.log
StandardError=append:/var/log/ustreamer_$CAM_NAME.log

[Install]
WantedBy=multi-user.target" | sudo tee "$SERVICE_FILE" > /dev/null

        # Enable and start the service
        sudo systemctl enable "ustreamer_$CAM_NAME"
        sudo systemctl start "ustreamer_$CAM_NAME"

        echo "Camera '$CAM_NAME' is now streaming on port $PORT"

        # Increment port for the next camera
        PORT=$((PORT + 1))
done

# Apply udev rules
echo "Reloading udev rules..."
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "Installation complete! Your cameras now have persistent names and auto-start on boot."

