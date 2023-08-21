# Router 1 (VTEP)
docker exec -it tender_solomon bash -c " \
    ip address add 20.1.1.1/24 dev eth0 && \
    ip link add name vxlan10 type vxlan id 10 remote 20.1.1.2 dstport 4789 dev eth0 && \
    ip link add name br0 type bridge && \
    ip link set br0 up && \
    ip link set vxlan10 up && \
    ip link set vxlan10 master br0 && \
    ip link set eth1 master br0"

# Routeur 2 (VTEP)
docker exec -it hungry_solomon bash -c " \
    ip address add 20.1.1.2/24 dev eth0 && \
    ip link add name vxlan10 type vxlan id 10 remote 20.1.1.1 dstport 4789 dev eth0 && \
    ip link add name br0 type bridge && \
    ip link set br0 up && \
    ip link set vxlan10 up && \
    ip link set vxlan10 master br0 && \
    ip link set eth1 master br0"

# Host 1
docker exec -it affectionate_proskuriakova bash -c "ip address add 30.1.1.1/24 dev eth0"

# Host 2
docker exec -it inspiring_jennings bash -c "ip address add 30.1.1.2/24 dev eth0"
