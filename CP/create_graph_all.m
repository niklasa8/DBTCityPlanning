%Skript som l�ser in relevant data och g�r en matris som representerar
%grafen. 

clear
load('data_umea')
[x n_nodes] = size(node);
[x n_ways] = size(way);
walkspeed = 6;
cyclingspeed = 15;
intnd_count = 0; %Antalet intersections nodes, noder som ligger i korsningar mellan minst tv� v�gar.
edge_count = 0;

graph_file = matfile('graph_data.mat','Writable',true);
intnd_map = zeros(n_nodes,1); %Mappning som returnerar index f�r en intersection node i intnd arrayen, givet nodens index i node arrayen.


for i = 1:n_ways %Loopar �ver alla v�gar f�r att spara relevanta noder som ligger l�ngs v�garna.
    k = 1;

    if intnd_map(id_map(way(i).ndref{1}),1) == 0 %Om noden inte tidigare �r sparad som en intersection node skall den det. F�rsta noden p� en v�g sparas alltid som en intersection node oavsett hur m�nga v�gar som refererar till den node.
        intnd_count = intnd_count + 1
        intnd_map(id_map(way(i).ndref{1}),1) = intnd_count;
        intnd(intnd_count) = node(id_map(way(i).ndref{1}));
        node(id_map(way(i).ndref{1})).intnd = 1;
    end

    [x n_ndref] = size(way(i).ndref);
    for j = 2:n_ndref %Loopa �ver alla noder som way(i) refererar till, f�rutom f�rsta noden eftersom den alltid sparas.

        if (node(id_map(way(i).ndref{j})).waynd > 1) || j == n_ndref || (node(id_map(way(i).ndref{j})).parking == 1) || (node(id_map(way(i).ndref{j})).bus_stop == 1) %Om noden som kontrolleras refereras fr�n flera v�gar eller om det �r sista noden v�gen refererar till �r det en intersection node.

            if intnd_map(id_map(way(i).ndref{j}),1) == 0 %Om noden inte har sparats som en intersection node ska den det.
                intnd_count = intnd_count + 1
                intnd_map(id_map(way(i).ndref{j}),1) = intnd_count;
                intnd(intnd_count) = node(id_map(way(i).ndref{j}));
                node(id_map(way(i).ndref{1})).intnd = 1;
            end

            length = 0;
            for h = k:j-1 %Loop som r�knar ut l�ngden mellan nuvarande nod fr�n tidigare sparad nod p� v�gen.
                lat1 = node(id_map(way(i).ndref{h})).lat;
                lon1 = node(id_map(way(i).ndref{h})).lon;
                lat2 = node(id_map(way(i).ndref{h+1})).lat;
                lon2 = node(id_map(way(i).ndref{h+1})).lon;
                length = length + latlon2meters(lat1,lat2,lon1,lon2);
            end

            if way(i).highway && way(i).footway == 0 && way(i).cycleway == 0 %Om v�gen inte �r en g�ngv�g eller cykelv�g �r det en bilv�g.
                weight = 10^-3*length/way(i).maxspeed; %Vikt p� kanten mellan nog j och k.
                graph_file.Car_graph_matrix(intnd_map(id_map(way(i).ndref{k}),1),intnd_map(id_map(way(i).ndref{j}),1)) = weight;
                
                if way(i).oneway == 0 %Om v�gen inte �r enkelriktad skall �ven det speglade elementet f� samma vikt. Detta �r ocks� en f�renkling eftersom det kan vara mer l�ttframkomligt �t ena h�llet p� en v�g.
                    graph_file.Car_graph_matrix(intnd_map(id_map(way(i).ndref{j}),1),intnd_map(id_map(way(i).ndref{k}),1)) = weight;
                end
            end

            if way(i).bicycle || way(i).footway || way(i).cycleway %Om man f�r cykla p� v�gen antas �ven att man f�r g� p� den.
                weight = 10^-3*length/walkspeed; %Vikt p� kanten mellan nog j och k.
                graph_file.Walk_graph_matrix(intnd_map(id_map(way(i).ndref{k}),1),intnd_map(id_map(way(i).ndref{j}),1)) = weight;
                graph_file.Walk_graph_matrix(intnd_map(id_map(way(i).ndref{j}),1),intnd_map(id_map(way(i).ndref{k}),1)) = weight;
            end

            if way(i).bicycle && way(i).footway == 0 %V�g man f�r cykla p�.
                weight = 10^-3*length/cyclingspeed; %Vikt p� kanten mellan nog j och k.
                graph_file.Bicycle_graph_matrix(intnd_map(id_map(way(i).ndref{k}),1),intnd_map(id_map(way(i).ndref{j}),1)) = weight;
                if way(i).oneway == 0 %Om v�gen inte �r enkelriktad skall �ven det speglade elementet f� samma vikt. Detta �r ocks� en f�renkling eftersom det kan vara mer l�ttframkomligt �t ena h�llet p� en v�g.
                    graph_file.Bicycle_graph_matrix(intnd_map(id_map(way(i).ndref{j}),1),intnd_map(id_map(way(i).ndref{k}),1)) = weight;
                end
            end
            k = j; %Nod nummer k som v�gen refererar till sparas som den senaste intersection noden.
        end
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
    carTo_walkFrom_parking(:,i) = minD + car_path_toParking(:,index); %Snabbaste v�gen med bil givet att man m�ste parkera.
end

clear car_path_toParking
clear walk_path_fromParking

save('graph_data.mat','carTo_walkFrom_parking','bicycling_path','intnd_map','id_map','intnd_count','intnd','walk_graph','-append')