function fastest_trip = bus(node_source,graph_data,time)

load('graph_data.mat','walk_all_shortest_path')%,'intnd_count','intnd_map','id_map')
load('data_umea','departure_','arrival_','bus_stop','bus_stop_nodes')

%% Skapar busTo_bs
n_stops = max(size(bus_stop_nodes));
busTo_bs = zeros(n_stops,n_stops,1440);
t = 1:1440;
clear t_matrix
t_matrix(1,1,:) = t;
t_matrix = repmat(t_matrix,[n_stops,n_stops]);
idx = find(departure_);
busTo_bs(idx) = (t_matrix(idx) - departure_(idx))/60;
idx = find(busTo_bs < 0);
busTo_bs(idx) = busTo_bs(idx) + 24;

for t = 1:1440
    busTo_bs(:,:,t) = graphallshortestpaths(sparse(busTo_bs(:,:,t)));
end

%busTo_bs - bus to bus station. Anv�nds p� f�ljande vis: busTo_bs(i,j,t)
%i: Ett heltal mellan 1 och antalet bussh�llplatser (27), anger vilken
%bussh�llplats man vill �ka fr�n.
%j: Bussh�llplats man vill �ka till
%t: tiden man SENAST vill vara p� bussh�llplatsen.
%Output: Ger tiden i timmar det tar att �ka fr�n i till j givet att man vill vara
%framme tiden t.
%% R�knar ut snabbaste v�gen

walkTo_bs = walk_all_shortest_path(:,bus_stop_nodes); %walkTo_bs - walk to bus station. Snabbaste v�gen att g� fr�n godtycklig nod till alla bussh�llplatser.
i = graph_data.intnd_map(graph_data.id_map(node_source));
%t = 800; %i och t �r 
t = time; %time �r fr�n input arg
limit_walk = 0.5; %Algoritmen r�knar inte ut hur l�ng tid det tar att ta sig fr�n en plats till en annan med buss om det tar �verdrivet l�ng tid att g� till bussh�llplatsen.
limit_wait_time = 0.5;
fastest_trip = inf(graph_data.intnd_count,1);

for j = 1:n_stops %Loop �ver alla slutstationer.
    
    if walkTo_bs(i,j) > limit_walk
        continue;
    end
        
    for k = 1:n_stops %Loop �ver alla startstationer.

        trip_plus_wait_time = busTo_bs(k,j,int16(t-walkTo_bs(i,j)*60))/6 + walkTo_bs(:,k) + walkTo_bs(i,j);

        idx = find(trip_plus_wait_time < fastest_trip);
        
        fastest_trip(idx) = trip_plus_wait_time(idx);
        
    end
end

%Denna del r�knar ut snabbaste v�gen att ta sig fr�n alla noder till i med buss. 
end