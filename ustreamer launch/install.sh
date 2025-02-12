#!/bin/bash

# Ensure necessary packages are installed
sudo apt update
sudo apt install -y v4l-utils ustreamer

# Get current user
USER=$(whoami)

echo "Detecting USB cameras..."

# Find only USB-connected cameras
USB_CAMERAS=()
for device in /dev/video*; do
    if udevadm info -q property -n "$device" | grep -q "ID_BUS=usb"; then
        USB_CAMERAS+=("$device")
    fi
done

if [ ${#USB_CAMERAS[@]} -eq 0 ]; then
    echo "❌ No USB cameras detected! Make sure your camera is plugged in."
    exit 1
fi

echo "Found ${#USB_CAMERAS[@]} USB camera(s)."

# Create a udev rules file
UDEV_RULES_FILE="/etc/udev/rules.d/99-usb-cameras.rules"
echo "# Persistent USB camera names" | sudo tee "$UDEV_RULES_FILE" > /dev/null

# Counter for ports
PORT=8080

for device in "${USB_CAMERAS[@]}"; do
    echo "🔍 Detected USB camera: $device"

    # Get device details
    DEVICE_PATH=$(udevadm info -q path -n "$device")
    ID_VENDOR=$(udevadm info -a -p "$DEVICE_PATH" | grep 'ATTRS{idVendor}' | head -n 1 | awk -F'==' '{print $2}' | tr -d '"')
    ID_PRODUCT=$(udevadm info -a -p "$DEVICE_PATH" | grep 'ATTRS{idProduct}' | head -n 1 | awk -F'==' '{print $2}' | tr -d '"')

    # Ask the user to name the camera
    echo -n "Enter a name for this camera (e.g., cam_front, cam_rear): "
    read CAM_NAME

    # Write the udev rule
    echo "SUBSYSTEM==\"video4linux\", ATTRS{idVendor}==\"$ID_VENDOR\", ATTRS{idProduct}==\"$ID_PRODUCT\", SYMLINK+=\"$CAM_NAME\"" | sudo tee -a "$UDEV_RULES_FILE" > /dev/null

    # Create a systemd service for the camera
    SERVICE_FILE="/etc/systemd/system/ustreamer_$CAM_NAME.service"
    echo "[Unit]
Description=uStreamer for $CAM_NAME
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

    echo "✅ Camera '$CAM_NAME' is streaming on port $PORT"

    # Increment port for the next camera
    PORT=$((PORT + 1))
done

# Apply udev rules
echo "♻️ Reloading udev rules..."
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "🎉 Setup complete! Your USB cameras now have persistent names and start automatically."

