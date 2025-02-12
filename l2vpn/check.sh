
node1=clab-evpn-l2vpn-N1
node2=clab-evpn-l2vpn-N2
sw1=clab-evpn-l2vpn-sw01

host1=clab-evpn-l2vpn-host01

dir=/tmp/sample1

# N2 IF up
echo "sw1 br0 up"
docker exec -it $sw1 ip link set dev br0 up

sleep 30

# Check status
echo "N1 ip addr" >$dir/n1_before.log
docker exec -it $node1 ip addr >>$dir/n1_before.log

echo "N1 show ip route" >>$dir/n1_before.log
docker exec -it $node1 vtysh -c "show ip route" >>$dir/n1_before.log

echo "N1 show bgp" >>$dir/n1_before.log
docker exec -it $node1 vtysh -c "show bgp summary" >>$dir/n1_before.log

echo "N1 show bgp l2vpn evpn" >>$dir/n1_before.log
docker exec -it $node1 vtysh -c "show bgp l2vpn evpn" >>$dir/n1_before.log

sleep 0.5

docker exec -it $host1 ping -c 5 192.168.0.2

echo "N1 ip addr" >$dir/n1_after.log
docker exec -it $node1 ip addr >>$dir/n1_after.log

echo "N1 show bgp" >>$dir/n1_after.log
docker exec -it $node1 vtysh -c "show bgp summary" >>$dir/n1_after.log

echo "N1 show bgp l2vpn evpn" >>$dir/n1_after.log
docker exec -it $node1 vtysh -c "show bgp l2vpn evpn" >>$dir/n1_after.log

echo "Copy the log file"
docker cp $node1:/var/log/frr/frr.log $dir/
