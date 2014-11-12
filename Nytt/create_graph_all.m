%Skript som läser in relevant data och gör en matris som representerar
%grafen. 

clear
load('data_umea')

[x n_nodes] = size(node);
[x n_ways] = size(way);
walkspeed = 6;
cyclingspeed = 15;
time_delay_TC = 5;%Snitt väntetid vid trafikhinder i sekunder.
time_delay_TS = 35;%Snitt väntetid vid trafiksignaler i sekunder.
intnd_count = 0; %Antalet intersection nodes, noder som ligger i korsningar mellan minst två vägar.
edge_count = 0;

if config_graph
    
    cyclingspeed = config.bicycle_speed;
    walkspeed = config.walk_speed;

    for i = 1:length(add_node)
        
        n_nodes = n_nodes + 1;
        node(n_nodes) = add_node(i);
        
    end
    
    for i = 1:length(add_way) %Loop som lägger till alla vägar som ska läggas till utöver de som lästs in från OSM.

        n_ways = n_ways + 1;
        way(n_ways) = add_way(i);
        n_ndref = length(way(n_ways).ndref);
        
        for j = 1:n_ndref
            node(id_map(way(n_ways).ndref{j})).waynd = node(id_map(way(n_ways).ndref{j})).waynd + 1;
        end

    end

end


graph_file = matfile('graph_data.mat','Writable',true);
intnd_map = zeros(n_nodes,1); %Mappning som returnerar index för en intersection node i intnd arrayen, givet nodens index i node arrayen.


for i = 1:n_ways %Loopar över alla vägar för att spara relevanta noder som ligger längs vägarna.
    k = 1;

    if intnd_map(id_map(way(i).ndref{1}),1) == 0 %Om noden inte tidigare är sparad som en intersection node skall den det. Första noden på en väg sparas alltid som en intersection node oavsett hur många vägar som refererar till den node.
        intnd_count = intnd_count + 1;
        intnd_map(id_map(way(i).ndref{1}),1) = intnd_count;
        intnd(intnd_count) = node(id_map(way(i).ndref{1}));
        node(id_map(way(i).ndref{1})).intnd = 1;
    end

    [x n_ndref] = size(way(i).ndref);
    for j = 2:n_ndref %Loopa över alla noder som way(i) refererar till, förutom första noden eftersom den alltid sparas.

        if (node(id_map(way(i).ndref{j})).waynd > 1) || j == n_ndref || (node(id_map(way(i).ndref{j})).parking == 1) || (node(id_map(way(i).ndref{j})).bus_stop == 1) %Om noden som kontrolleras refereras från flera vägar eller om det är sista noden vägen refererar till är det en intersection node.
            traffic_calming = 0;
            traffic_signals = 0;
            if intnd_map(id_map(way(i).ndref{j}),1) == 0 %Om noden inte har sparats som en intersection node ska den det.
                intnd_count = intnd_count + 1
                intnd_map(id_map(way(i).ndref{j}),1) = intnd_count;
                intnd(intnd_count) = node(id_map(way(i).ndref{j}));
                node(id_map(way(i).ndref{1})).intnd = 1;
            end

            length = 0;
            for h = k:j-1 %Loop som räknar ut längden mellan nuvarande nod från tidigare sparad nod på vägen.
                if node(id_map(way(i).ndref{h})).traffic_calming == 1
                    traffic_calming = traffic_calming + 1;
                end
                if node(id_map(way(i).ndref{h})).traffic_signals == 1
                    traffic_signals = 1;
                end
                lat1 = node(id_map(way(i).ndref{h})).lat;
                lon1 = node(id_map(way(i).ndref{h})).lon;
                lat2 = node(id_map(way(i).ndref{h+1})).lat;
                lon2 = node(id_map(way(i).ndref{h+1})).lon;
                length = length + latlon2meters(lat1,lat2,lon1,lon2);
            end

            if way(i).highway && way(i).footway == 0 && way(i).cycleway == 0 %Om vägen inte är en gångväg eller cykelväg är det en bilväg.
                max_speed = way(i).maxspeed;
                
                if config_graph %Sats som ändrar hastighetsbegränsningen på en kant om det skall göras.
                    [truefalse index] = ismember([way(i).ndref{j},way(i).ndref{k}],config.speed_limit_edge);
                    
                    if truefalse
                        max_speed = str2double(config.speed_limit_edge{index+1});
                    end
                end
                
                weight = 10^-3*length/max_speed + traffic_calming*time_delay_TC/3600 + traffic_signals*time_delay_TS/3600; %Vikt på kanten mellan nod j och k.
                graph_file.Car_graph_matrix(intnd_map(id_map(way(i).ndref{k}),1),intnd_map(id_map(way(i).ndref{j}),1)) = weight;
                
                if way(i).oneway == 0 %Om vägen inte är enkelriktad skall även det speglade elementet få samma vikt. Detta är också en förenkling eftersom det kan vara mer lättframkomligt åt ena hållet på en väg.
                    graph_file.Car_graph_matrix(intnd_map(id_map(way(i).ndref{j}),1),intnd_map(id_map(way(i).ndref{k}),1)) = weight;
                end
            end

            if way(i).bicycle || way(i).footway || way(i).cycleway %Om man får cykla på vägen antas även att man får gå på den.
                weight = 10^-3*length/walkspeed; %Vikt på kanten mellan nog j och k.
                graph_file.Walk_graph_matrix(intnd_map(id_map(way(i).ndref{k}),1),intnd_map(id_map(way(i).ndref{j}),1)) = weight;
                graph_file.Walk_graph_matrix(intnd_map(id_map(way(i).ndref{j}),1),intnd_map(id_map(way(i).ndref{k}),1)) = weight;
            end

            if way(i).bicycle && way(i).footway == 0 %Väg man får cykla på.
                weight = 10^-3*length/cyclingspeed; %Vikt på kanten mellan nog j och k.
                graph_file.Bicycle_graph_matrix(intnd_map(id_map(way(i).ndref{k}),1),intnd_map(id_map(way(i).ndref{j}),1)) = weight;
                if way(i).oneway == 0 %Om vägen inte är enkelriktad skall även det speglade elementet få samma vikt. Detta är också en förenkling eftersom det kan vara mer lättframkomligt åt ena hållet på en väg.
                    graph_file.Bicycle_graph_matrix(intnd_map(id_map(way(i).ndref{j}),1),intnd_map(id_map(way(i).ndref{k}),1)) = weight;
                end
            end
            k = j; %Nod nummer k som vägen refererar till sparas som den senaste intersection noden.
        end
    end
end

if config_graph
   
    for i = 1:max(size(config.delete_edge)) %Loop som tar bort kanter som ska tas bort
       
        graph_file.Walk_graph_matrix(intnd_map(id_map(num2str(config.delete_edge{i}(1)))),intnd_map(id_map(num2str(config.delete_edge{i}(2))))) = 0;
        graph_file.Bicycle_graph_matrix(intnd_map(id_map(num2str(config.delete_edge{i}(1)))),intnd_map(id_map(num2str(config.delete_edge{i}(2))))) = 0;
        graph_file.Car_graph_matrix(intnd_map(id_map(num2str(config.delete_edge{i}(1)))),intnd_map(id_map(num2str(config.delete_edge{i}(2))))) = 0;
        
    end
end


car_all_shortest_path = graphallshortestpaths(sparse(graph_file.Car_graph_matrix));
walk_all_shortest_path = graphallshortestpaths(sparse(graph_file.Walk_graph_matrix));
car_path_toParking = car_all_shortest_path(:,intnd_map(park_nodes));
clear car_all_shortest_path
walk_path_fromParking = walk_all_shortest_path(intnd_map(park_nodes),:);
carTo_walkFrom_parking = zeros(intnd_count);
bicycling_path = graphallshortestpaths(sparse(graph_file.Bicycle_graph_matrix));

for i = 1:intnd_count
    [minD,index] = min(walk_path_fromParking(:,i));
    carTo_walkFrom_parking(:,i) = minD + car_path_toParking(:,index); %Snabbaste vägen med bil givet att man måste parkera.
end

clear car_path_toParking
clear walk_path_fromParking

save('graph_data.mat','carTo_walkFrom_parking','bicycling_path','intnd_map','id_map','intnd_count','intnd','walk_all_shortest_path')
save('data_umea.mat','way','-append')