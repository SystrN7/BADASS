for container in `docker ps -q`; do 
    # Get container info
    container_name=$(docker inspect --format='{{.Name}}' $container)
    container_hostname=$(docker exec -it $container hostname)
    container_hostname=${container_hostname::-1}
    
    echo "----------------------------------------"
    echo  "Host: $container_hostname"
    echo  "Container: $container_name"
    echo  "Container ID: $container"

    # Router 1 (VTEP)
    if [ "$container_hostname" == "routeur_fgalaup-1" ]; then
        echo " - routeur_fgalaup-1 -"
        docker exec $container bash -c " \
        ip address add 20.1.1.1/24 dev eth0 && \
        ip link add name vxlan10 type vxlan id 10 group 239.1.1.1 dstport 4789 dev eth0 && \
        ip link add name br0 type bridge && \
        ip link set br0 up && \
        ip link set vxlan10 up && \
        ip link set vxlan10 master br0 && \
        ip link set eth1 master br0"
    fi

    # Routeur 2 (VTEP)
    if [ "$container_hostname" == "routeur_fgalaup-2" ]; then
        echo " - routeur_fgalaup-2 -"
        docker exec $container bash -c " \
        ip address add 20.1.1.2/24 dev eth0 && \
        ip link add name vxlan10 type vxlan id 10 group 239.1.1.1 dstport 4789 dev eth0 && \
        ip link add name br0 type bridge && \
        ip link set br0 up && \
        ip link set vxlan10 up && \
        ip link set vxlan10 master br0 && \
        ip link set eth1 master br0"
    fi

    # Host 1
    if [ "$container_hostname" == "host_fgalaup-1" ]; then
        echo " - host_fgalaup-1 -"
        docker exec $container bash -c "ip address add 30.1.1.1/24 dev eth0"
    fi

    # Host 2
    if [ "$container_hostname" == "host_fgalaup-2" ]; then
        echo " - host_fgalaup-2 -"
        docker exec $container bash -c "ip address add 30.1.1.2/24 dev eth0"
    fi
done
