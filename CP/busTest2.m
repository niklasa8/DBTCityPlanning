%% R�knar ut snabbaste v�gen

for i=1:175
    bus_stop_nodes(i) = intnd_map(id_map(num2str(busMapInt(i)))); 
end

walkTo_bs = walk_all_shortest_path(:,bus_stop_nodes)*60; %walkTo_bs - walk to bus station. Snabbaste v�gen att g� fr�n godtycklig nod till alla bussh�llplatser.
dest = intnd_map(id_map('444493179'));
t = 800; %i och t �r 
d = 1; % Dag: 1(M�n-Tors),2(Fre),3(L�r),4(S�n)
limit_walk = 30; %Algoritmen r�knar inte ut hur l�ng tid det tar att ta sig fr�n en plats till en annan med buss om det tar �verdrivet l�ng tid att g� till bussh�llplatsen.
limit_wait_time = 30;   
fastest_trip = inf(intnd_count,1);
n_stops = 175;

for j = 1:n_stops %Loop �ver alla slutstationer.
    
    if walkTo_bs(i,j) > limit_walk
        continue;
    end
    
    times = allToOne(Dep,j,d,int32(t-walkTo_bs(dest,j)),n_stops);

    for k = 1:n_stops %Loop �ver alla startstationer.
                
        trip_plus_wait_time = times(k) + walkTo_bs(:,k) + walkTo_bs(dest,j);

        idx = find(trip_plus_wait_time < fastest_trip);
        
        fastest_trip(idx) = trip_plus_wait_time(idx);
        
    end
end

%Denna del r�knar ut snabbaste v�gen att ta sig fr�n alla noder till i med buss. 