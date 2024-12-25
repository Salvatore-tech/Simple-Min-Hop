atget id id
atnd n v

// store current distance from the source (init to infinity)
function f writetable id,20

// unknown_count: how many times i was not able to get the hop distance from the source node
// min_neigh_dist: min distance of neighbor from the source 
// min_neigh_id: id of the nearest neighbor from the source
set unknown_count 0
set min_neigh_dist 20
set min_neigh_id -1

loop
 receive d
 rdata d x y z
 
 // Am i the source node?
 if (id==x)
  function f writetable id,0
  set z 1
  data d x y z 
  send d
  mark 1
  stop
 end

  // Am i the target node?
 if (id==y) 
  mark 1
  // Loop through neighbors and pick the one with min hop distance
  for i 0 n
   vget neigh_id v i
   delay 500
   function neigh_dist readtable neigh_id
   if ((neigh_dist!="X") && (neigh_dist<min_neigh_dist))
    set min_neigh_dist neigh_dist
    set min_neigh_id neigh_id
   end
  end

  // If the min neighbor has a valid id, mark the edge and stop
  if (min_neigh_id!=-1)
    cprint "I'm " id "Target: min neigh: " min_neigh_id "hop distance: " min_neigh_dist
    edge 1 min_neigh_id
    data d x min_neigh_id 0
    send d min_neigh_id
    stop
  end
 end
  
 // Otherwise read my dist
 function my_dist readtable id

 // If i'm receiving a lower distance value, store it and update my neighbors
 if ((my_dist!="X") && (z<my_dist))
   function w writetable id,z
   inc z
   data d x y z
   send d
 else
  // Try to compute the distance again (max 2 times) 
  if (unknown_count<2)
    inc unknown_count
    data d x y my_dist
    send d
  end
 end
delay 1000