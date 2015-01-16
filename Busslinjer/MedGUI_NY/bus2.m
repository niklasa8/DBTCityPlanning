function fastest_trip = bus2(node_source,graph_data,time,day)

load('graph_data.mat','walk_all_shortest_path')%,'intnd_count','intnd_map','id_map')
load('data_umea.mat','bus_stop_nodes')
load('busTo_bsDay1.mat','busTo_bs')
load('busMapInt.mat')
load('busMap.mat')

%% Skapar busTo_bs
n_stops = max(size(busMap));

%busTo_bs - bus to bus station. Används på följande vis: busTo_bs{d,t}(i,j)
%d: Veckoda(ar) - 1=Måndag-Torsdag, 2=Fredag, 3=Lördag, 4=Söndag.
%i: Ett heltal mellan 1 och antalet busshållplatser (175), anger vilken
%busshållplats man vill åka från.
%j: Busshållplats man vill åka till
%t: tiden man SENAST vill vara på busshållplatsen.
%Output: Ger tiden i timmar det tar att åka från i till j givet att man vill vara
%framme tiden t.
%% Räknar ut snabbaste vägen

for i=1:175
    bus_stop_nodes(i) = graph_data.intnd_map(graph_data.id_map(num2str(busMapInt(i)))); 
end

walkTo_bs = walk_all_shortest_path(:,bus_stop_nodes)*60; %walkTo_bs - walk to bus station. Snabbaste vägen att gå från godtycklig nod till alla busshållplatser.
i = graph_data.intnd_map(graph_data.id_map(node_source));
t = time; %i och t är 
%%dagar d = 1; Dag: 1(Mån-Tors),2(Fre),3(Lör),4(Sön)
if strcmp(day,'Monday') || strcmp(day,'Tuesday') || strcmp(day,'Wednesday') || strcmp(day,'Thursday')
    d = 1;
elseif strcmp(day,'Friday')
    d = 2;
elseif strcmp(day,'Saturday')
    d = 3;
elseif strcmp(day,'Sunday')
    d = 4;
end

%limit_walk = 30; %Algoritmen räknar inte ut hur lång tid det tar att ta sig från en plats till en annan med buss om det tar överdrivet lång tid att gå till busshållplatsen.
limit_walk = 30;
%limit_wait_time = 30;   
fastest_trip = inf(graph_data.intnd_count,1);

for j = 1:n_stops %Loop över alla slutstationer.
    
    if walkTo_bs(i,j) > limit_walk
        continue;
    end
        
    for k = 1:n_stops %Loop över alla startstationer.

        trip_plus_wait_time = busTo_bs{d,int16(t-walkTo_bs(i,j))}(k,j)/2 + walkTo_bs(:,k) + walkTo_bs(i,j);

        idx = find(trip_plus_wait_time < fastest_trip);
        
        fastest_trip(idx) = trip_plus_wait_time(idx);
        
    end
end

fastest_trip = fastest_trip/60;
end