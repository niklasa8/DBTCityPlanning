%Fulskript som plottar noder och vägar för att visualisera så att debugging
%blir lättare. Notera att matlab måste ha vissa variabler som används
%idetta skript sprarad sedan tidigare, alltså måte skriptet create_graph ha
%körts utan att variablerna nollställts.

lat = zeros(1,intnd_count);
lon = zeros(1,intnd_count);

for i = 1:intnd_count %Plottar itersection nodes.
    
    lat(i) = str2double(intnd(i).lat);
    lon(i) = str2double(intnd(i).lon);
    
end

plot(lon,lat, '.')

for i = 1:n_ways %Plottar vägarna mellan noderna, notera att ALLA noder används (även de som inte är intersection nodes) för att rita ut vägarna.
    [x n_ndref] = size(way(i).ndref);
    X = zeros(1,n_ndref);
    Y = zeros(1,n_ndref);
    for j = 1:n_ndref
        X(j) = str2double(node(id_map(way(i).ndref{j})).lon);
        Y(j) = str2double(node(id_map(way(i).ndref{j})).lat);
    end
    
    line('Ydata',Y,'Xdata',X);
    
end
