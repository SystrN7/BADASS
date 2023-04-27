# Glossary
This document is a glossary of terms used in this network project.


## Concepts

### Autonomous System
An AS (Autonomous System) is a set of routers placed under the control of an entity (ISP, company, ...) and which share the same routing policy.
We can identify which AS belongs to which routers thanks to its ASN (Autonomous System Number) which is a unique number initially coded on 16 bits then extended on 32 bits in 2007.

The ASN is delivered to the different entities by a RIR (Regional Internet Registry) whose mission is to deliver IP addresses and AS numbers in a given geographical area.

The RIRs get their IP addresses and AS numbers from IANA (Internet Assigned Numbers Authority) which is in charge of their distribution at the global level.

## Protocol

### RIP
RIP, Routing Information Protocol, is an older protocol. RIP routers periodically multicast their entire routing tables to the network, rather than just the changes as OSPF does. RIP measure routes by hops (the number of routers between the source and destination), and sees any destination over 15 hops as unreachable. RIP is simple to set up, but OSPF is a better choice for speed, efficiency, and scalability.

### OSPF
OSPF means Open Shortest Path First. OSPF is an interior gateway protocol (IGP); it is for LANs and LANs connected over the Internet. Every OSPF router in your network contains the topology for the whole network, and calculates the best paths through the network. OSPF automatically multicasts any network changes that it detects. You can divide up your network into areas to keep routing tables manageable; the routers in each area only need to know the next hop out of their areas rather than the entire routing table for your network.

### IS-IS
Intermediate System to Intermediate System (IS-IS) is a routing protocol designed to move information efficiently within a computer network, a group of physically connected computers or similar devices.
It accomplishes this by determining the best route for data through a Packet-switched network. This is done by using a routing metric to assign a cost to each possible route. The route with the lowest total cost is then chosen to route packets.

### BGP
Border Gateway Protocol (BGP) is a standardized protocol designed to exchange routing and reachability information among autonomous systems (AS) on the Internet.


### EVPN
EVPN is a new Ethernet VPN standard that is designed to provide a scalable and efficient way to extend Layer 2* networks across multiple sites.

* Layer 2 is the second layer of the OSI model. It is the data link layer, which is responsible for the physical transmission of data over a network.

### VXLAN
Virtual Extensible LAN (VXLAN) is a network virtualization technology that attempts to address the scalability problems associated with large cloud computing deployments.

### 

### Zebra
 ?? is the main part 

## Tools

### GNS3
GNS3 is a graphical network simulator that allows you to design complex network topologies and emulate them using virtual machines/docker container.

### Zebra
Zebra is a routing software suite that includes implementations of the BGP, OSPF, RIP, and IS-IS routing protocols.
Zebra is dead project.

### Quagga
Quagga is a fork of Zebra.
quagga is a dead project.

### FRRouting
FRRouting is an fork of Quagga.
FRRouting is currently active project.