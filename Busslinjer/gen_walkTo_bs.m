% Create new walkTo_bs
load('graph_data');
walkTo_bs = walk_all_shortest_path(:,bus_stop_nodes)*60; %walkTo_bs - walk to bus station. Snabbaste v�gen att g� fr�n godtycklig nod till alla bussh�llplatser.
save('Data/walkTo_bs');