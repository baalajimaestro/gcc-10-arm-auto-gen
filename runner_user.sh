#!/bin/bash
# Copyright (C) 2019 The Raphielscape Company LLC.
#
# Licensed under the Raphielscape Public License, Version 1.b (the "License");
# you may not use this file except in compliance with the License.
#
# CI Runner Script for Generation of blobs

# We need this directive
# shellcheck disable=1090


##### Build Env Dependencies
build_env()
{
. "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"/telegram
sudo apt install help2man libtool-bin wget curl -y > /dev/null 2>&1
TELEGRAM_TOKEN=$(cat /tmp/tg_token)
export TELEGRAM_TOKEN
tg_sendinfo "<code>[MaestroCI]: ARM-GCC-10 Compiler Job rolled!</code>"
cd ~
git clone https://github.com/crosstool-ng/crosstool-ng > /dev/null 2>&1
cd crosstool-ng
./bootstrap > /dev/null 2>&1
./configure > /dev/null 2>&1
make -j$(nproc) > /dev/null 2>&1
sudo make install > /dev/null 2>&1
cd ..
rm -rf crosstool-ng
echo "Build Dependencies Installed....."
}
##### Build Configs

build_conf()
{
mkdir repo
cd repo
git config --global user.email "baalajimaestro@computer4u.com"
git config --global user.name "baalajimaestro"
export LOC=$(cat /tmp/loc)
}

run()
{
echo "Starting build!"
git clone https://github.com/baalajimaestro/ct-ng-configs -b GCC-10-ARM > /dev/null 2>&1
cd ct-ng-configs
ct-ng build
echo "Build finished!"
}

##### Here's the blecc megik
push_gcc()
{
sudo chmod -R 777 $HOME/x-tools
cd $HOME/x-tools/arm-maestro-linux-gnueabi

git init
git add .
git checkout -b "$(date +%d%m%y)-10"
git commit -m "[MaestroCI]: ARM-GCC-10 $(date +%d%m%y)" --signoff
git remote add origin https://baalajimaestro:$(cat /tmp/GH_TOKEN)@github.com/baalajimaestro/arm-maestro-linux-gnueabi.git
git push --force origin "$(date +%d%m%y)-10"
tg_sendinfo "<code>Checked out and pushed GCC-ARM-10</code>"
echo "Job Successful!"
}

build_env
build_conf
run
push_gcc
