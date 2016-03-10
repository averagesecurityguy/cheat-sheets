Kali Rolling In Docker on EC2
=============================
Create a new Instance
---------------------
1. Build a new Ubuntu 14.04 instance that has t2.medium specs or higher.
2. Configure the root drive to be 40GB.
3. Configure the Security Group and SSH key to match your normal settings.


Install Docker and Kali
-----------------------
1. Copy the docker_kali_setup.sh script (below) to the new instance and run the script. This will update the server, install docker, and download a minimal Kali docker image.
2. Once the script is finished, run the following command to get a root shell in the Kali docker image

    sudo docker run -t -i kalilinux/kali-linux-docker /bin/bash

3. Once inside the root shell run the following commands to install the full Kali image:

    apt-get update
    apt-get install kali-linux-full

4. Exit the docker shell.
5. When you want to run a Kali command start a new root shell in docker and execute the command.

    sudo docker run -t -i kalilinux/kali-linux-docker /bin/bash

6. I haven't figured out docker networking yet so I don't know how reverse shells in Metasploit will just work or if something else has to be done. Feel free to enlighten me on the subject.


Docker Kali Setup Script
------------------------
```
#!/bin/bash

# Apply the latest updates to the box first.
sudo apt-get update
sudo apt-get -y upgrade

# Configure the Docker APT key and repos.
sudo apt-get install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list'
sudo apt-get update

# Install and start docker
sudo apt-get -y install linux-image-extra-$(uname -r) apparmor docker-engine
sudo service docker start

# Install Kali docker image
sudo docker pull kalilinux/kali-linux-docker
```