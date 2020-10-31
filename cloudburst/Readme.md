# <img src="html/cloud.png">

TODO / roadmap: 

- ~~Get everything to build again, ideally directly from cyclone~~
- view integration with templates
- make a working demo and have it do something interesting
- provide basic project description,
- installation/build instructions 
- include an arch linux script for getting packages?
- and usage
- first need to get controllers working (think we are there?) and build a demo REST API
- then get models working at some level (maybe postgres integration?)
- then figure out views for a UI (would be sweet to have a demo using Angular or such)

# Installation

TODO: build and run example from github action, including http server hosting the fcgi app

# Install Dependencies

## Ubuntu

    sudo apt-get install libfcgi-dev

Right now we are using nginx instead, but this would be nice to figure out, too:
(lighthttpd setup https://www.linuxcloudvps.com/blog/how-to-install-lighttpd-on-ubuntu-18-04/ )


## Arch Linux

    pacman -Sy
    pacman -S pacman
    pacman -S nginx fcgi fcgiwrap spawn-fcgi

