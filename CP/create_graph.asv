%Skript som läser in relevant data och gör en matris som representerar
%grafen. 

clear
load('data_umea')
[x n_nodes] = size(node);
[x n_ways] = size(way);
intnd_count = 0; %Antalet intersections nodes, noder som ligger i korsningar mellan minst två vägar.
intnd_map = zeros(n_nodes,1); %Mappning som returnerar index för en intersection node i intnd arrayen, givet nodens index i node arrayen.
graph_file = matfile('graph_data.mat');

for i = 1:n_ways %Loopar över alla vägar för att spara relevanta noder som ligger längs vägarna.
    k = 1;
    
    if intnd_map(id_map(way(i).ndref{1})) == 0 %Om noden inte tidigare är sparad som en intersection node skall den det. Första noden på en väg sparas alltid som en intersection node oavsett hur många vägar som refererar till den node.
        intnd_count = intnd_count + 1;
        intnd_map(id_map(way(i).ndref{1})) = intnd_count;
        intnd(intnd_count) = node(id_map(way(i).ndref{1}));
        
    end
    
    [x n_ndref] = size(way(i).ndref);
    for j = 2:n_ndref %Loopa över alla noder som way(i) refererar till, förutom första noden eftersom den alltid sparas.
        
        if (node(id_map(way(i).ndref{j})).waynd > 1) || j == n_ndref %Om noden som kontrolleras refereras från flera vägar eller om det är sista noden vägen refererar till är det en intersection node.
            
            if intnd_map(id_map(way(i).ndref{j})) == 0 %Om noden inte har sparats som en intersection node ska den det.
                intnd_count = intnd_count + 1
                intnd_map(id_map(way(i).ndref{j})) = intnd_count;
                intnd(intnd_count) = node(id_map(way(i).ndref{j}));
            end
            
            length = 0;
            for h = k:j-1 %Loop som räknar ut längden mellan nuvarande nod från tidigare sparad nod på vägen.
                lat1 = str2double(node(id_map(way(i).ndref{h})).lat);
                lon1 = str2double(node(id_map(way(i).ndref{h})).lon);
                lat2 = str2double(node(id_map(way(i).ndref{h+1})).lat);
                lon2 = str2double(node(id_map(way(i).ndref{h+1})).lon);
                length = length + latlon2meters(lat1,lat2,lon1,lon2);
            end
            way_weight = length; %Just nu viktas vägarna mellan noderna enbart efter hur långa de är, detta är en förenkling och skall utvecklas!
            graph_file.Graph_matrix(intnd_map(id_map(way(i).ndref{k})),intnd_map(id_map(way(i).ndref{j}))) = way_weight;
            if way(i).oneway == 0 %Om vägen inte är enkelriktad skall även det speglade elementet få samma vikt. Detta är också en förenkling eftersom det kan vara mer lättframkomligt åt ena hållet på en väg.
                graph_file.Graph_matrix(intnd_map(id_map(way(i).ndref{j})),intnd_map(id_map(way(i).ndref{k}))) = way_weight;
            end
            k = j; %Nod nummer k som vägen refererar till sparas som den senaste intersection noden.
        end
    end
end