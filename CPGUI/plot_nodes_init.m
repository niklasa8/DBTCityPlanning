function plot_nodes_init
%Fulskript som plottar noder och v�gar f�r att visualisera s� att debugging
%blir l�ttare.

load('graph_data.mat','intnd_count','intnd','id_map')
load('data_umea.mat','node','way')

[x,n_ways] = size(way);
hold on
for i = 1:intnd_count %Plottar itersection nodes och f�rgl�gger dem enligt snabbaste f�rds�ttet.
    lat = intnd(i).lat;
    lon = intnd(i).lon;
    plot(lon,lat, '.')
end

for i = 1:n_ways %Plottar v�garna mellan noderna, notera att ALLA noder anv�nds (�ven de som inte �r intersection nodes) f�r att rita ut v�garna.
    if way(i).footway == 0
        [x, n_ndref] = size(way(i).ndref);
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
