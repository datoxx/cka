ip link # show interfaces
ip addr # see ip addresses assigned to those interface
ip addr add 172.24.1.0/23 dev eth0 # se ip addesses to interface, it is not persistent, for persistent need configure in etc/network/interfaces file
route # show route table
ip route add 172.24.2.0/23 via 172.24.1.1 # add entries into the route tbales, for example configure gateway
/proc/sys/net/ipv4/ip_forward # in this file set 1 to enable  communication bettwen 2 interfcaem, but for persistent you need change configuration in /etc/sysctl.conf file net.ipv4.ip_forward=1


#dns
/etc/hosts #  write configuraton in  where  dns name map to  ip addres, for example 192.168.1.11   db
/etc/resolv.conf # dns resolution configuration file where we werite dns ip address like: nameserver 127.0.0.53
/etc/nsswitch.conf # set order to search  first in hosts on resolve.conf file
nslookup #query a host name from a dns server, or "dig" command

#network namespace
ip netns add red  #create new network namespace in linux host
ip netns add blue  #create new network namespace in linux host

ip netns  #list netwrok namespaces

sudo ip netns exec red ip link # see netwotk interface in red network namespace
or
sudo ip -n red link # see netwotk interface in red network namespace

ip link add veth-red type veth peer name veth-blue   #create virtual cable for connect two network namespace with create interfaces

ip link set veth-red netns red  #attach interface to network namespace
ip link set veth-blue netns blue  #attach interface to network namespace

ip -n red addr add 192.168.16.1/24 dev veth-red  #assign ip addresses to each namespaces
ip -n red addr add 192.168.16.2/24 dev veth-blue  #assign ip addresses to each namespaces

ip -n red link set veth-red up  # then bring up the interface on namespace
ip -n blue link set veth-blue up # then bring up the interface on namespace

ip netns exec red ping 192.168.16.2  # ping blue namespace form red namespace
sudo ip netns exec red arp # now in red network namespace's arp  see blue namespace mac addres and ip addres



# if in host has lot netwok namespcae and if you wanr to connect each other we create virtual switch for virtual network on host (linux bridge )
# for create virtual switch( linux bridge) we need to create network interface on host
ip -n red link del veth-red # delte first virtual cable which used for direct connect for red and blue namespaces

ip link add v-net-0 type bridge
ip link set dev v-net-0 up # we need to turn on this bridge interface

ip link add veth-red type veth peer name veth-red-br  # create cable for red namespace to bridge interface
ip link add veth-blue type veth peer name veth-blue-br  # create cable for red namespace to bridge interface

ip link set veth-red netns red #attach of this cable's one side to red namespace's interface
ip link set veth-red-br master v-net-0 #attach of this cable's one side to bridge interface
#same for blue namespaces
ip link set veth-blue netns blue #attach of this cable's one side to red namespace's interface
ip link set veth-blue-br master v-net-0 #attach of this cable's one side to bridge interface

ip -n red addr add 192.168.16.1/24 dev veth-red  #assign ip addresses to each namespaces
ip -n blue addr add 192.168.16.2/24 dev veth-blue  #assign ip addresses to each namespaces

ip -n red link set veth-red up  # then bring up the interface on namespace
ip -n blue link set veth-blue up # then bring up the interface on namespace

ip addr add 192.168.16.5/24 dev v-net-0 #assign ip addres to bridge

ip netns exec blue ip route add 192.168.16.0/24 via 192.168.16.5 #for reach OTHER network (LAN ) from network namespace we need to add route table entry in namespace newtrok
iptables -t nat -A POSTROUTING -s 192.168.16.0/24 -j MASQUERADE #add nat functionality to our host
ip netns exec blue ip route add default via 192.168.16.5 # reach outside network (intenet)
iptables -t nat -A POSTROUTING -dport 80 --to-destination 192.168.16.2:80 -j DNAT #form intenren can access namespace network, when request come to 80 port is redirect reqsuet to namespace with has 80 port






