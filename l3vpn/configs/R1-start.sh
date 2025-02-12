sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.forward=1
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

ip link set dev eth0 down
ip link add br100 type bridge
ip link set br100 address aa:c1:ab:70:00:01
ip link set dev br100 up
ip link add vxlan100 type vxlan id 100 dstport 4789 nolearning
ip link set eth2 address aa:c1:ab:71:00:a1
ip link set dev eth2 master br100
ip link set dev eth2 promisc on
ip link set dev eth2 up
ip link set dev vxlan100 master br100
ip link set dev vxlan100 promisc on
ip link set dev vxlan100 up

# ip addr add 192.168.0.254/24 dev br100 

# tcpdump -c 1000 -i eth1 -w N1-eth1.pcap &

# tcpdump -c 1000 -i eth2 -w N1-eth2.pcap &
