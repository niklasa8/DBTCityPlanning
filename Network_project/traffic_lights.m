

node = find([intnd.traffic_signals] ~= 0);

[~,nr_of_lights] = size(node);
for i = 1:nr_of_lights
    light_pos(i).lon = intnd(node(i)).lon;
    light_pos(i).lat = intnd(node(i)).lat;
end

% modes: time= 1, traffic = 2, green wave = 3

% light_object = (nr_of_lights);
for i = 1:nr_of_lights
%     light_object(i) = rectangle('curvature', [1,1], 'position', [light_pos(i).lon+10 light_pos(i).lat 8 8], 'facecolor', 'green');
    light(i).first = 1;
    light(i).second = 0;
    
    
    node_to = find(edge_index(:,node(i)));
    [nr_in_edge,~] = size(node_to);
    edgesF = [0 0];
    edgesS = [0 0];
    if 1 < nr_in_edge
        edgesF(1) = edge_index(node_to(1),node(i));
        if ~isempty(edge(edge_index(node_to(1),node(i))).edge_to_front)
            edgesF(2) = edge(edge_index(node_to(1),node(i))).edge_to_front;
        end
    end
    if 2 < nr_in_edge
        for j = 2:nr_in_edge
            if edge_index(node_to(j),node(i)) ~= edgesF
                edgesS(1) = edge_index(node_to(j),node(i));
                if ~isempty(edge(edge_index(node_to(j),node(i))).edge_to_front)
                    edgesS(2) = edge(edge_index(node_to(j),node(i))).edge_to_front;
                end
            end
        end
    end
    
    light(i).firstEdges = edgesF;
    light(i).secondEdges = edgesS;
    
    
    light(i).period = 40.0;
    light(i).timer = 0;
    light(i).node = node(i);
    light(i).mode = 2;
    light(i).GW_nr = 1;
    light(i).GW_tot = 1;
    
end