function node_osm = decrypt_coords(coordinates,hObject,handles) %node_info: plats 1 = OSM id, plats 2 = intersection node ID
    h = waitbar(0,'Finding closest node');
    load('graph_data.mat','intnd_count','intnd','intnd_map','id_map') %beh�ver lite data..
    sensivity = 0.0120; %Vi kollar allts� i 0.0020 lat/lon distance i varje led
    close_intnd_pos_lon = []; 
    close_intnd = [];
    shortest_dist = 10; %s�tter som 10 => "dummy" variabel, kommer alltid skrivas �ver
    waitbar(0.25,h);
    for i = 1:intnd_count %Kollar igenom hela intnd, sparar undan positionen i intnd f�r match
        if (abs(intnd(i).lon - coordinates(1)) <= sensivity);
            close_intnd_pos_lon = [close_intnd_pos_lon i];
        end
    end
    waitbar(0.5,h);
    for i = close_intnd_pos_lon %Kollar igenom de positioner vi sparade, sparar ny position i intnd f�r match
        if (abs(intnd(i).lat - coordinates(2)) <= sensivity);
            close_intnd = [close_intnd i];
        end
    end
    waitbar(0.75,h);
    for i = close_intnd %Nu n�r vi hittat punkter som ligger inom "sensivity area", kollar vi vilken av dem som �r n�rmast
        coord_ref(1) = intnd(i).lon;
        coord_ref(2) = intnd(i).lat;

        distance = norm(coordinates - coord_ref); %"pythagoras sats"

        if distance < shortest_dist %om nya avst�ndet kortare �n gamla, uppdatera shortest dist
            shortest_dist(1) = distance; %avst�nd
            shortest_dist(2) = i; %vilken intnd det handlar om
        end
    end
    waitbar(1,h);
    delete(h)
    %disp('Shortest dist. intersection node id:')
    %disp(shortest_dist(2));
    %disp('Shortest dist. OSM node id:')
    %disp(intnd(shortest_dist(2)).id);
    hold on
    %cur = handles.current_intnd
    %plot(intnd(cur).lon, intnd(cur).lat)
    handles.current_intnd = shortest_dist(2);
    plot(intnd(shortest_dist(2)).lon,intnd(shortest_dist(2)).lat,'xc');
    pospoint =[intnd(shortest_dist(2)).lon,intnd(shortest_dist(2)).lat]
    
    handles=guidata(hObject);
    ispoint = isfield(handles,'im2');
    if ispoint == 1;
        delete(handles.im2)
    end
    
    handles.im2=impoint(gca,pospoint)
    setColor(handles.im2,'m')
    guidata(hObject,handles)
    node_osm = intnd(shortest_dist(2)).id;
    %return shortest_dist(2), anropa plot_nodes2 fast med nya OSM ID.,
    %plotta om
