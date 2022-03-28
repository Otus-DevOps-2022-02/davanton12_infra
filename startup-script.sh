#!/bin/bash
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
sudo apt-get --assume-yes update
sudo apt-get --assume-yes install mongodb-org ruby-full ruby-bundler build-essential git
sudo systemctl start mongod
sudo systemctl enable mongod
sudo git clone -b monolith https://github.com/express42/reddit.git
cd ~/reddit && bundle install
puma -d
