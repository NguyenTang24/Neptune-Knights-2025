# uStreamer Auto-Start with Persistent Camera Naming  

This script automates the setup of **persistent camera names** and ensures `uStreamer` starts automatically on boot.  
✅ Automatically detects cameras and assigns them permanent names
✅ Ensures consistent camera mapping across reboots
✅ Streams each camera on a unique port
✅ Auto-restarts streams if they fail
✅ Works for any number of cameras

## Installation  

Run the following commands on your Raspberry Pi:  
```bash
git clone https://github.com/Neptune-Knights/Neptune-Knights-2025/tree/main/ustreamer%20launch
cd "ustreamer launch" 
chmod +x install.sh
./install.sh
```

During setup, you will be asked to name each camera. For example:
```bash
Detected camera: /dev/video0
Enter a custom name for this camera (e.g., 'cam_front', 'cam_rear'): cam_front
```

# How to Acces Camera Streams:
After installation, they will be available at:
- http://pi-ip:8080 -> /dev/cam_front
- http://pi-ip:8081 -> /dev/cam_rear (etc.)

# Managing Camera Streams:
## Check Running Services:
```bash
systemctl list-units --type=service | grep ustreamer
```
Restart a Camera Stream:
```bash
sudo systemctl restart ustreamer_cam_front
```
Stop a Camera Stream:
```bash
sudo systemctl stop ustreamer_cam_rear
```
Disable a Camera from AutoStarting:
```bash
sudo systemctl disable ustreamer_cam_side
```

# Uninstalling & Removing Persistent Names:
If you want to remove the uStreamer service and persistent camera names, run:
```bash
sudo systemctl stop ustreamer_*
sudo systemctl disable ustreamer_*
sudo rm /etc/systemd/system/ustreamer_*.service
sudo rm /etc/udev/rules.d/99-usb-cameras.rules
sudo systemctl daemon-reload
sudo udevadm control --reload-rules
sudo udevadm trigger
```

