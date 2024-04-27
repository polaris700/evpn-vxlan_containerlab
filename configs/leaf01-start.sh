ip link add br100 type bridge
ip link set dev br100 up
ip link add vxlan100 type vxlan id 100 dstport 4789 nolearning
ip link set dev eth2 master br100
ip link set dev eth2 promisc on
ip link set dev eth2 up
ip link set dev vxlan100 master br100
ip link set dev vxlan100 promisc on
ip link set dev vxlan100 up
