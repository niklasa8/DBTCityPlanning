function [redll,bluell,greenll] = plot_nodes3()

%Funktion som plottar vägar och returnerar noder.

%load('graph_data.mat','intnd_count','intnd','intnd_map','id_map','bicycling_graph','carTo_walkFrom_parking')
%load('data_umea.mat','node','way')

node_source = '444493179';
[x,n_ways] = size(way);
hold on

ind1 = 0;
ind2 = 0;
ind3 = 0;

for i = 1:intnd_count %Sparar itersection nodes och färglägger dem enligt snabbaste färdsättet.
    
    lat = intnd(i).lat;
    lon = intnd(i).lon;
    
    if carTo_walkFrom_parking(i,intnd_map(id_map(node_source))) ~= inf
        if bicycling_path(i,intnd_map(id_map(node_source))) < carTo_walkFrom_parking(i,intnd_map(id_map(node_source))) + 3/60 && bicycling_path(i,intnd_map(id_map(node_source))) < fastest_trip(i)
            %plot(lon,lat, 'r.')
            ind1 = ind1+1;
            redll(1,ind1) = lon;
            redll(2,ind1) = lat;
        end
    end
    if carTo_walkFrom_parking(i,intnd_map(id_map(node_source))) + 3/60 < bicycling_path(i,intnd_map(id_map(node_source))) && carTo_walkFrom_parking(i,intnd_map(id_map(node_source))) + 3/60 < fastest_trip(i)
        %plot(lon,lat, '.')        
        ind2 = ind2+1;
        bluell(1,ind2) = lon;
        bluell(2,ind2) = lat;
    end
    if carTo_walkFrom_parking(i,intnd_map(id_map(node_source))) ~= inf
        if fastest_trip(i) < bicycling_path(i,intnd_map(id_map(node_source))) && fastest_trip(i) < carTo_walkFrom_parking(i,intnd_map(id_map(node_source))) + 3/60
            %plot(lon,lat, 'g.')
            ind3 = ind3+1;
            greenll(1,ind3) = lon;
            greenll(2,ind3) = lat;
        end
    end
end

for i = 1:n_ways %Plottar vägarna mellan noderna, notera att ALLA noder används (även de som inte är intersection nodes) för att rita ut vägarna.
    if way(i).footway == 0
        [x n_ndref] = size(way(i).ndref);
        X = zeros(1,n_ndref);
        Y = zeros(1,n_ndref);
        for j = 1:n_ndref
            X(j) = node(id_map(way(i).ndref{j})).lon;
            Y(j) = node(id_map(way(i).ndref{j})).lat;
        end

        line('Ydata',Y,'Xdata',X,'Color','black');
    end
end