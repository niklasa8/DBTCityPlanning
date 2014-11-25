
edges = [63 66;103 106; 65 68; 116 113;67 70;79 82];

j = 0;
node = (3);


for i = 31:33 % The nodes to use
    j = j + 1; 
    light_pos(j).lon = intnd(i).lon;
    light_pos(j).lat = intnd(i).lat;
    node(j) = i;
end
nr_of_lights = j;


% modes: time= 1, traffic = 2

light_object = (nr_of_lights);
for i = 1:nr_of_lights
    light_object(i) = rectangle('curvature', [1,1], 'position', [light_pos(i).lon+10 light_pos(i).lat 8 8], 'facecolor', 'red');
    light(i).first = 1;
    light(i).second = 0;
    light(i).firstEdges = edges(i*2-1,:);
    light(i).secondEdges = edges(i*2,:);
    light(i).period = 40.0;
    light(i).timer = 0;
    light(i).node = node(i);
    light(i).mode = 2;
    
end