# About
The camera control software uses the [ustreamer](https://github.com/pikvm/ustreamer) package for streaming. This script installs ustreamer and sets up a systemd service to launch the streams on startup.

Currently, the stream from device /dev/video0 is launched on 192.168.0.100:8080. The stream can be accessed at http://192.168.0.100:8080/stream and a snapshot at http://192.168.0.100:8080/snapshot. 

# Installation
On the Pi:
```bash
git clone https://github.com/Neptune-Knights/Neptune-Knights-2025/usteamer-service
cd ustreamer-service
chmod +x install.sh
./install.sh
```


