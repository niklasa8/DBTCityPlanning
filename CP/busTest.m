load('graph_data.mat','walk_all_shortest_path','intnd_count','intnd_map')
load('data_umea','departure_','arrival_','bus_stop','bus_stop_nodes')

%% Skapar busTo_bs
n_stops = max(size(busMap));

day_min = cell(4,1440);
traveltime = cell(175,175);
% t = 1:1440;
% clear t_matrix
% t_matrix(1,1,:) = t;
% t_matrix = repmat(t_matrix,[n_stops,n_stops]);
% idx = find(departure_);
% busTo_bs(idx) = (t_matrix(idx) - departure_(idx))/60;
% idx = find(busTo_bs < 0);
% busTo_bs(idx) = busTo_bs(idx) + 24;

Arrival = zeros(175,175);
for i=1:175
    for j=1:175
        Arrival(i,j) = ~isempty(Arr{i,j});
    end
end

Departure = zeros(175,175);
for i=1:175
    for j=1:175
        Departure(i,j) = ~isempty(Dep{i,j});
    end
end

for i=1:4
    tic
    
    % Calc traveltime between stops
    % traveltime: (175x175)-matrix with a (4x1440)-matrix in each element
    for r=1:175
        for c=1:175
            if Arrival(r,c)==1
                traveltime{r,c} = Arr{r,c} - Dep{r,c};
            end
        end 
    end
    
    for t = 1:1440
        busTo_bs = zeros(n_stops,n_stops);
        
        
        
        busTo_bs = graphallshortestpaths(sparse(busTo_bs));
        day_min{i,t} = busTo_bs;
    end
    toc
end

%busTo_bs - bus to bus station. Används på följande vis: busTo_bs(i,j,t)
%i: Ett heltal mellan 1 och antalet busshållplatser (27), anger vilken
%busshållplats man vill åka från.
%j: Busshållplats man vill åka till
%t: tiden man SENAST vill vara på busshållplatsen.
%Output: Ger tiden i timmar det tar att åka från i till j givet att man vill vara
%framme tiden t.
%% Räknar ut snabbaste vägen

walkTo_bs = walk_all_shortest_path(:,bus_stop_nodes); %walkTo_bs - walk to bus station. Snabbaste vägen att gå från godtycklig nod till alla busshållplatser.
i = intnd_map(id_map('444493179'));
t = 800; %i och t är 
limit_walk = 0.5; %Algoritmen räknar inte ut hur lång tid det tar att ta sig från en plats till en annan med buss om det tar överdrivet lång tid att gå till busshållplatsen.
limit_wait_time = 0.5;
fastest_trip = inf(intnd_count,1);

for j = 1:n_stops %Loop över alla slutstationer.
    
    if walkTo_bs(i,j) > limit_walk
        continue;
    end
        
    for k = 1:n_stops %Loop över alla startstationer.

        trip_plus_wait_time = busTo_bs(k,j,int16(t-walkTo_bs(i,j)*60))/6 + walkTo_bs(:,k) + walkTo_bs(i,j);

        idx = find(trip_plus_wait_time < fastest_trip);
        
        fastest_trip(idx) = trip_plus_wait_time(idx);
        
    end
end

%Denna del räknar ut snabbaste vägen att ta sig från alla noder till i med buss. 