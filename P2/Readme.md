# Part 2: Discovering a VXLAN

## Create the network device

## Connect all device together



## Give ip address to all device

To make routing 

### Give ip address to router-1

`sudo ip address change aa.bb.cc.dd/mask dev enp0s0`
`sudo ip address change aa.bb.cc.dd/mask dev enp0s1`

### Give ip address to router-2

`sudo ip address change aa.bb.cc.dd/mask dev enp0s0`
`sudo ip address change aa.bb.cc.dd/mask dev enp0s1`

### Give ip address to host-1

`sudo ip address change 30.1.1.1/24 dev enp0s0`

### Give ip address to host-2

`sudo ip address change 30.1.1.2/24 dev enp0s0`


## Configure VXLAN

### VXLAN 

```bash
ip -4 link add vxlan100 type vxlan \
  id 100 \
  dstport 4789 \
  local 2001:db8:1::1 \
  group ff05::100 \
  dev eth0 \
  ttl 5
