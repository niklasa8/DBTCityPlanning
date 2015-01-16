function create_closest_park_nodes(graph_data, data_umea)

%load('data_umea.mat','park_nodes')

vars = whos('-file','graph_data');

if ismember('car_all_shortest_path_agent', {vars.name})
    load('graph_data.mat','car_all_shortest_path_agent')
    car_all_shortest_path = car_all_shortest_path_agent;
else
    load('graph_data.mat','car_all_shortest_path')
end
%load('graph_data.mat','car_all_shortest_path_agent')%,'intnd_count','intnd_map')


pknd_map = zeros(graph_data.intnd_count,1);
closest_park_nodes = zeros(max(size(data_umea.park_nodes)));
i2 = 0;

for i = data_umea.park_nodes

    i2 = i2 + 1;
    graph_data.intnd_map(i)
    pknd_map(graph_data.intnd_map(i)) = i2;
    temp_array = [];
    j2 = 0;
    
    for j = data_umea.park_nodes
        
        j2 = j2 + 1;
        temp_array = [temp_array car_all_shortest_path(i2,j2)];
        
    end
    
    [~,closest_park_nodes(i2,:)] = sort(temp_array);
end


save('graph_data.mat','closest_park_nodes','pknd_map','-append')
end