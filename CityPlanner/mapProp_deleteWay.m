function node_int = mapProp_deleteWay(hObject,handles) %node_info: plats 1 = OSM id, plats 2 = intersection node ID
    current_way_nodes = handles.current_way_struct.ndref;
    coordinates = handles.coordinates;
    graph_data = handles.graph_data;
    h = waitbar(0,'Finding closest node');
    
    list_id = {};
    list_lon = {};
    list_lat = {};
    
    for i=1:length(current_way_nodes)
        current_node = graph_data.intnd_map(graph_data.id_map(current_way_nodes{i}));
        if current_node
            list_id = [list_id, {graph_data.intnd(current_node).id}];
            list_lon = [list_lon, {graph_data.intnd(current_node).lon}];
            list_lat = [list_lat, {graph_data.intnd(current_node).lat}];
        end
    end
    
    shortest_dist = 10; %dummy variable
    coord_ref = [];
    
    for i=1:length(list_lon)
        coord_ref(1) = list_lon{i};
        coord_ref(2) = list_lat{i};
        
        distance = norm(coordinates - coord_ref); %"pythagoras sats"

        if distance < shortest_dist %om nya avst�ndet kortare �n gamla, uppdatera shortest dist
            shortest_dist(1) = distance; %avst�nd
            shortest_dist(2) = (graph_data.intnd_map(graph_data.id_map(list_id{i}))); %vilken intnd det handlar om
        end
    end
    
    waitbar(1,h);
    delete(h)
    
    aaa = size(shortest_dist);
    if aaa(2) == 2;
        node_int = shortest_dist(2); %Returnen
        guidata(hObject,handles);
    else
        node_int = false;
        msgbox('No node could be found, please try again!')
    end
    