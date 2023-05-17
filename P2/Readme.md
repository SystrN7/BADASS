# Part 2: Discovering a VXLAN

## Create the network device

## Connect all device together

## Give ip address to all device

The current network diagram is the following:

![Network diagram](TODO add image)

To set the ip address we use the command `ip address change` with the following syntax:
`ip address change <ip_address>/<mask dev <interface_name>`
we need to give a default gateway to the host with the command :
`ip route add default via <gateway_ip> dev <interface_name>`

### Give ip address to router-1

`ip address change 20.1.1.1/24 dev eth0`
`ip address change 30.1.1.3/24 dev eth1`

### Give ip address to router-2

`ip address change 20.1.1.2/24 dev eth0`
`ip address change 30.1.1.3/24 dev eth1`

### Give ip address to host-1

`ip address change 30.1.1.1/24 dev eth0`
`ip route add default via 30.1.1.3 dev eth0`

### Give ip address to host-2

`ip address change 30.1.1.2/24 dev eth0`
`ip route add default via 30.1.1.3 dev eth0`


## Configure VXLAN (Statics)

```bash
ip -4 link add vxlan10 type vxlan \
  id 10 \
  remote <destination_router_ip> \
  dstport 4789 \
  dev eth0 \
  ttl auto
```

`ip` - Command to manage the network device
`-4` - Option to specify the internet protocol version in this case IPv4
`link ` - Subcommand to manage the network device.
`id ID` - specifies the VXLAN Network Identifier (VNI) to use.
`remote IPADDR` - specifies the remote VXLAN tunnel endpoint IP address to use for outgoing packets.
`group IPADDR` - specifies the multicast IP address to join.  This parameter cannot be specified with the remote parameter. ?? I don't understand this parameter (but is important fo the multicast)
`local IPADDR` - specifies the source IP address to use in outgoing packets.
`dstport PORT` - specifies the UDP destination port to use for outgoing packets. The standard port for VXLAN is 4789.
`ttl TTL` - specifies the TTL* to use for outgoing packets.
`dev NAME` - specifies the physical device to use for tunnel endpoint communication.

*TTL(Time to leave) is the number of hop the packet can do before being dropped.

We need to create a bridge to connect the VXLAN to the physical network device.

```bash
ip link add br0 type bridge # create the bridge with the name br0
ip link set dev br0 up # start the bridge
ip link set dev vxlan10 up # start the vxlan
ip link set vxlan10 master br0 # connect the vxlan to the bridge
ip link set eth0 master br0 # connect the physical device to the bridge
```

### VXLAN for router-1

Create the VXLAN
```bash
ip -4 link add vxlan10 type vxlan id 10 remote 20.1.1.2 dstport 4789 dev eth0 ttl auto
```

Create the bridge and connect the VXLAN and the physical device with command above.

### VXLAN for router-2

Create the VXLAN
```bash
ip -4 link add vxlan10 type vxlan id 10 remote 20.1.1.1 dstport 4789 dev eth0 ttl auto
```
Create the bridge and connect the VXLAN and the physical device with command above.

## create VXLAN (Dynamic/Multicast)

The goal of the multicast is to send the packet to all the device in the network. The multicast is a group of device that listen to a specific ip address. When a device send a packet to the multicast ip address all the device in the multicast group receive the packet.

To create a multicast group we use the command `ip -4 link add vxlan10 type vxlan id 10 group <multicast_ip> dstport 4789 dev eth0 ttl auto`

### VXLAN for router-1

Create the VXLAN
```bash
ip -4 link add vxlan10 type vxlan id 10 group 239.1.1.1 dstport 4789 dev eth0 ttl auto
ip addr add 30.1.1.3/24 dev vxlan10
```

Create the bridge and connect the VXLAN and the physical device with command above.

### VXLAN for router-2

Create the VXLAN
```bash
ip -4 link add vxlan10 type vxlan id 10 group 239.1.1.1 dstport 4789 dev eth0 ttl auto
ip addr add 30.1.1.3/24 dev vxlan10
```
Create the bridge and connect the VXLAN and the physical device with command above.


## Souces
- [Youtube VXLAN (Network Direction)](https://www.youtube.com/watch?v=YNqKDI_bnPM&list=PLDQaRcbiSnqFe6pyaSy-Hwj8XRFPgZ5h8)
- [A blog avilable in french/english](https://vincent.bernat.ch/en/blogn)
