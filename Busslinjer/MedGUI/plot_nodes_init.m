function plot_nodes_init(graph_data,data_umea)
%Fulskript som plottar noder och v�gar f�r att visualisera s� att debugging
%blir l�ttare.

%load('graph_data.mat','intnd_count','intnd','id_map')
%load('data_umea.mat','node','way')

countPark = 0;

[x,n_ways] = size(data_umea.way);
hold on
for i = 1:graph_data.intnd_count %Plottar itersection nodes och f�rgl�gger dem enligt snabbaste f�rds�ttet.
    lat = graph_data.intnd(i).lat;
    lon = graph_data.intnd(i).lon;
    plot(lon,lat, '.')
     
        
end

for i = 1:n_ways %Plottar v�garna mellan noderna, notera att ALLA noder anv�nds (�ven de som inte �r intersection nodes) f�r att rita ut v�garna.
    [x, n_ndref] = size(data_umea.way(i).ndref);
    X = zeros(1,n_ndref);
    Y = zeros(1,n_ndref);
    for j = 1:n_ndref
        X(j) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{j})).lon;
        Y(j) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{j})).lat;
    end
    
    line('Ydata',Y,'Xdata',X);
end
hold off
