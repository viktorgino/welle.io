dab-rpi with QML GUI
====================

This github fork includes a QML based GUI for dab-rpi.

dab-rpi and QT 5.6 cross compiling with GPU acceleration for RPi 2 and 3 
--------------------------------------------------------------
The following tutorial has to be followed one by one.

1. Follow the tutorial https://wiki.qt.io/RaspberryPi2EGLFS
2. If you get the following QT compile error please read the [QTBUG-55029 ](https://bugreports.qt.io/browse/QTBUG-55029)
  
  ```
   qeglfsbrcmintegration.cpp:35:22: fatal error: bcm_host.h: No such file or directory
   #include <bcm_host.h>
  ```
3. Compile qtxmlpatterns on the host PC

  ```
# cd ~/raspi
# git clone git://code.qt.io/qt/qtxmlpatterns.git -b 5.6
# cd qtxmlpatterns
# ~/raspi/qt5/bin/qmake -r
# make
# make install
  ```
4. Compile qtdeclarative on the host PC

  ```
# cd ~/raspi
# git git://code.qt.io/qt/qtdeclarative.git -b 5.6
# cd qtdeclarative
# ~/raspi/qt5/bin/qmake -r
# make
# make install
  ```
5. Compile qtquickcontrols on the host PC

  ```
# cd ~/raspi
# git git://code.qt.io/qt/qtquickcontrols.git -b 5.6
# cd qtquickcontrols
# ~/raspi/qt5/bin/qmake -r
# make
# make install
  ```
6. Compile qtquickcontrols2 on the host PC

  ```
# cd ~/raspi
# git git://code.qt.io/qt/qtquickcontrols2.git -b 5.6
# cd qtquickcontrols2
# ~/raspi/qt5/bin/qmake -r
# make
# make install
  ```
7. Install all necessary libraries to compile dab-rpi on the RPi

  ```
  # apt-get install libfaad-dev libfftw3-dev portaudio19-dev libusb-1.0-0-dev librtlsdr-dev libsndfile1-dev
  ```
8. Resync all new files between the host PC and the RPi

  ```
# cd ~/raspi
# rsync -avz pi@IP:/lib sysroot
# rsync -avz pi@IP:/usr/include sysroot/usr
# rsync -avz pi@IP:/usr/lib sysroot/usr
# rsync -avz pi@IP:/opt/vc sysroot/opt
  ```
9. Adjust symlinks to be relative 

  ```
# cd ~/raspi
# ./sysroot-relativelinks.py sysroot
  ```
10. Now you can setup QT Creator as it is explanied in the tutorial https://wiki.qt.io/RaspberryPi2EGLFS
11. Clone dab-rpi and open it with QT Creator

  ```
# cd ~/raspi
# https://github.com/AlbrechtL/dab-rpi.git
  ```
12. Cross compile dab-rpi, load it to the RPi and start it



Original README.md
---------------
		DAB-RPI

This directory contains the implementation of a simple
dab/dab+ receiver that will run on an RPI 2.
The receiver supports terrestrial DAB reception with as input either
the stream from an AIRSPY, a SDRplay, a dabstick (direct
or through the rtl_tcp server) or a (prerecorded) file,
and it will output through the selected soundcard.

If configured for it - see ".pro" file or the CMakeLists.txt file -
the program will send its audio output to a tcp port.
A simple client is included - to be compiled and installed separately -
that can be used to map these PCI samples to a soundcard.
The client is available as a windows program in the windows-bin-dab folder
to be found on the website

Building:

Libraries -and their development files - that are needed are

qt		(4.8 or more)	tested with both Qt4 and Qt5
usbx	use a recent version
portaudio	0.19		some distros support by default an older version
fftw3f
faad
sndfile

Two possibilities for building the software are there: the Qt qmake tools
or the CMake tools.

QMake:
In the ".pro" file  one may select (or deselect) input devices by
uncommenting (commenting) the appropriate CONFIG= XXX lines.

A similar facility exists for the CMakeLists.txt file

Note that selecting a device requires installing the library and the
development files.

Tested on RPI with arch linux, and RPI with Raspbian Jessie, as well as under fedora 22 and Ubuntu 14.04
Cross compiled for W7/W10

Options:
Since an RPI is often run headless, an option is included to
configure such that the PCM output is sent to a simple TCP server, listening
at port 20040. 
uncommenting CONFIG+=TCP_STREAMER
will do here.

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Note that the CMakeLists.txt file assumes Qt5, the sdr-j-pro works
fine with both Qt4 and Qt5
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Note on NOT handling
Comment or uncomment the line
DEFINE	+= MOT_BASICS__
DEFINE	+= MOT_DATA__
for excluding or including a preliminary handling of slides in DAB
Default is: commented out
##########################################################################

Extensions:

Depending on the settings in the dab-rpi.pro file, the output is
sent to the local "soundcard" or to a TCP port.
Add
CONFIG+=tcp-streamer
for having the output sent to port 20040. Note that in that
case there will be no sound output locally. I am using that feature
to have the RPI on a location different from where I am normally sitting.

A local "listener" program is available to catch the data and transfer it
to the soundcard. 
