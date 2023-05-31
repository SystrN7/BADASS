# Part 1: GNS3 configuration with Docker

The objective of this first part is to set up the different software that we will use during this project, namely : 
- GNS3
- WireShark
- Docker
And configure the different docker containers that will represent our machines, and that we will use during this project.

## Install Docker

We started by installing Docker for a fedora system.

Adding the Docker repositories :
```bash
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
```

Installing Docker:
`sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`

Sources:
 - [Setup docker repository](https://docs.docker.com/engine/install/fedora/#set-up-the-repository)
 - [Install Docker Engine](https://docs.docker.com/engine/install/fedora/#install-docker-engine)

## Install GNS3

Setup dependency :
```bash
sudo dnf -y install git gcc cmake flex bison
sudo dnf -y install elfutils-libelf-devel libuuid-devel libpcap-devel
sudo dnf -y install python3-tornado python3-netifaces python3-devel python-pip python3-setuptools python3-PyQt4 python3-zmq
```

Setup Wireshark :
```bash
sudo dnf -y install wireshark
sudo usermod -a -G wireshark $(whoami)
```

Install GNS3 (Client/Server)
```bash
sudo dnf -y install gns3-server gns3-gui
```

Install Dynamips
```bash
git clone https://github.com/GNS3/dynamips
cd dynamips
mkdir build
cd build
cmake ..
sudo make install
```

Setup docker
```bash
sudo usermod -a -G docker $(whoami)
```

reboot your computer to apply the groups change to you user.

Sources:
 - [Tutorial](https://computingforgeeks.com/how-to-install-gns3-on-fedora-linux/)

## Create docker containers

### Container 1: Router

We use FFrouting image as base image of container we use FFrouting because quaggua and zebra are deprecated and not supported anymore.

We need to add daemon config to the container to run all required services/daemons (zebra, BGPD, OSPFD, ISISD).
And give the name of the services to watchfrr to automatically restart the service if it crash.

/!\ *Warning* : Frrouting image on docker hub is deprecated but the given alternative require account creation.
FUCK the alternative we use the deprecated image.

You need to build the image with this command:
`docker build -t routeur_fgalaup .`

### Container 2: Host

Is just use the alpine base image with busybox installed.

You need to build the image with this command:
`docker build -t host_fgalaup .`

## Add Container in GNS3

Run GNS3

When you open GNS3 for the first time is asking th type of server you want to use choice (local server).

Add docker container (Host / Router)

Create new project

On the main windows TopBar `Edit` > `Preferences`.

Normally a new window has opened and on the right hand side menu at the very bottom there is a `Docker` menu `Docker containers` click.

 - Click on `New`.
 - New windows open select `Existing image`.
 - Type Name `routeur_fgalaup`/`host_fgalaup`.
 - Choice right number of adapter 1 for host 3 for router.
 - Click on `Next >` and `Finish`.

Select the machine you have just created and click `Edit`.

In general setting change the following option :
 - For router set `Category` as `Routers`
 - You can change icon with `Symbol` fields.

Click on `ok` to close `Docker container template configuration`  window.
Click on `ok` to close `Preferences` window.

Click on the left toolbar on the icon with four sub icon with title `Browse all devices`.

Drag and drop the previously added devices in main area to add.

Start the simulation with green play button on the top bar.

Connect to the router and host to check if is working.

Right click on the device and click on `Console` to see the main docker process and `Auxiliary Console` to create new shell in the container.

Tada the part one is over.

If you want connect the devices together select on the left toolbar the wire.

Then click on the device you want to connect, choose the network interface you want to connect to and then click on the second device you want to connect to and choose network interface to connect to.

## Sources
 - [Tuto for project part 1](https://www.youtube.com/watch?v=D4nk5VSUelg)
