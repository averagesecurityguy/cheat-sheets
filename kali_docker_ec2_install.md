Kali Rolling In Docker on EC2
=============================
Create a new Instance
---------------------
1. Build a new Ubuntu 14.04 instance that has t2.medium specs or higher.
2. Configure the root drive to be 40GB.
3. Configure the Security Group and SSH key to match your normal settings.


Install Docker and Kali
-----------------------
1. Copy the docker_kali_setup.sh script (below) to the new instance and run the script. This will update the server, install docker, and download a full Kali docker image. This will take a while.

    `sudo sh docker_kali_setup.sh`

2. When you want to run a Kali command start a new root shell in docker and execute the command.

    `sudo docker run -t -i kali <command>`

3. If you will be running services, such as metasploit, inside the docker container then you need to start docker with the following command.

    `sudo docker run --net=host -t -i kali /bin/bash`

4. If you would like to save any changes you've made to the container run the commit command after exiting.

    `sudo docker commit $(sudo docker ps -lq) kali`


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

# Install Kali Top 10 Metapackage
sudo docker pull kalilinux/kali-linux-docker
sudo docker run kalilinux/kali-linux-docker sh -c 'echo "deb http://archive-2.kali.org/kali kali-rolling main non-free contrib" > /etc/apt/sources.list; apt-get update; apt-get -y install kali-linux-top10'
sudo docker commit $(sudo docker ps -lq) kali:v1

echo "To access the Kali server run 'sudo docker run -it kali:v1 /bin/bash'."
echo "To save changes to the server run 'sudo docker commit $(sudo docker ps -lq) kali:vN', where N is a number"
echo "To run the saved server use 'sudo docker run -it kali:vN /bin/bash'."
```

Sources
-------
* https://docs.docker.com/engine/installation/linux/ubuntulinux/
* https://www.kali.org/news/official-kali-linux-docker-images/
