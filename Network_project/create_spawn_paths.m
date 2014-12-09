load('graph_data.mat','CGM_sparse','intnd_count')

spawn_locs = 1:500;
n_spawnNds = 500;

for j = spawn_locs
    
    j/n_spawnNds
    [~,spawn_loc_paths{j}] = graphshortestpath(CGM_sparse,j);

end

save ('graph_data.mat','spawn_locs','spawn_loc_paths','-append')

clear