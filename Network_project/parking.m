

nodes = [10 11 27 35];

for i = nodes % The nodes to use
    j = j + 1; 
    parking_pos(j).lon = intnd(i).lon;
    parking_pos(j).lat = intnd(i).lat;
    node(j) = i;
end


for i = 1:nr_edges
    if edge(i).parking == 1
        edge(i).to
    end
end
parking_object = (nr_of_parking_places);