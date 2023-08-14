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
 - [Set up the Docker repository](https://docs.docker.com/engine/install/fedora/#set-up-the-repository)
 - [Install Docker Engine](https://docs.docker.com/engine/install/fedora/#install-docker-engine)

## Install GNS3

Setup dependencies :
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

Reboot your computer to apply the group changes to your user.

Sources:
 - [Tutorial](https://computingforgeeks.com/how-to-install-gns3-on-fedora-linux/)

## Create docker containers

### Container 1: Router

We use the FRRouting image as the base container image because Quagga and Zebra are deprecated and not supported anymore.

We need to add a daemon config to the container to run all required services/daemons (Zebra, BGPD, OSPFD, ISISD).
We also need to give the name of the services to watchfrr to automatically restart a service if it crashes.

/!\ *Warning* : the FRRouting image on Docker Hub is deprecated but the given alternatives require an account creation.
FUCK the alternatives, we will use the deprecated image.

You need to build the image with this command:
`sudo docker build -t routeur_fgalaup .`

### Container 2: Host

The host simply uses the Alpine base image with busybox installed.

You need to build the image with this command:
`sudo docker build -t host_fgalaup .`

## Add Container in GNS3

Run GNS3.

When you open GNS3 for the first time it asks the type of server you want to use. Select the local server option.

Add a Docker container (Host / Router).

Create a new project.

On the main window's menu, go to `Edit` > `Preferences`.

Normally a new window has opened and on the right hand side menu at the very bottom there is a `Docker` menu. Click on `Docker containers`.

 - Click on `New`.
 - A new window opens, select `Existing image`.
 - Type name `routeur_fgalaup`/`host_fgalaup`.
 - Enter the right number of adapters: 1 for the host, 3 for the router.
 - Click on `Next >` and `Finish`.

Select the machine you have just created and click `Edit`.

In the general settings change the following options :
 - For router set `Category` as `Routers`
 - You can change the icon with `Symbol` fields.

Click on `ok` to close the `Docker container template configuration` window.
Click on `ok` to close the `Preferences` window.

Click on the left toolbar on the 4-icon `All Devices`.

Drag and drop the previously added devices in main area to add.

Start the simulation with the green play button on the top bar.

Connect to the router and host to check if everything works.

Right click on the device and click on `Console` to see the main Docker process and `Auxiliary Console` to create a new shell in the container.

And voilà, the part one is over.

If you want to connect the devices together, select the wire on the left toolbar.

Then click on the device you want to connect, choose the network interface you want to connect to and then click on the second device you want to connect to and choose network interface to connect to.

## Sources
 - [Tuto for project part 1](https://www.youtube.com/watch?v=D4nk5VSUelg)
