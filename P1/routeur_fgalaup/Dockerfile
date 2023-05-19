# This image is created to be used as a base image to be an end network node (computer/server)
FROM frrouting/frr:latest

# Copy the daemons config file to the container (this file start BGPD, OSPFD, ISISD)
COPY ./deamons.config /etc/frr/daemons

RUN touch /etc/frr/zebra.conf
RUN touch /etc/frr/bgpd.conf
RUN touch /etc/frr/ospfd.conf
RUN touch /etc/frr/isisd.conf

# Configure the watchfrr to auto restart the frr daemons if it fails
# https://github.com/FRRouting/frr/blob/master/tools/frrcommon.sh.in
# ENV DAEMONS=