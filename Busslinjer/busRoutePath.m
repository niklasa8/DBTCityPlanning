% Script for creating a file with the path of a specific busroute. The path
% is represented by node-id's. Script requries a loaded 'table' for the
% specific route.

clear nodes;
nodes = {table.id}; % Busstops in busroute, note in 'char' format.
path = {};
path{1} = nodes{1};
n_stops = max(size(nodes))

for i=1:n_stops-1
    from  = intnd_map(id_map(char(nodes{i})));
    to = intnd_map(id_map(char(nodes{i+1})));
    [dist,p,pred] = graphshortestpath(CGM_sparse,from,to);
    for j=2:size(p,2)
        nodeid = intnd(p(j)).id;
        path = [path nodeid] ;
    end
end