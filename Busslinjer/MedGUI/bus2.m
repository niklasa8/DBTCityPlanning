function fastest_trip = bus2(node_source,graph_data,time,day)

load('graph_data.mat','walk_all_shortest_path')%,'intnd_count','intnd_map','id_map')
load('data_umea.mat','bus_stop_nodes')
load('busTo_bsDay1.mat','busTo_bs')
load('busMapInt.mat')
load('busMap.mat')

%% Skapar busTo_bs
n_stops = max(size(busMap));

%busTo_bs - bus to bus station. Anv�nds p� f�ljande vis: busTo_bs{d,t}(i,j)
%d: Veckoda(ar) - 1=M�ndag-Torsdag, 2=Fredag, 3=L�rdag, 4=S�ndag.
%i: Ett heltal mellan 1 och antalet bussh�llplatser (175), anger vilken
%bussh�llplats man vill �ka fr�n.
%j: Bussh�llplats man vill �ka till
%t: tiden man SENAST vill vara p� bussh�llplatsen.
%Output: Ger tiden i timmar det tar att �ka fr�n i till j givet att man vill vara
%framme tiden t.
%% R�knar ut snabbaste v�gen

for i=1:175
    bus_stop_nodes(i) = graph_data.intnd_map(graph_data.id_map(num2str(busMapInt(i)))); 
end

walkTo_bs = walk_all_shortest_path(:,bus_stop_nodes)*60; %walkTo_bs - walk to bus station. Snabbaste v�gen att g� fr�n godtycklig nod till alla bussh�llplatser.
i = graph_data.intnd_map(graph_data.id_map(node_source));
t = time; %i och t �r 
%%dagar d = 1; Dag: 1(M�n-Tors),2(Fre),3(L�r),4(S�n)
if strcmp(day,'Monday') || strcmp(day,'Tuesday') || strcmp(day,'Wednesday') || strcmp(day,'Thursday')
    d = 1;
elseif strcmp(day,'Friday')
    d = 2;
elseif strcmp(day,'Saturday')
    d = 3;
elseif strcmp(day,'Sunday')
    d = 4;
end

%limit_walk = 30; %Algoritmen r�knar inte ut hur l�ng tid det tar att ta sig fr�n en plats till en annan med buss om det tar �verdrivet l�ng tid att g� till bussh�llplatsen.
limit_walk = 30;
%limit_wait_time = 30;   
fastest_trip = inf(graph_data.intnd_count,1);

for j = 1:n_stops %Loop �ver alla slutstationer.
    
    if walkTo_bs(i,j) > limit_walk
        continue;
    end
        
    for k = 1:n_stops %Loop �ver alla startstationer.

        trip_plus_wait_time = busTo_bs{d,int16(t-walkTo_bs(i,j))}(k,j)/2 + walkTo_bs(:,k) + walkTo_bs(i,j);

        idx = find(trip_plus_wait_time < fastest_trip);
        
        fastest_trip(idx) = trip_plus_wait_time(idx);
        
    end
end

fastest_trip = fastest_trip/60;
end