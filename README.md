dab-rpi
=====================
This directory contains the implementation of a simple DAB/DAB+ receiver. It is optimized for embedded systems like Raspberry Pi2 and Raspberry Pi 3 but it runs also on regulars PC as well.

The receiver supports terrestrial DAB and DAB+ reception with as input either the stream from an AIRSPY, a SDRplay, a dabstick (direct or through the rtl_tcp server) or a (prerecorded) file, and it will output through the selected soundcard.

Table of contents
====

  * [Usage](#usage)
    * [Command Line Parameter](#command-line-parameter)
    * [Settings INI-File](#settings-ini-file)
  * [Building](#building)
    * [General Information](#general-information)
    * [Ubuntu Linux 16.04 LTS](#ubuntu-linux-1604-lts)
    * [Windows 10](#windows-10)
    * [Raspberry Pi 2 and 3](#raspberry-pi-2-and-3)

Usage
====

Command Line Parameter
---
TBD (starting input selection, command line parameters, GUIs)

Settings INI-File
---
TBD 


Building
====================

General Information
---
The following libraries and their development files are needed:
* QT 4.8 and above for GUI_1 and GUI_2 
* QT 5.7 and above GUI_3
* portaudio 0.19
* FFTW3f
* libfaad
* libsndfile
* zlib
* librtlsdr (for dabstick)
* libusb
* libsamplerate

Two possibilities for building the software are there: the Qt qmake tools
or the CMake tools.

In the ".pro" file one may select (or deselect) input devices by uncommenting (commenting) the appropriate "CONFIG = XXX" lines.
A similar facility exists for the CMakeLists.txt file

Note that selecting a device requires installing the library and the development files.

Options:
Since an RPI is often run headless, an option is included to configure such that the PCM output is sent to a simple TCP server, listening at port 20040. Uncomment the following lines.

  ```
CONFIG += TCP_STREAMER will do here.
  ```
  
Note on MOT handling comment or uncomment the following lines for excluding or including a preliminary handling of slides in DAB

  ```
DEFINE	+= MOT_BASICS__
DEFINE	+= MOT_DATA__

  ```
  
Depending on the settings in the dab-rpi.pro file, the output is sent to the local "soundcard" or to a TCP port.
Add to following lines for having the output sent to port 20040.

  ```
  CONFIG += tcp-streamer
  ```

Note that in that case there will be no sound output locally. I am using that feature to have the RPI on a location different from where I am normally sitting.
A local "listener" program is available to catch the data and transfer it to the soundcard. 

Ubuntu Linux 16.04 LTS
---
This sections shows how to compile dab-rpi with GUI_3 on Ubuntu 16.04 LTS. 

1. Install QT 5.7 including the QT Charts module by using the the "Qt Online Installer for Linux" https://www.qt.io/download-open-source/

2. Install the following packages

  ```
# sudo apt install libfaad-dev libfftw3-dev portaudio19-dev librtlsdr-dev libusb-1.0-0-dev  libsndfile1-dev libsamplerate0-dev mesa-common-dev libglu1-mesa-dev zlib1g-dev git
  ```
3. Clone dab-rpi

  ```
# git clone https://github.com/JvanKatwijk/dab-rpi.git
  ```

4. Start QT Creator and open the project file "dab-rpi.pro" inside the folder "dab-rpi".
5. Edit "dab-rpi.pro" and adapt it to your needs. This example is tested with the following settings:

  ```
unix {
CONFIG		+= dabstick_osmo
#CONFIG		+= sdrplay-exp
#CONFIG		+= sdrplay
CONFIG		+= rtl_tcp
#CONFIG		+= airspy
#CONFIG		+= tcp-streamer		# use for remote listening
CONFIG		+= gui_3
DESTDIR		= ./linux-bin
INCLUDEPATH	+= /usr/local/include
LIBS		+= -lfftw3f  -lusb-1.0 -ldl  #
LIBS		+= -lportaudio
LIBS		+= -lz
LIBS		+= -lsndfile
LIBS		+= -lsamplerate
LIBS		+= -lfaad
}
  ```

6. Build dab-rpi
7. Run dab-rpi and enjoy it

Windows 10
---
TBD

Raspberry Pi 2 and 3
---
To build and run dap-rpi with GUI_3 on a Raspberry Pi 2 and 3 with GPU acceleration, please visit this repository: https://github.com/AlbrechtL/dab-rpi_raspbian_image


