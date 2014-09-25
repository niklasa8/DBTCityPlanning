%Fulskript som plottar noder och v�gar f�r att visualisera s� att debugging
%blir l�ttare. Notera att matlab m�ste ha vissa variabler som anv�nds
%idetta skript sprarad sedan tidigare, allts� m�te skriptet create_graph ha
%k�rts utan att variablerna nollst�llts.

lat = zeros(1,intnd_count);
lon = zeros(1,intnd_count);

for i = 1:intnd_count %Plottar itersection nodes.
    
    lat(i) = str2double(intnd(i).lat);
    lon(i) = str2double(intnd(i).lon);
    
end

plot(lon,lat, '.')

for i = 1:n_ways %Plottar v�garna mellan noderna, notera att ALLA noder anv�nds (�ven de som inte �r intersection nodes) f�r att rita ut v�garna.
    [x n_ndref] = size(way(i).ndref);
    X = zeros(1,n_ndref);
    Y = zeros(1,n_ndref);
    for j = 1:n_ndref
        X(j) = str2double(node(id_map(way(i).ndref{j})).lon);
        Y(j) = str2double(node(id_map(way(i).ndref{j})).lat);
    end
    
    line('Ydata',Y,'Xdata',X);
    
end
