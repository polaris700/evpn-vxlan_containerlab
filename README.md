# Topology

![topology.png](figure/topology.png)


# Containerlab install

[containerlab](https://containerlab.dev/install/)

``` 
$ sudo bash -c "$(curl -sL https://get.containerlab.dev)"
```

# Usage

Containerlab ネットワークを作成

```
$ sudo containerlab deploy -t clab.yaml
```


ネットワークの状態を確認

Leaf01 に接続
```
$ sudo docker exec -it clab-evpn-leaf01 /usr/bin/vtysh
```


Routing Table

```
leaf01# show ip route
show ip route
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

O   1.1.1.1/32 [110/0] is directly connected, lo, weight 1, 00:03:20
C>* 1.1.1.1/32 is directly connected, lo, 00:03:20
O>* 1.1.1.2/32 [110/20] via 10.0.0.2, eth1, weight 1, 00:02:25
O>* 1.1.1.254/32 [110/10] via 10.0.0.2, eth1, weight 1, 00:02:25
O   10.0.0.0/30 [110/10] is directly connected, eth1, weight 1, 00:03:20
C>* 10.0.0.0/30 is directly connected, eth1, 00:03:20
O>* 10.0.0.4/30 [110/20] via 10.0.0.2, eth1, weight 1, 00:02:25
```

BGP 経路確認

```
leaf01# show bgp l2vpn evpn summary
show bgp l2vpn evpn summary
BGP router identifier 1.1.1.1, local AS number 65000 vrf-id 0
BGP table version 0
RIB entries 3, using 576 bytes of memory
Peers 1, using 717 KiB of memory
Peer groups 1, using 64 bytes of memory

Neighbor        V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt Desc
1.1.1.254       4      65000         9         7        0    0    0 00:01:22            2        2 N/A

Total number of neighbors 1
```


経路確認

```
leaf01# show bgp l2vpn evpn route
show bgp l2vpn evpn route
BGP table version is 2, local router ID is 1.1.1.1
Status codes: s suppressed, d damped, h history, * valid, > best, i - internal
Origin codes: i - IGP, e - EGP, ? - incomplete
EVPN type-1 prefix: [1]:[EthTag]:[ESI]:[IPlen]:[VTEP-IP]:[Frag-id]
EVPN type-2 prefix: [2]:[EthTag]:[MAClen]:[MAC]:[IPlen]:[IP]
EVPN type-3 prefix: [3]:[EthTag]:[IPlen]:[OrigIP]
EVPN type-4 prefix: [4]:[ESI]:[IPlen]:[OrigIP]
EVPN type-5 prefix: [5]:[EthTag]:[IPlen]:[IP]

   Network          Next Hop            Metric LocPrf Weight Path
                    Extended Community
Route Distinguisher: 1.1.1.1:2
*> [2]:[0]:[48]:[52:54:00:bb:02:00]
                    1.1.1.1                            32768 i
                    ET:8 RT:65000:100
*> [3]:[0]:[32]:[1.1.1.1]
                    1.1.1.1                            32768 i
                    ET:8 RT:65000:100
Route Distinguisher: 1.1.1.2:2
*>i[2]:[0]:[48]:[52:54:00:bb:04:00]
                    1.1.1.2                  0    100      0 i
                    RT:65000:100 ET:8
*>i[3]:[0]:[32]:[1.1.1.2]
                    1.1.1.2                  0    100      0 i
                    RT:65000:100 ET:8

Displayed 4 prefixes (4 paths)

```

# パケット確認
host01に接続
```
sudo docker exec -it clab-evpn-host01 /bin/bash

host01:/#
```

host02(192.168.0.2)宛にping を打つ

```
host01:/# ping 192.168.0.2
PING 192.168.0.2 (192.168.0.2) 56(84) bytes of data.
64 bytes from 192.168.0.2: icmp_seq=1 ttl=64 time=0.395 ms
64 bytes from 192.168.0.2: icmp_seq=2 ttl=64 time=0.191 ms
# <<中略>>
```

leaf01にてspine01向けIFでtcpdumpを実行
```
 sudo docker exec -it clab-evpn-leaf01 /bin/bash

```

```
 bash-5.1# tcpdump -i eth1 -w sample.pcap
```

pcapファイルをホストにコピー
```
 sudo docker cp clab-evpn-leaf01:/sample.pcap .
```

元のパケット(Src IP: 192.168.0.1, Dst IP: 192.168.0.2) がVXLAN(Src IP: 10.0.0.1, Dst IP: 1.1.1.2)でencapされていることがわかります。

![sample-pcap.png](figure/sample-pcap.png)




# 参考

[VXLAN: BGP EVPN with FRR](https://vincent.bernat.ch/en/blog/2017-vxlan-bgp-evpn)




