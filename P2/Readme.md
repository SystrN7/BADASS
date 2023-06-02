# Part 2: Discovering a VXLAN

The aim of this section is to create a basic VXLAN between two computers.

This section will be divided into two sub-sections:

 - The first part involves configuring a VXLAN statically, i.e. each VTEP will systematically send all its traffic to the address of the second VTEP. (To do this, you need to use the IP address of the second VTEP in the configuration of the first VTEP and vice versa). This connection is known as peer-to-peer.

 - The second part will involve dynamic configuration using a multicast address (each time a new packet is received by a VTEP with an unknown Mac address as its destination, the VTEP will send a multicast message to all the other VTEPs present on this multicast).


## Create the network structure (router, switch, host and link)

The current network diagram is the following:

![Network diagram](TODO: add image)

## Configure ip address

To enable the various network elements to communicate with each other, we need to give them a valid IP address.
This configuration is common to both sub-sections.

To set the ip address we use the command `ip address add` with the following syntax:
`ip address add <ip_address>/<mask> dev <interface_name>`

### Give ip address to router-1

`ip address add 20.1.1.1/24 dev eth0`

### Give ip address to router-2

`ip address add 20.1.1.2/24 dev eth0`

### Give ip address to host-1

`ip address add 30.1.1.1/24 dev eth0`

### Give ip address to host-2

`ip address add 30.1.1.2/24 dev eth0`


## Configure VXLAN

For p2p configuration we need to specify the ip address of the other VTEP.
```bash
ip link add name <name> type vxlan id <vni> remote <destination_ip> dstport <destination_port> dev <device>
```
for multicast configuration we need to specify the multicast ip address.
```bash
ip link add name <name> type vxlan id <vni> group <multicast_ip> dstport <destination_port> dev <device>
```

Explanation of the command:
 - `ip` - Command to manage the network device
 - `link ` - Subcommand to manage the network device.
 - `id ID` - Specifies the VXLAN Network Identifier (VNI) to use.
 - `local IPADDR` - specifies the source IP address to use in outgoing packets. (optional)
 - `remote IPADDR` - specifies the remote VXLAN tunnel endpoint IP address to use for outgoing packets.
 - `group IPADDR` - specifies the multicast IP address to join. This parameter cannot be specified with the remote parameter. is required for multicast.
 - `dstport PORT` - specifies the UDP destination port to use for outgoing packets. The standard port for VXLAN is 4789.
 - `dev NAME` - specifies the physical device to use for tunnel endpoint communication.

Other option:
 - `-4` - Option to specify the internet protocol version in this case IPv4 (optional)
 - `ttl TTL` - specifies the TTL* to use for outgoing packets. (in somme case is can be usefull to specify a ttl)

*TTL(Time to leave) is the number of hop the packet can do before being dropped.

We need to create a bridge to connect the VXLAN to the physical network device.

With ip command :
```bash
ip link add name br0 type bridge # create the bridge with the name br0
ip link set br0 up # start the bridge
ip link set vxlan10 up # start the vxlan
ip link set vxlan10 master br0 # connect the vxlan to the bridge
ip link set eth1 master br0 # connect the physical device to the bridge
```

With brctl command (A specialized command to manage bridge) :
```bash
brctl addbr br0 # create the bridge with the name br0
brctl addbr br0 # create the bridge with the name br0
brctl addif br0 vxlan10 # connect the vxlan to the bridge
brctl addif br0 eth1 # connect the physical device to the bridge
```

### Statics VXLAN

#### VXLAN for router-1 (VTEP)

Create the VXLAN
```bash
ip link add name vxlan10 type vxlan id 10 remote 20.1.1.2 dstport 4789 dev eth0
ip link add name br0 type bridge
ip link set br0 up
ip link set vxlan10 up
ip link set vxlan10 master br0
ip link set eth1 master br0
```

#### VXLAN for router-2 (VTEP)

Create the VXLAN
```bash
ip link add name vxlan10 type vxlan id 10 remote 20.1.1.1 dstport 4789 dev eth0
ip link add name br0 type bridge
ip link set br0 up
ip link set vxlan10 up
ip link set vxlan10 master br0
ip link set eth1 master br0
```

## create VXLAN (Dynamic/Multicast)

The goal of the multicast is to send the packet to all the device in the network. The multicast is a group of device that listen to a specific ip address. When a device send a packet to the multicast ip address all the device in the multicast group receive the packet.

To improve performance and limit the number of multi-castes on the network, each VTEP creates a table of correspondence between Mac addresses and the VTEP's IP address.

This table can be displayed with the following command: `bridge fdb show dev vxlan10`

<!-- TODO: give a real example -->
Example of output:
```
00:00:00:00:00:00 dst ff05::100 via eth0 self permanent
50:54:33:00:00:0b dst 2001:db8:3::1 self
50:54:33:00:00:08 dst 2001:db8:1::1 self
```

### VXLAN for router-1 (VTEP)

Create the VXLAN
```bash
ip link add name vxlan10 type vxlan id 10 group 239.1.1.1 dstport 4789 dev eth0
ip link add name br0 type bridge
ip link set br0 up
ip link set vxlan10 up
ip link set vxlan10 master br0
ip link set eth1 master br0
```

### VXLAN for router-2 (VTEP)

Create the VXLAN
```bash
ip link add name vxlan10 type vxlan id 10 group 239.1.1.1 dstport 4789 dev eth0
ip link add name br0 type bridge
ip link set br0 up
ip link set vxlan10 up
ip link set vxlan10 master br0
ip link set eth1 master br0
```


## Sources
- [Tuto for project part 2](https://www.youtube.com/watch?v=u1ka-S6F9UI&t=2s)
- [Youtube VXLAN (Network Direction)](https://www.youtube.com/watch?v=YNqKDI_bnPM&list=PLDQaRcbiSnqFe6pyaSy-Hwj8XRFPgZ5h8)
- [A blog available in french/english is for ](https://vincent.bernat.ch/en/blogn)
