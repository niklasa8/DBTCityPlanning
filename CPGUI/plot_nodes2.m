function plot_nodes2(fastest_trip, node_source)
%Fulskript som plottar noder och vägar för att visualisera så att debugging
%blir lättare.

load('graph_data.mat','intnd_count','intnd','intnd_map','id_map','bicycling_path','carTo_walkFrom_parking')
load('data_umea.mat','node','way')

%node_source = '444493179';
[x,n_ways] = size(way);
hold on
for i = 1:intnd_count %Plottar itersection nodes och färglägger dem enligt snabbaste färdsättet.
    lat = intnd(i).lat;
    lon = intnd(i).lon;
    
    if carTo_walkFrom_parking(i,intnd_map(id_map(node_source))) ~= inf
        if bicycling_path(i,intnd_map(id_map(node_source))) < carTo_walkFrom_parking(i,intnd_map(id_map(node_source))) + 3/60 && bicycling_path(i,intnd_map(id_map(node_source))) < fastest_trip(i)
            plot(lon,lat, 'r.')
        end
    end
    if carTo_walkFrom_parking(i,intnd_map(id_map(node_source))) + 3/60 < bicycling_path(i,intnd_map(id_map(node_source))) && carTo_walkFrom_parking(i,intnd_map(id_map(node_source))) + 3/60 < fastest_trip(i)
        plot(lon,lat, '.')
    end
    if carTo_walkFrom_parking(i,intnd_map(id_map(node_source))) ~= inf
        if fastest_trip(i) < bicycling_path(i,intnd_map(id_map(node_source))) && fastest_trip(i) < carTo_walkFrom_parking(i,intnd_map(id_map(node_source))) + 3/60
             plot(lon,lat, 'g.')
        end
    end
end

%plottar current "selected node"
%handles.current_intnd = intnd_map(id_map(node_source))
%cur = handles.current_intnd
%plot(intnd(cur).lon, intnd(cur).lat, 'xc')



for i = 1:n_ways %Plottar vägarna mellan noderna, notera att ALLA noder används (även de som inte är intersection nodes) för att rita ut vägarna.
    if way(i).footway == 0
        [x n_ndref] = size(way(i).ndref);
        X = zeros(1,n_ndref);
        Y = zeros(1,n_ndref);
        for j = 1:n_ndref
            X(j) = node(id_map(way(i).ndref{j})).lon;
            Y(j) = node(id_map(way(i).ndref{j})).lat;
        end

        line('Ydata',Y,'Xdata',X);
    end
end
hold off
end