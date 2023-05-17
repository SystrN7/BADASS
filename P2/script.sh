
# Router 1
ip link add br0 type bridge # create the bridge with the name br0
ip link set dev br0 up

# Set ip ip addr add 10.1.1.1/24 dev eth0 (netwok betwen router)
ip link add name vxlan10 type vxlan id 10 dev eth0 remote 10.1.1.2 local 10.1.1.1 dstport 4789
ip addr add 20.1.1.1/24 dev vxlan10 # Assing ip to

brctl addif br0 eth1
brctl addif br0 vxlan10

ip link set dev vxlan10 up


# Router 2
ip link add br0 type bridge
ip link set dev br0 up

# Set ip addr add  10.1.1.2/24 dev eth0

ip link add name vxlan10 type vxlan id 10 dev eth0 remote 10.1.1.1 local 10.1.1.2 dstport 4789
ip addr add 20.1.1.2/24 dev vxlan10
ip link set dev vxlan10 up

brctl addif br0 eth1
brctl addif br0 vxlan10

# Host 1
ip addr add 30.1.1.1/24 dev eth0

# Host 2
ip addr add 30.1.1.2/24 dev eth0