# Part 1: GNS3 configuration with Docker

## Create Virtual Machines (VirtualBox)


## Install Docker


## Install GNS3



## Create docker containers



## Container 1: Router

We use FFrouting image as base image of container we use FFrouting because quaggua and zebra are deprecated and not supported anymore.

We need to add daemon config to the container to run all required services/daemons (zebra, BGPD, OSPFD, ISISD).
And give the name of the services to watchfrr to automatically restart the service if it crash.

/!\ *Warning* : Frrouting image on docker hub is deprecated but the given alternative require account creation.
FUCK the alternative we use the deprecated image.


## Container 2: Host

Is just use the alpine base image with busybox installed.

## Start Container in GNS3




connect to the router and host to check if is working.

