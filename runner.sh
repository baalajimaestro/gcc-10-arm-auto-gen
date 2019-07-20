#!/bin/bash
# Copyright (C) 2019 The Raphielscape Company LLC.
#
# Licensed under the Raphielscape Public License, Version 1.b (the "License");
# you may not use this file except in compliance with the License.
#
# CI Runner Script for Generation of blobs

# We need this directive
# shellcheck disable=1090

echo "***Auto Compiler Updater***"
apt update > /dev/null 2>&1
apt upgrade -y > /dev/null 2>&1
apt install python3 -y > /dev/null 2>&1
python3 strip.py
chmod 777 telegram
chmod 777 telegramapi
apt install sudo git lsb-release apt-utils -y > /dev/null 2>&1
echo 'Initial Dependencies Installed......'
sudo echo "ci ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
useradd -m -d /home/ci ci
useradd -g ci wheel
echo `pwd` > /tmp/loc
sudo -Hu ci bash -c "bash runner_user.sh"
