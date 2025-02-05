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
This will install all of the code in a GIT workspace on your computer. Only install everything if you will be working on development across the team. Otherwise, you only need to install relevant repostories.

```bash
mkdir "Neptune Knights 2025"
cd "Neptune Knights 2025"
mkdir src
git clone git@github.com:Neptune-Knights/Neptune-Knights-2025.git src
cd src
git submodule update --init --recursive
```

## BlueOS and Ardupilot:
## Cameras:
On the Pi:

'''bash
sudo apt install ustreamer
'''


## Float:


