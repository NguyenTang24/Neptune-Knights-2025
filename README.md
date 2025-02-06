# Neptune-Knights-2025
All code for UCF MERKnight's MATE ROV Team, Neptune Knights.
This includes code for the ROV, control station, and Float.

## Overview
### ROV
A Raspberry Pi 5 on the ROV runs the BlueOS software. It is connected to a PixHawk 4 Flight Controller, running the latest version of stable ArduSub firmware, customized for our team.

### Float
The float will be programmed with an ESP32 Microcontroller. The microcontroller will run a webserver that allows for controlling the float and viewing/downloading data.

### Control Station
The control station runs the latest version of Ubuntu 24.10. The BlueOS control software and camera control software will run in Electron apps.


# Installation
## For Development:
This will install all of the code in a GIT workspace on your computer. Only install everything if you will be working on development across the team. Otherwise, you only need to install relevant repostories.

Find instructions on adding an ssh key [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

```bash
mkdir "Neptune Knights 2025"
cd "Neptune Knights 2025"
mkdir src
git clone git@github.com:Neptune-Knights/Neptune-Knights-2025.git src
cd src
git submodule update --init --recursive
```

## Control Station:
[Camera Stream Viewr](https://github.com/Neptune-Knights/Neptune-Knights-2025/tree/main/stream%20viewer)
BlueOS can be accessed in the web browser at the ROV's IP address, 192.168.0.100. No installation is needed on the control station.

[Hugin](https://hugin.sourceforge.io/) will be used for the photosphere task.
```bash
sudo apt install flatpak
flatpak install flathub net.sourceforge.Hugin
```


## ROV Software (BlueOS and Ardupilotx):
### [Cameras](https://github.com/Neptune-Knights/Neptune-Knights-2025/tree/main/ustreamer%20launch):
This installs a service on the Pi to launch an http stream of the cameras. It is currently set up for only one camera stream.
On the Pi:
```bash
git clone https://github.com/Neptune-Knights/Neptune-Knights-2025/ustreamer-service
cd ustreamer-service
chmod +x ustreamer.service
./install.sh
```
** [BlueOS Installation](https://github.com/bluerobotics/BlueOS/tree/master/install) **
```bash
sudo su -c 'curl -fsSL https://raw.githubusercontent.com/bluerobotics/BlueOS/master/install/install.sh | bash'
```

## Float:


