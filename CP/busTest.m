load('graph_data.mat','walk_all_shortest_path','intnd_count','intnd_map')
load('data_umea','departure_','arrival_','bus_stop','bus_stop_nodes')

%% Skapar busTo_bs
n_stops = max(size(busMap));
busTo_bs = cell(4,1440);
traveltime = cell(175,175);
t_vec = 1:1440;
% clear t_matrix
% t_matrix(1,1,:) = tvec;
t_matrix = repmat(t_vec,4,1440);

Arrival = zeros(175,175);
for i=1:175
    for j=1:175
        Arrival(i,j) = ~isempty(Arr{i,j});
    end
end


for i=1:4   % Loop over days - 1(Mon-Thur),2(Fri),3(Sat),4(Sun)
    tic
    
    % Calc traveltime between stops
    % traveltime: (175x175)-matrix with a (4x1440)-matrix in each element
    for r=1:175
        for c=1:175
            mat = inf(4,1440);
            [day,min] = find(Arr{r,c});
            if Arrival(r,c)==1
                mat(day, min) = max(0,Arr{r,c}(day,min) - Dep{r,c}(day,min));
%                 mat(day, min) = max(0,t_matrix(day,min) - Dep{r,c}(day,min));

                traveltime{r,c} = mat;
            end
            
            
%             inds = find(Arr{r,c});
%             if Arrival(r,c)==1
%                 mat(inds) = max(0,Arr{r,c}(inds) - Dep{r,c}(inds));
%                 traveltime{r,c} = mat;
%             end
        end 
    end
    
    
    ind = find(Arrival);

    for t = 1:1440
        busMat_min = zeros(n_stops,n_stops);
        busNetwork = zeros(n_stops,n_stops);
        for l=1:length(ind)
            if traveltime{ind(l)}(i,t) == 0
                traveltime{ind(l)}(i,t) = 0.01;
            end
%             busMat_min(ind(l)) = max(0.01,t*t_matrix(ind(l)) - (Arr{ind(l)}(i,t) - Dep{ind(l)}(i,t));
%             busMat_min(ind(l)) = traveltime{ind(l)}(i,t);      
            busNetwork(ind(l)) = traveltime{ind(l)}(i,t);      

        end
        for row=1:175
            for col=1:175
                if col ~= row
                    [dist,path,pred] = graphshortestpath(sparse(busNetwork),row,col);
                    if dist == inf
                        busMat_min(row,col) = dist;
                    else
                        from = path(end-1);
                        busMat_min(row,col) = t - Arr{from,col}(i,t) + dist;
                    end
                end
            end
        end
%         busMat_min = graphallshortestpaths(sparse(busMat_min));

        busTo_bs{i,t} = busMat_min;
    end 
    toc
end

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
    bus_stop_nodes(i) = intnd_map(id_map(num2str(busMapInt(i)))); 
end


walkTo_bs = walk_all_shortest_path(:,bus_stop_nodes)*60; %walkTo_bs - walk to bus station. Snabbaste v�gen att g� fr�n godtycklig nod till alla bussh�llplatser.
i = intnd_map(id_map('444493179'));
t = 800; %i och t �r 
d = 1; % Dag: 1(M�n-Tors),2(Fre),3(L�r),4(S�n)
limit_walk = 30; %Algoritmen r�knar inte ut hur l�ng tid det tar att ta sig fr�n en plats till en annan med buss om det tar �verdrivet l�ng tid att g� till bussh�llplatsen.
limit_wait_time = 30;   
fastest_trip = inf(intnd_count,1);

for j = 1:n_stops %Loop �ver alla slutstationer.
    
    if walkTo_bs(i,j) > limit_walk
        continue;
    end
        
    for k = 1:n_stops %Loop �ver alla startstationer.

        trip_plus_wait_time = busTo_bs{1,int16(t-walkTo_bs(i,j))}(k,j) + walkTo_bs(:,k) + walkTo_bs(i,j);

        idx = find(trip_plus_wait_time < fastest_trip);
        
        fastest_trip(idx) = trip_plus_wait_time(idx);
        
    end
end

%Denna del r�knar ut snabbaste v�gen att ta sig fr�n alla noder till i med buss. 