# To configure the router
touch /etc/frr/vtysh.conf
vtysh
configure terminal # config t


# Router 1 Main

hostname fgalaup_routeur-1
no ipv6 forwarding
!
interface eth0
    ip address 10.1.1.1/30
!
interface eth1
    ip address 10.1.1.5/30
!
interface eth2
    ip address 10.1.1.9/30
!
interface lo
    ip address 1.1.1.1/32
!
router bgp 1
    neighbor ibgp peer-group
    neighbor ibgp remote-as 1
    neighbor ibgp update-source lo
    bgp listen range 1.1.1.0/29 peer-group ibgp
    !
    address-family l2vpn evpn
        neighbor ibgp activate
        neighbor ibgp route-reflector-client
    exit-address-family
!
router ospf
    network 0.0.0.0/0 area 0
!
line vty
!

# Router 2 leaf 1 (Top of rack)
ip link add br0 type bridge
ip link set br0 up
ip link add vxlan10 type vxlan id 10 dstport 4789
ip link set vxlan10 up
brctl addif br0 vxlan10
brctl addif br0 eth1



hostname fgalaup_routeur-2
no ipv6 forwarding
!
interface eth0
    ip address 10.1.1.2/30
    ip ospf area 0
!
interface lo
    ip address 1.1.1.2/32
    ip ospf area 0
!
router bgp 1
    neighbor 1.1.1.1 remote-as 1
    neighbor 1.1.1.1 update-source lo
    !
    address-family l2vpn evpn
        neighbor 1.1.1.1 activate
        advertise-all-vni
    exit-address-family
!

router ospf
!

# Router 3 leaf 2 (Top of rack)

hostname fgalaup_routeur-3
no ipv6 forwarding
!
interface eth1
    ip address 10.1.1.6/30
    ip ospf area 0
!
interface lo
    ip address 1.1.1.3/32
    ip ospf area 0
!
router bgp 1
    neighbor 1.1.1.1 remote-as 1
    neighbor 1.1.1.1 update-source lo
    !
    address-family l2vpn evpn
        neighbor 1.1.1.1 activate
    exit-address-family
!
router ospf
!

# Router 4 leaf 3 (Top of rack)

ip link add br0 type bridge
ip link set br0 up
ip link add vxlan10 type vxlan id 10 dstport 4789
ip link set vxlan10 up
brctl addif br0 vxlan10
brctl addif br0 eth0

hostname fgalaup_routeur-4
no ipv6 forwarding
!
interface eth2
    ip address 10.1.1.10/30
    ip ospf area 0
!
interface lo
    ip address 1.1.1.4/32
    ip ospf area 0
!
router bgp 1
    neighbor 1.1.1.1 remote-as 1
    neighbor 1.1.1.1 update-source lo
    !
    address-family l2vpn evpn
        neighbor 1.1.1.1 activate
        advertise-all-vni
    exit-address-family
!
router ospf
!

# Host 1

ip address add 20.1.1.1/24 dev eth0

# Host 2

ip address add 20.1.1.2/24 dev eth0

# Host 3

ip address add 20.1.1.3/24 dev eth0

