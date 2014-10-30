function node_osm = decrypt_coords(coordinates) %node_info: plats 1 = OSM id, plats 2 = intersection node ID
    h = waitbar(0,'Finding closest node');
    load('graph_data.mat','intnd_count','intnd','intnd_map','id_map') %behöver lite data..
    sensivity = 0.0020; %Vi kollar alltså i 0.0020 lat/lon distance i varje led
    close_intnd_pos_lon = []; 
    close_intnd = [];
    shortest_dist = 10; %sätter som 10 => "dummy" variabel, kommer alltid skrivas över
    waitbar(0.25,h);
    for i = 1:intnd_count %Kollar igenom hela intnd, sparar undan positionen i intnd för match
        if (abs(intnd(i).lon - coordinates(1)) <= sensivity)
            close_intnd_pos_lon = [close_intnd_pos_lon i];
        end
    end
    waitbar(0.5,h);
    for i = close_intnd_pos_lon %Kollar igenom de positioner vi sparade, sparar ny position i intnd för match
        if (abs(intnd(i).lat - coordinates(2) <= sensivity))
            close_intnd = [close_intnd i];
        end
    end
    waitbar(0.75,h);
    for i = close_intnd %Nu när vi hittat punkter som ligger inom "sensivity area", kollar vi vilken av dem som är närmast
        coord_ref(1) = intnd(i).lon;
        coord_ref(2) = intnd(i).lat;

        distance = norm(coordinates - coord_ref); %"pythagoras sats"

        if distance < shortest_dist %om nya avståndet kortare än gamla, uppdatera shortest dist
            shortest_dist(1) = distance; %avstånd
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
    node_osm = intnd(shortest_dist(2)).id;
    %return shortest_dist(2), anropa plot_nodes2 fast med nya OSM ID.,
    %plotta om
end