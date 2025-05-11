# uStreamer Multi-Camera Setup

## Overview
This setup enables persistent USB camera names using `udev` rules and launches multiple `ustreamer` instances automatically on startup.

## Installation
### 1. Clone the Repository
```bash
git clone <your-repo-url>
cd <your-repo-name>
```

### 2. Install Dependencies
```bash
sudo apt update
sudo apt install -y v4l-utils ustreamer
```

### 3. Move the udev Rules File
Move the provided udev rules file into the correct directory:
```bash
sudo cp 99-usb-cameras.rules /etc/udev/rules.d/
```

### 4. Apply the udev Rules
The udev rules are based on the physical port number. It is important that the cameras remain plugged into the same USB port.
```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

### 6. Install services:
```bash
chmod +x install-ustreamer.sh
sudo ./install-ustreamer.sh
```
Enter username when prompted. This will install, enable, and start 4 service files for the cameras.

## Viewing the Streams
Once the service is running, access your camera streams at:
- `http://<Pi_IP>:8082` (Front Camera)
- `http://<Pi_IP>:8083` (Left Camera)
- `http://<Pi_IP>:8084` (Right Camera)
- `http://<Pi_IP>:8085` (Tether Camera)

## Checking Logs
To check if the service is running correctly, use:
```bash
journalctl -u ustreamer -f
```

## Troubleshooting
- If a camera is not appearing at `/dev/frontcam`, `/dev/leftcam`, etc., check with:
  ```bash
  ls -l /dev/frontcam
  ```
- Verify that the udev rules are correct:
  ```bash
  udevadm info -q property -n /dev/videoX
  ```
- Restart the service:
  ```bash
  sudo systemctl restart ustreamer
  ```

## Updating udev rules:
How to find port number of each camera:
```bash
udevadm info -a -n /dev/video0 | grep KERNELS
```

## Uninstalling
To remove the setup:
```bash
sudo rm /etc/systemd/system/ustreamer-*
sudo rm /etc/udev/rules.d/99-usb-cameras.rules
sudo udevadm control --reload-rules
```


