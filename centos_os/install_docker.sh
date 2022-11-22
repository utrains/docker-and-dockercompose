#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------#
# 
# @Autor : hermann90
# Description : Script for Docker Installation some utilities in the centos 7 server
# Date : 11 Nov 2022
#   
#------------------------------------------------------------------------------------------------------------------#


## Recover the ip address and update the server
IP=$(hostname -I | awk '{print $2}')
echo "START - install Docker - "$IP
echo "=====> [1]: updating ...."
sudo yum update -qq >/dev/null

## Prerequisites tools(Curl, Wget, ...) for Docker

echo "=====> [2]: install prerequisite tools for Docker"


# Although not needed for Docker, I like to use vim, so let's make sure it is installed:
sudo yum install -y vim

# Let's install sshpass
sudo yum install -y sshpass

# Let's install gnupg2
sudo yum install -y gnupg2

# gnupg2 openssl :
sudo yum install -y openssl

# gnupg2 curl:
sudo yum install -y curl


echo "===== =================> [3]: Docker installation ...."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo systemctl start docker

