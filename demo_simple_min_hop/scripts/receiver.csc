atget id id
atnd n v

// hop_dist: current distance from the source (init to infinity)
// unknown_count: how many times i was not able to get the hop distance from the source node
// min_neigh_dist: min distance of neighbor from the source 
// min_neigh_id: id of the nearest neighbor from the source
set hop_dist 20
set unknown_count 0
set min_neigh_dist 20
set min_neigh_id -1

loop
 receive d
 rdata d x y z

 // Check if i am i the source node, if so the hop_dist is set to 0
 if (id==x)
  set hop_dist 0
  set z hop_dist
  inc z
  data d x y z 
  send d
  mark 1
  function x writetable id,hop_dist
  stop
 end

  // Check if i am i the target node
 if (id==y)
  mark 1
  // Loop through neighbors and pick the one with min hop distance
  for i 0 n
   vget neigh_id v i
   function neigh_dist readtable neigh_id
   if ((neigh_dist!="X") && (neigh_dist != -1) && (neigh_dist<=min_neigh_dist))
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
 
 // I'm receiving a valid neighbor distance 
 if ((z<hop_dist) && (z!=-1))
   // I update my distance to z+1 and send to my neighbors (path modeling)
   inc z
   set hop_dist z
   data d x y hop_dist
   send d
   function x writetable id,hop_dist
 end
 // I'm receiving an unknown distance and i'm not able to compute my distance for 3 times (path discovery)
 if ((z==-1) && (hop_dist==20) && (unknown_count<3))
   inc unknown_count
   data d x y z
   send d
 end

delay 1000