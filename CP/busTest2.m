%% Räknar ut snabbaste vägen

for i=1:175
    bus_stop_nodes(i) = intnd_map(id_map(num2str(busMapInt(i)))); 
end

walkTo_bs = walk_all_shortest_path(:,bus_stop_nodes)*60; %walkTo_bs - walk to bus station. Snabbaste vägen att gå från godtycklig nod till alla busshållplatser.
dest = intnd_map(id_map('444493179'));
t = 800; %i och t är 
d = 1; % Dag: 1(Mån-Tors),2(Fre),3(Lör),4(Sön)
limit_walk = 30; %Algoritmen räknar inte ut hur lång tid det tar att ta sig från en plats till en annan med buss om det tar överdrivet lång tid att gå till busshållplatsen.
limit_wait_time = 30;   
fastest_trip = inf(intnd_count,1);
n_stops = 175;

for j = 1:n_stops %Loop över alla slutstationer.
    
    if walkTo_bs(i,j) > limit_walk
        continue;
    end
    
    times = allToOne(Dep,j,d,int32(t-walkTo_bs(dest,j)),n_stops);

    for k = 1:n_stops %Loop över alla startstationer.
                
        trip_plus_wait_time = times(k) + walkTo_bs(:,k) + walkTo_bs(dest,j);

        idx = find(trip_plus_wait_time < fastest_trip);
        
        fastest_trip(idx) = trip_plus_wait_time(idx);
        
    end
end

%Denna del räknar ut snabbaste vägen att ta sig från alla noder till i med buss. 