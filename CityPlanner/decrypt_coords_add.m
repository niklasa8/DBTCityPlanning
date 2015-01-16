function node_intnd = decrypt_coords(hObject,handles,sens) %node_info: plats 1 = OSM id, plats 2 = intersection node ID
    coordinates = handles.coordinates;

    graph_data = handles.main.graph_data;
    h = waitbar(0,'Finding closest node');
    %load('graph_data.mat','intnd_count','intnd','intnd_map','id_map') %behï¿½ver lite data..
    sensivity = sens; %Vi kollar alltsï¿½ i 0.0020 lat/lon distance i varje led
    close_intnd = []; 
    shortest_dist = 10; %sï¿½tter som 10 => "dummy" variabel, kommer alltid skrivas ï¿½ver
    shortest_dist_2 = 10;
    waitbar(0.25,h);
    for i = 1:graph_data.intnd_count %Kollar igenom hela intnd, sparar undan positionen i intnd fï¿½r match
        if (abs(graph_data.intnd(i).lon - coordinates(1)) <= sensivity) & (abs(graph_data.intnd(i).lat - coordinates(2)) <= sensivity);
            close_intnd = [close_intnd i];
        end
    end
    waitbar(0.5,h);
    
    close_add_node = []; 
    if isfield(handles.main,'add_node')
        for i=1:length(handles.main.add_node)
            if (abs(handles.main.add_node(i).lon - coordinates(1)) <= sensivity) & (abs(handles.main.add_node(i).lat - coordinates(2)) <= sensivity);
                close_add_node = [close_add_node i];
            end
        end
    end
    
    waitbar(0.75,h);
    for i = close_intnd %Nu nï¿½r vi hittat punkter som ligger inom "sensivity area", kollar vi vilken av dem som ï¿½r nï¿½rmast
        coord_ref(1) = graph_data.intnd(i).lon;
        coord_ref(2) = graph_data.intnd(i).lat;

        distance = norm(coordinates - coord_ref); %"pythagoras sats"

        if distance < shortest_dist(1) %om nya avstï¿½ndet kortare ï¿½n gamla, uppdatera shortest dist
            shortest_dist(1) = distance; %avstï¿½nd
            shortest_dist(2) = i; %vilken intnd det handlar om
        end
    end
    
    for i = close_add_node
        coord_ref(1) = handles.main.add_node(i).lon;
        coord_ref(2) = handles.main.add_node(i).lat;
        
        distance = norm(coordinates - coord_ref); %"pythagoras sats"

        if distance < shortest_dist_2(1) %om nya avstï¿½ndet kortare ï¿½n gamla, uppdatera shortest dist
            shortest_dist_2(1) = distance; %avstï¿½nd
            shortest_dist_2(2) = i; %vilken intnd det handlar om
        end
    end
    
    if shortest_dist(1) > shortest_dist_2(1)
        shortest_dist(1) = shortest_dist_2(1);
        shortest_dist(2) = shortest_dist_2(2);
        shortest_dist(3) = 1; %dummy som säger att noden är hittad i add_ways och inte data_umea.nodes
    end
        
    
    waitbar(1,h);
    delete(h)
    
    aaa = size(shortest_dist);
    if aaa(2) == 2
        hold on
        %cur = handles.current_intnd
        %plot(intnd(cur).lon, intnd(cur).lat)


        handles = guidata(hObject);
 
        node_intnd = {shortest_dist(2); 'intnd'}; %returnar position i int_nd för hittad node
        handles.current_node = node_intnd;
        guidata(hObject,handles);
    elseif aaa(2) == 3
        hold on
        %cur = handles.current_intnd
        %plot(intnd(cur).lon, intnd(cur).lat)


        handles = guidata(hObject);
       
        node_intnd = {shortest_dist(2); 'add_node'}; %returnar position i add_node för hittad node
        handles.current_node = node_intnd;
        guidata(hObject,handles);
    else
        node_intnd = {0;'false'};
    end
end
    
