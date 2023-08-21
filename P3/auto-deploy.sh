for container in `docker ps -q`; do 
    # Get container info
    container_name=$(docker inspect --format='{{.Name}}' $container)
    container_hostname=$(docker exec -it $container hostname)
    container_hostname=${container_hostname::-1}
    
    echo "----------------------------------------"
    echo  "Host: $container_hostname"
    echo  "Container: $container_name"
    echo  "Container ID: $container"

    
    # Routeur 1 (route-reflector)
    if [ "$container_hostname" == "routeur_fgalaup-1" ]; then
        echo " - routeur_fgalaup-1 -"
        docker exec $container vtysh \
            -c "conf t" \
            -c "hostname fgalaup_routeur-1" \
            -c "no ipv6 forwarding" \
            -c "interface eth0" \
            -c "ip address 10.1.1.1/30" \
            -c "interface eth1" \
            -c "ip address 10.1.1.5/30" \
            -c "interface eth2" \
            -c "ip address 10.1.1.9/30" \
            -c "interface lo" \
            -c "ip address 1.1.1.1/32" \
            -c "router bgp 1" \
            -c "neighbor ibgp peer-group" \
            -c "neighbor ibgp remote-as 1" \
            -c "neighbor ibgp update-source lo" \
            -c "bgp listen range 1.1.1.0/29 peer-group ibgp" \
            -c "address-family l2vpn evpn" \
            -c "neighbor ibgp activate" \
            -c "neighbor ibgp route-reflector-client" \
            -c "exit-address-family" \
            -c "router ospf" \
            -c "network 0.0.0.0/0 area 0" \
            -c "line vty"
    fi

    # Routeur 2 (leaf)
    if [ "$container_hostname" == "routeur_fgalaup-2" ]; then
        echo " - routeur_fgalaup-2 -"

        docker exec $container bash -c " \
            ip link add br0 type bridge; \
            ip link set dev br0 up; \
            ip link add vxlan10 type vxlan id 10 dstport 4789; \
            ip link set dev vxlan10 up; \
            brctl addif br0 vxlan10; \
            brctl addif br0 eth1"

        docker exec $container vtysh \
            -c "conf t" \
            -c "hostname fgalaup_routeur-2" \
            -c "no ipv6 forwarding" \
            -c "interface eth0" \
            -c "ip address 10.1.1.2/30" \
            -c "ip ospf area 0" \
            -c "interface lo" \
            -c "ip address 1.1.1.2/32" \
            -c "ip ospf area 0" \
            -c "router bgp 1" \
            -c "neighbor 1.1.1.1 remote-as 1" \
            -c "neighbor 1.1.1.1 update-source lo" \
            -c "address-family l2vpn evpn" \
            -c "neighbor 1.1.1.1 activate" \
            -c "advertise-all-vni" \
            -c "exit-address-family" \
            -c "router ospf"
    fi

    # Routeur 3 (leaf)
    if [ "$container_hostname" == "routeur_fgalaup-3" ]; then
        echo " - routeur_fgalaup-3 -"

        docker exec $container bash -c " \
            ip link add br0 type bridge; \
            ip link set dev br0 up; \
            ip link add vxlan10 type vxlan id 10 dstport 4789; \
            ip link set dev vxlan10 up; \
            brctl addif br0 vxlan10; \
            brctl addif br0 eth1"

        docker exec $container vtysh \
            -c "conf t" \
            -c "hostname fgalaup_routeur-3" \
            -c "no ipv6 forwarding" \
            -c "interface eth0" \
            -c "ip address 10.1.1.6/30" \
            -c "ip ospf area 0" \
            -c "interface lo" \
            -c "ip address 1.1.1.3/32" \
            -c "ip ospf area 0" \
            -c "router bgp 1" \
            -c "neighbor 1.1.1.1 remote-as 1" \
            -c "neighbor 1.1.1.1 update-source lo" \
            -c "address-family l2vpn evpn" \
            -c "neighbor 1.1.1.1 activate" \
            -c "advertise-all-vni" \
            -c "exit-address-family" \
            -c "router ospf"
    fi

    # Routeur 4 (leaf)
    if [ "$container_hostname" == "routeur_fgalaup-4" ]; then
        echo " - routeur_fgalaup-4 -"

        docker exec $container bash -c " \
            ip link add br0 type bridge; \
            ip link set dev br0 up; \
            ip link add vxlan10 type vxlan id 10 dstport 4789; \
            ip link set dev vxlan10 up; \
            brctl addif br0 vxlan10; \
            brctl addif br0 eth1"

        docker exec $container vtysh \
            -c "conf t" \
            -c "hostname fgalaup_routeur-4" \
            -c "no ipv6 forwarding" \
            -c "interface eth0" \
            -c "ip address 10.1.1.10/30" \
            -c "ip ospf area 0" \
            -c "interface lo" \
            -c "ip address 1.1.1.4/32" \
            -c "ip ospf area 0" \
            -c "router bgp 1" \
            -c "neighbor 1.1.1.1 remote-as 1" \
            -c "neighbor 1.1.1.1 update-source lo" \
            -c "address-family l2vpn evpn" \
            -c "neighbor 1.1.1.1 activate" \
            -c "advertise-all-vni" \
            -c "exit-address-family" \
            -c "router ospf"
    fi

    # Host 1
    if [ "$container_hostname" == "host_fgalaup-1" ]; then
        echo " - host_fgalaup-1 -"
        docker exec $container ip address add 30.1.1.1/24 dev eth0
    fi

    # Host 2
    if [ "$container_hostname" == "host_fgalaup-2" ]; then
        echo " - host_fgalaup-2 -"
        docker exec $container ip address add 30.1.1.2/24 dev eth0
    fi

    # Host 3
    if [ "$container_hostname" == "host_fgalaup-3" ]; then
        echo " - host_fgalaup-3 -"
        docker exec $container ip address add 30.1.1.3/24 dev eth0
    fi
done
