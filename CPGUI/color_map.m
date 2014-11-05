function color_map(timematrix,starting_node,res,bt) % Har ej kört koden.

% timematrix - Matrisen vars tider ska visualiseras.
% starting_node - Noden för vilken tidsmatrisen gäller.
% res - Antal minuter per nyans.
% bt - För tider över bt färgas noderna svart.

load('graph_data.mat','intnd_count','intnd','intnd_map','id_map','bicycling_graph','carTo_walkFrom_parking')
load('data_umea.mat','node','way')

hold on

nrofintervals = ceil(bt/res);
t = timematrix(:,starting_node);

lat = intnd.lat;
lon = intnd.lon;

for i=1:nrofintervals
    x = find(t<i*res);
    t(x) = inf;
    % Plotta noderna i cyan. Ju längre tid desto mörkare.
    nuance = 1-(i-1)*1/nrintervals;
    plot(lon(x),lat(x),'.','color',[0 nuance nuance])
end
% Plotta övriga nåbara noder svarta.
x = find(t<inf);
plot(lon(x),lat(x),'.','color',[0 0 0])

% Kod sedan tidigare.
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
