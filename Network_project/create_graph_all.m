%Skript som l�ser in relevant data och g�r en matris som representerar
%grafen. 

clear
load('data')
[x n_nodes] = size(node);
[x n_ways] = size(way);
walkspeed = 6;
cyclingspeed = 15;
intnd_count = 0; %Antalet intersections nodes, noder som ligger i korsningar mellan minst tv� v�gar.
edge_count = 1;

graph_file = matfile('graph_data.mat','Writable',true);
intnd_map = zeros(n_nodes,1); %Mappning som returnerar index f�r en intersection node i intnd arrayen, givet nodens index i node arrayen.




for i = 1:n_ways %Loopar �ver alla v�gar f�r att spara relevanta noder som ligger l�ngs v�garna.
    k = 1;

    if intnd_map(id_map(way(i).ndref{1}),1) == 0 %Om noden inte tidigare �r sparad som en intersection node skall den det. F�rsta noden p� en v�g sparas alltid som en intersection node oavsett hur m�nga v�gar som refererar till den node.
        intnd_count = intnd_count + 1;
        intnd_map(id_map(way(i).ndref{1}),1) = intnd_count;
        intnd(intnd_count) = node(id_map(way(i).ndref{1}));
    end

    %edge(edge_count).nodes = [id_map(way(i).ndref{1})];
    [x n_ndref] = size(way(i).ndref);
    
    
    for j = 2:n_ndref %Loopa �ver alla noder som way(i) refererar till, f�rutom f�rsta noden eftersom den alltid sparas.

        
        %edge(edge_count).nodes = [edge(edge_count).nodes id_map(way(i).ndref{j})];
        
        if (node(id_map(way(i).ndref{j})).waynd > 1) || j == n_ndref %Om noden som kontrolleras refereras fr�n flera v�gar eller om det �r sista noden v�gen refererar till �r det en intersection node.
            
            if intnd_map(id_map(way(i).ndref{j}),1) == 0 %Om noden inte har sparats som en intersection node ska den det.
                intnd_count = intnd_count + 1;
                intnd_map(id_map(way(i).ndref{j}),1) = intnd_count;
                intnd(intnd_count) = node(id_map(way(i).ndref{j}));
            end
            
            XY = zeros(3, 1);
            XY(1,1) = node(id_map(way(i).ndref{k})).lon;
            XY(2,1) = node(id_map(way(i).ndref{k})).lat;

            length = 0;
            l = 1;

            for h = k:j-1 %Loop som r�knar ut l�ngden mellan nuvarande nod fr�n tidigare sparad nod p� v�gen.
                lat1 = node(id_map(way(i).ndref{h})).lat;
                lon1 = node(id_map(way(i).ndref{h})).lon;
                lat2 = node(id_map(way(i).ndref{h+1})).lat;
                lon2 = node(id_map(way(i).ndref{h+1})).lon;
                length = length + norm([lat1,lon1] - [lat2,lon2]);
                XY(1,l+1) = node(id_map(way(i).ndref{h+1})).lon;
                XY(2,l+1) = node(id_map(way(i).ndref{h+1})).lat;
                XY(3,l+1) = XY(3,l) + norm([lat1,lon1] - [lat2,lon2]);
                l = l + 1;
            end

            edge(edge_count).dist = length;
            edge(edge_count).vel_lim = way(i).maxspeed/3.6;
            edge(edge_count).avg_speed = way(i).maxspeed/3.6;
            edge(edge_count).from = intnd_map(id_map(way(i).ndref{k}));
            edge(edge_count).to = intnd_map(id_map(way(i).ndref{j}));
            edge(edge_count).cars = [];
            edge(edge_count).node_matrix = XY;
            edge(edge_count).edge_to_right = 0;
            edge(edge_count).n_usage = 0;
            
            graph_matrix(intnd_map(id_map(way(i).ndref{k})),intnd_map(id_map(way(i).ndref{j}))) = length/(way(i).maxspeed/3.6);
            edge_index(intnd_map(id_map(way(i).ndref{k})),intnd_map(id_map(way(i).ndref{j}))) = edge_count;
            

            edge_count = edge_count + 1;
            edge(edge_count).dist = length;
            edge(edge_count).vel_lim = way(i).maxspeed/3.6;
            edge(edge_count).avg_speed = way(i).maxspeed/3.6;
            edge(edge_count).to = intnd_map(id_map(way(i).ndref{k}));
            edge(edge_count).from = intnd_map(id_map(way(i).ndref{j}));
            edge(edge_count).cars = [];
            edge(edge_count).node_matrix = fliplr(XY);
            edge(edge_count).node_matrix(3,:) = edge(edge_count).node_matrix(3,1) - edge(edge_count).node_matrix(3,:);
            edge(edge_count).edge_to_right = 0;
            edge(edge_count).edge_to_left = 0;
            edge(edge_count).edge_to_front = 0;
            edge(edge_count).opposite = 0;
            edge(edge_count).n_usage = 0;
            
           
            graph_matrix(intnd_map(id_map(way(i).ndref{j})),intnd_map(id_map(way(i).ndref{k}))) = length/(way(i).maxspeed/3.6);
            edge_index(intnd_map(id_map(way(i).ndref{j})),intnd_map(id_map(way(i).ndref{k}))) = edge_count;
            edge_count = edge_count + 1;

            k = j; %Nod nummer k som v�gen refererar till sparas som den senaste intersection noden.
        end
    end
end

%% H�GERREGELN. Look for if an edge has a row to the right.
for i = 1:47
    node_from = find(edge_index(:,i));
    index_edges_in = edge_index(node_from,i);
    [nr_in_edge,~] = size(index_edges_in);
    if nr_in_edge > 2
        road_vec = zeros(nr_in_edge,3);
        
        for j = 1:nr_in_edge
%             i
%             j
%             [intnd(i).lon,intnd(i).lat] 
%             [intnd(node_from(j)).lon,intnd(edge(node_from(j)).from).lat] 
            road_vec(j,1:2) = [intnd(i).lon,intnd(i).lat] - [intnd(node_from(j)).lon,intnd(node_from(j)).lat];
            road_vec(j,1:2) = road_vec(j,1:2)/norm(road_vec(j,1:2));
        end
        
        %Cross-Product
        m = 1:nr_in_edge;
        for n = m
            %c_array = zeros(nr_in_edge,1);
            for j = m

                
                if (j ~= n) c = cross(road_vec(n,:),road_vec(j,:));
                    if c(end) > 0.5% Cross product returns < 0 if road is to the right.
                        %c_array(j) = c(end);
                        edge(index_edges_in(n)).edge_to_right = index_edges_in(j); % Index for edge to the right.
                    end
                end
            end
            %[~,idx] = max(c_array);
            %edge(index_edges_in(n)).edge_to_right = index_edges_in(idx);
        end
    end
end
%%

%% VÄJNINGSPLIKT. Look for if an edge has a row to the left.
for i = 1:47
    node_from = find(edge_index(:,i));
    index_edges_in = edge_index(node_from,i);
    [nr_in_edge,~] = size(index_edges_in);
    if nr_in_edge > 2
        road_vec = zeros(nr_in_edge,3);
        
        for j = 1:nr_in_edge
            road_vec(j,1:2) = [intnd(i).lon,intnd(i).lat] - [intnd(node_from(j)).lon,intnd(node_from(j)).lat];
            road_vec(j,1:2) = road_vec(j,1:2)/norm(road_vec(j,1:2));
        end
        
        %Cross-Product
        m = 1:nr_in_edge;
        for n = m
            for j = m

                
                if (j ~= n) c = cross(road_vec(n,:),road_vec(j,:));
                    if c(end) < -0.5% Cross product returns < 0 if road is to the right.
                        edge(index_edges_in(n)).edge_to_left = index_edges_in(j); % Index for edge to the right.
                    end
                end
            end
        end
    end
end
%%

%% VÄJNINGSPLIKT. Look for if an edge has a row in front of it.
for i = 1:47
    node_from = find(edge_index(:,i));
    index_edges_in = edge_index(node_from,i);
    [nr_in_edge,~] = size(index_edges_in);
    if nr_in_edge > 2
        road_vec = zeros(nr_in_edge,3);
        
        for j = 1:nr_in_edge
            road_vec(j,1:2) = [intnd(i).lon,intnd(i).lat] - [intnd(node_from(j)).lon,intnd(node_from(j)).lat];
            road_vec(j,1:2) = road_vec(j,1:2)/norm(road_vec(j,1:2));
        end
        
        %Cross-Product
        m = 1:nr_in_edge;
        for n = m
            for j = m

                
                if (j ~= n) c = cross(road_vec(n,:),road_vec(j,:));
                    if abs(c(end)) < 0.5% Cross product returns < 0 if road is to the right.
                        edge(index_edges_in(n)).edge_to_front = index_edges_in(j); % Index for edge to the right.
                    end
                end
            end
        end
    end
end
%%

%% VÄJNINGSPLIKT. Look for the edge in the opposite direction
for i = 1:edge_count-1
    for j = i:edge_count-1
        if j ~= i
            if edge(i).to == edge(j).from && edge(i).from == edge(j).to
                edge(i).opposite = j;
                edge(j).opposite = i;
            end
        end
    end
end

%%

%% PARKING. Add parking spots
% for i = [10 11 27 35]
%     node_from = find(edge_index(:,i));
%     index_edges_in = edge_index(node_from,i);
%     [nr_in_edge,~] = size(index_edges_in);
%     for j = 1:nr_in_edge
%        edge(index_edges_in(j)).parking = 1; 
%     end
% end
%%

save('graph_data.mat','intnd_map','id_map','node','intnd','edge','length','edge_index','graph_matrix')