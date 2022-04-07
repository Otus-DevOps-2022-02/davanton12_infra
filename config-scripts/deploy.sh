#!/bin/bash
sudo apt-get install apt-transport-https ca-certificates
sudo apt-get --assume-yes update
sudo apt-get --assume-yes install git
git clone -b monolith https://github.com/express42/reddit.git
cd reddit
bundle install
puma -d
