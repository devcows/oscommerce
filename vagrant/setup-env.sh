#!/bin/bash

# --------------------------------------------------------------
# Install Docker
# --------------------------------------------------------------

# Update your apt sources
echo "**********************************************"
echo "********** Update your apt sources ***********"
echo "**********************************************"
sudo apt-get install -qy apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
rm -f /etc/apt/sources.list.d/docker.list
  # On Ubuntu Trusty 14.04 (LTS)
  # echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
# On Ubuntu Xenial 16.04 (LTS)
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get purge lxc-docker
# Verify that APT is pulling from the right repository.
apt-cache policy docker-engine

# Docker pre-requisites
echo "**********************************************"
echo "********** Docker pre-requisites *************"
echo "**********************************************"
#sudo apt-get update
sudo apt-get install -qy linux-image-extra-$(uname -r) linux-image-extra-virtual

# Docker install
echo "**********************************************"
echo "************** Docker install ****************"
echo "**********************************************"
#sudo apt-get update
sudo apt-get install -qy docker-engine

# --------------------------------------------------------------
# --------------------------------------------------------------


# Stop and remove any existing containers
sudo docker stop $(docker ps -a -q)
sudo docker rm $(docker ps -a -q)

# Run postgres container
sudo docker run -d -p 5432:5432 -v /vagrant:/vagrant -e "POSTGRES_PASSWORD=postgres" --name postgres postgres:9.4.1

# install required packages
sudo apt-get update
sudo apt-get install -qy git nodejs imagemagick libpq-dev postgresql-client