#!/usr/bin/env bash

if [ "$1" == "build" ]; then
	cd /tmp
	git clone https://github.com/jiahaog/nativefier.git
	cd nativefier
	docker build -t nativefier .
	exit
fi

# Setup
sudo rm -rf compile binaries
mkdir -p compile
mkdir -p binaries
cp resources/* compile
chmod a+rw compile -R
chmod a+rw binaries -R
cd compile

# Linux
docker run -v "${PWD}":/target nativefier --name Pushover --tray -p linux https://client.pushover.net /target/
sudo chown $(id -u):$(id -g) . -R
mv Pushover-linux-x64 pushover
tar cvfz pushover-linux.tgz pushover
mv pushover-linux.tgz ../binaries

# Windows
docker run -v "${PWD}":/target nativefier --name Pushover --tray -i /target/icon.png -p windows https://client.pushover.net /target/
sudo chown $(id -u):$(id -g) . -R
mv Pushover-win32-x64 Pushover
zip -r Pushover-win.zip Pushover
mv Pushover-win.zip ../binaries

# OSX
docker run -v "${PWD}":/target nativefier --name Pushover --tray -p osx https://client.pushover.net /target/
sudo chown $(id -u):$(id -g) . -R
cd Pushover-darwin-x64
zip -r Pushover-osx.app.zip Pushover.app
mv Pushover-osx.app.zip ../../binaries
cd ..

# Cleanup
cd ..
sudo rm -rf compile
sudo chown $(id -u):$(id -g) binaries -R

