% Generate new array of busnodes

for i=1:175
    bus_stop_nodes(i) = intnd_map(id_map(num2str(busMapInt(i)))); 
end
save('Data/bus_stop_nodes');
