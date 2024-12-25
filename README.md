## Statement
In a network of sensors deployed in a random way (e.g. 20 sensors), given 2 (prefixed) input nodes (id X, id Y), write an **algorithm that calculates the minimum number of possible hops between X and Y**. Use the IDs to identify the nodes and the **hash table** function to store the necessary data. The minimum number of hops must be stored (and logged) by node Y (destination). A special node should introduce in the network the message related to the couple of nodes (id source, id destination) of which the routing algorithm must calculate the min hop distance. Once the path is calculated the network should **enlight (mark) the selected path** (using the edge command).

## Methodology: Bidirectional Weighted Path Discovery (BWPD)
The methodology implements the BWPD ad-hoc algorithm that is composed by two steps:
1. **Forward pass** (path modeling): The aim of this step is to **compute the weight** (hop distance) between the source node X and the current i-th node. The **flooding** approach ensures that after some time, the query message from the seed node reaches the destination.

2. **Min backward pass** (path selection): From the **target node back to the source node**, at each step we pick the node having the min weight, since it guarantees to move closer to the source node. The **gossiping** approach is a perfect candidate in this step.

### FORWARD WEIGHTING PASS
In this phase, we need to **discover the routes of the WSN**, assigning a weight based on the distance from the source node. Since we have **no prior information on the network**, we apply the **flooding** approach.

Every node will receive a query message containing the source id, target id and the hop distance from the source (ex. 3#5#-1)

The hop distance can assume the following values:
1. hop_dist = -1 : the distance between the source and the node is unknown
2. hop_dist = 0 : the current node is the source node (X==id)
3. hop_dist > 0 : the distance between the source node and the current node is equal to hop_dist 

Each node is responsible for keeping the hop_dist up-to-date in the hash table, preventing data ambiguities. 

### MIN BACKWARD PASS
Once the message reaches the destination (target node Y), it can query the hash table using the id of the neighbors and pick the one with min hop distance.
After that, it will send a message to that node, flowing in a backward path from the target to the source node, using the **gossiping** approach to reduce the number of messages and preserving the energy consumption.

It’s important to say that in this phase, the weights (hop distances) of the nodes are not updated anymore.
The main action here is to **select the neighbor having the least distance from the source**, until reaching the source node.  

## ENERGY CONSUMPTION
To make the consumption easily visible, the following parameters have been increased (by more than a factor of 33000 times): 
- E_TX: the energy consumption for each sent bit, 2J
- E_TX: the energy consumption for each received bit, 1J

The following analysis will consider an average case of a WSN with 20 nodes put randomly on the map.
![image](https://github.com/user-attachments/assets/dc06ac94-f1ad-4761-8440-5da4abe7da86)

Default battery capacity = 19160J  
SENT MSG: 101 (742B)  
RECEIVEND MSG: 374 (2772B)  
SENT&RECEIVED MSG: 475 (3514B)  
TIME: 48s  

TOTAL CONSUMPTION = 742B*2J + 2772B*1J = 4256J  
Lowest node's battery: 12KJ = +65% of the original capacity  

## Simulation 
During the following demo, we’re looking at different scenarios in order to prove the robustness of the algorithm.
For timing and visual purposes the first two scenarios have a reduced amount of nodes, whereas the last contains 20 nodes. 
1. Source first: the source node is closer to the seed node than the target node. The simulation should be faster since the forward weighting pass is aided by the network topology
2. Target first: more challenging scenario, since the discovery phase takes more time to reach the source node and have meaningful hop distances
3. Average case: random WSN composed by 20 nodes, where the source and target nodes have been picked in the x direction and the seed node is placed on the bottom.



https://github.com/user-attachments/assets/59d73fdb-7001-43b9-b1f8-16b8717d5066






