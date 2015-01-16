function agent_model22(graph_data,data_umea,CGM_sparse)

%load('graph_data.mat','CGM_sparse','edge','intnd','id_map','intnd_map','edge_index','spawn_locs','spawn_loc_paths','closest_park_nodes','pknd_map')
load('graph_data.mat','walk_all_shortest_path','edge','edge_index','spawn_locs','spawn_loc_paths','closest_park_nodes','pknd_map','dest_locs','n_city_spawn_locs','n_res_spawn_locs','n_res_dest_locs','n_city_dest_locs','n_influx_spawn_locs','n_influx_dest_locs')
%load('data_umea.mat')
%load('allToall_data.mat','spawn_loc_paths','spawn_locs')
node = data_umea.node;
park_nodes = data_umea.park_nodes;
intnd = graph_data.intnd;
intnd_map = graph_data.intnd_map;
intnd_count = graph_data.intnd_count;

n = 864;%number of timesteps.
n_cars = 1; %number of cars.
[x n_edges] = size(edge);
dt = 0.1;%seconds per timestep.
max_wait_time = 100;
afternoon_traffic_start = 15;
afternoon_traffic_stop = 18;
morning_traffic_start = 6;
morning_traffic_stop = 9;
p_spawn_car = @(t) (morning_traffic_start*3600/dt < t)*...
    (morning_traffic_stop*3600/dt > t) +...
    (afternoon_traffic_start*3600/dt < t)*...
    (afternoon_traffic_stop*3600/dt > t) + 0.1;

car(1).prev_node = intnd_map(park_nodes(1)); %First car spawning location.
car(1).dest = intnd_map(park_nodes(2)); %First car destination.
[~,car_path] = graphshortestpath(CGM_sparse,car(1).prev_node,car(1).dest); %Fastest path of first car.
car(1).next_node = car_path(2); %Next node on path.
car(1).edge = edge_index(car(1).prev_node,car(1).next_node); %Edge that first car is spawned on.
edge(car(1).edge).cars = [edge(car(1).edge).cars 1]; 
car(1).vel_factor = normrnd(1,0.1); %Velocity factor of first car.
car(1).vel = edge(car(1).edge).vel_lim*car(1).vel_factor; %Velocity calculated using velocity factor.
car(1).dist = 0;
car(1).prevNd_arr_time = 0;
car(1).next_car = 0;
car(1).car_behind = 0;
car(1).nodes_passed = 1;
car(1).path = spawn_loc_paths{car(n_cars).prev_node}(car(n_cars).dest);
car(1).parkings_tried = [];
cars_in_network = n_cars;
deleted_cars = [];
[x n_intnd] = size(intnd);

source_nodes = spawn_locs;
dest_nodes = dest_locs;

n_sources = max(size(source_nodes));
n_dests = max(size(dest_nodes));

car_done = [];

 for t = 1:n
    %t*100/n;
    for i = cars_in_network
        
        temp_dist = car(i).dist + car(i).vel*dt;
        
        if temp_dist > edge(car(i).edge).dist %If car reaches next node.
            
            time_on_edge = (t - car(i).prevNd_arr_time)*dt;
            edge(edge_index(car(i).prev_node,car(i).next_node)).time_on_edge = [edge(edge_index(car(i).prev_node,car(i).next_node)).time_on_edge time_on_edge];           
            
            car(i).prevNd_arr_time = t;
            
            car(i).prev_node = car(i).next_node; %Set previos node to the node it just reached.
            [x n_cars_edge] = size(edge(car(i).edge).cars);

            for j = 1:n_cars_edge %Loop that removes the car from the previous edge.
                if edge(car(i).edge).cars(j) == i
                    edge(car(i).edge).cars(j) = [];
                    break;
                end
            end

            if car(i).car_behind ~= 0 && ~isempty(car(i).car_behind) %When the car changes edge, the car behind it no longer has a car in front of it.
                car(car(i).car_behind).next_car = 0;
            end
                
            if car(i).prev_node ~= car(i).dest %Car has not reached its destination.

                %time_on_next = (temp_dist - edge(car(i).edge).dist)/(36*car(i).vel); %Time traveled on new edge.

                car(i).nodes_passed = car(i).nodes_passed + 1;
                car(i).next_node = car(i).path{1}(car(i).nodes_passed + 1); %The next node the car will reach is the next node in the fastest path.
                car(i).edge = edge_index(car(i).prev_node,car(i).next_node); %The edge that the car is riding on is updated.

                if isempty(edge(car(i).edge).cars) %If the new edge has no cars on it, the car has no cars in front of it.
                    car(i).next_car = 0;
                else %If the car does have cars on it, the next car is updated.
                    car(i).next_car = edge(car(i).edge).cars(end);
                    car(car(i).next_car).car_behind = i;
                end

                edge(car(i).edge).cars = [edge(car(i).edge).cars i]; %The car is added as a element in the new edges cars array.
                car(i).dist = 0;%time_on_next*car(i).vel; %The distance traveled on the new edge is the time it has spent on new edge times current velocity.
                temp_dist = 0;
            else %Car has reached its destination
                if ~isempty(intnd(car(i).dest).parking)
                    if intnd(car(i).dest).parking(3) < intnd(car(i).dest).parking(1)
                        intnd(car(i).dest).parking(3) = intnd(car(i).dest).parking(3) + 1;
                        index = find(cars_in_network == i); %Index of the car that is to be removed.
                        cars_in_network(index) = []; %Remove the car that has reached its destination.
                        deleted_cars = [deleted_cars i];
                        car_done = [car_done i];
                    else
                        stop = 0;
                        car(i).parkings_tried = [car(i).parkings_tried car(i).dest];
                        i3 = 1;

                        while stop == 0
                            i3 = i3 + 1;
                            car(i).dest = intnd_map(park_nodes(closest_park_nodes(pknd_map(car(i).dest),i3)));

                            if ~ismember(car(i).dest,car(i).parkings_tried)
                                stop = 1;
                            end
                        end

                        car(i).path = spawn_loc_paths{car(i).prev_node}(car(i).dest);
                        car(i).nodes_passed = 1;
                        car(i).next_node = car(i).path{1}(car(i).nodes_passed + 1);

                    end
                else
                    index = find(cars_in_network == i); %Index of the car that is to be removed.
                    cars_in_network(index) = []; %Remove the car that has reached its destination.
                    deleted_cars = [deleted_cars i];
                    car_done = [car_done i];
                end
            end %if car(i).prev_node
        end %if temp_dist
        
        force = 0;
        breaking = 0;
        
        if car(i).next_car > 0 %If the car has a car in front of it, the time difference between the current car and the car in front is calculated.
            dist_to_next = car(car(i).next_car).dist - temp_dist;
            time_to_next = dist_to_next/(car(i).vel);
        else %If the car does not have a car in front of it, time difference to next car is set to a big value.
            dist_to_next = inf;
            time_to_next = inf;
        end
        
        time_to_node = (edge(car(i).edge).dist - temp_dist)/(car(i).vel);
        
          %% HÖGERREGELN
          if edge(car(i).edge).edge_to_right ~= 0 %If there exist a edge to the right.
              if ~isempty(edge(edge(car(i).edge).edge_to_right).cars) % If there exist at least one car on that edge.
                  
                  % Take into account velocity of cars..??
                  % Check time distance between cars
                  %d1 = edge(car(i).edge).dist - temp_dist; % Distance to node for car i.
                  d2 = edge(car(edge(edge(car(i).edge).edge_to_right).cars(1)).edge).dist - car(edge(edge(car(i).edge).edge_to_right).cars(1)).dist; % Distance to node for car on the edge to right.
                  if d2/(car(edge(edge(car(i).edge).edge_to_right).cars(1)).vel) < 4
                      force = break_force(car(i).dist,edge(car(i).edge).dist - 2,car(i).vel,0);
                      breaking = 1;
                  end
              end
          end
        %%
         
        if car(i).next_car > 0 %Rule that makes sure that the car has the same velocity as the car ahead.
            if car(i).vel > car(car(i).next_car).vel
                vel1 = car(i).vel;
                vel2 = car(car(i).next_car).vel;
                dist1 = car(i).dist;
                dist2 = car(car(i).next_car).dist;
                temp_force = break_force(dist1,dist2,vel1,vel2);
                breaking = 1;
                if temp_force < force
                    force = temp_force;
                end
            end
        end
        
        if time_to_next < 3 && time_to_next > 0 %Rule that makes sure that the car in front is atleast 3 seconds ahead.
            breaking = 1;
            temp_force = -20*(3 - time_to_next)/3;
            if temp_force < force
                force = temp_force;
            end
        end
        
        if dist_to_next < 4 && dist_to_next > 0 %Rule that makes sure that the car in front is at least 4 meters ahead.
            breaking = 1;
            temp_force = -20*(4 - dist_to_next)/4;
            if temp_force < force
                force = temp_force;
            end
        end
        
        if car(i).vel == 0
            force = 0;
        end
        
        if breaking == 0 && (car(i).vel_factor.*edge(car(i).edge).vel_lim - car(i).vel) > 0.1 %If car has no obstacles it accelerates to its preffered speed.
            force = acc_force(car(i).vel,car(i).vel_factor,edge(car(i).edge).vel_lim);
        end
        
        %Update positions
        car(i).vel = car(i).vel + force*dt;
        
         if car(i).vel < 0
             car(i).vel = 0;
         end
        
        car(i).dist = car(i).dist + car(i).vel * dt;
        
%         if car(i).dist < edge(car(i).edge).dist
%             plot_car_i;
%         end
        %if mod(t,4) == 0
        %    car_plot(t/4).dist(i) = car(i).dist;
        %    car_plot(t/4).edge(i) = car(i).edge;
        %end
    end
    
    %if mod(t,4) == 0
    %        car_plot(t/4).cars_in_network = cars_in_network;
    %        car_plot(t/4).car_done = car_done;
    %        car_done = [];
    %end

    spawn_car = rand <= p_spawn_car(t);
    if spawn_car %Spawn new car.
        if isempty(deleted_cars) 
            n_cars = n_cars + 1;
            car_index = n_cars;
        else
            car_index = deleted_cars(1);
            deleted_cars(1) = [];
        end
        cars_in_network = [cars_in_network car_index];

        stop = 0;
        while stop == 0
            p_spawn_residential = 0.4 + 0.2*sin(2*pi*t/(86400/dt));
            p_spawn_city = 0.3 - 0.2*sin(2*pi*t/(86400/dt));
            p_spawn_influx = 0.3;
            p_dest_residential = 0.4 - 0.2*sin(2*pi*t/(86400/dt));
            p_dest_city = 0.3 + 0.2*sin(2*pi*t/(86400/dt));
            p_dest_influx = 0.3;
            
            type_of_spawn_loc = rand;
            if type_of_spawn_loc <= p_spawn_residential
                rand_index = randi([1 n_res_spawn_locs]);
            elseif type_of_spawn_loc > p_spawn_residential && type_of_spawn_loc <= p_spawn_city + p_spawn_residential
                rand_index = randi([n_res_spawn_locs + 1 n_city_spawn_locs + n_res_spawn_locs]);
                
                if node(park_nodes(rand_index - n_res_spawn_locs)).parking(3) > 0
                    node(park_nodes(rand_index - n_res_spawn_locs)).parking(3) = node(park_nodes(rand_index - n_res_spawn_locs)).parking(3) - 1;
                end
            elseif type_of_spawn_loc > p_spawn_city + p_spawn_residential && type_of_spawn_loc <= p_spawn_influx + p_spawn_city + p_spawn_residential
                rand_index = randi([n_city_spawn_locs + n_res_spawn_locs + 1 n_city_spawn_locs + n_res_spawn_locs + n_influx_spawn_locs])
            else
                rand_index = randi([n_city_spawn_locs + n_res_spawn_locs + n_influx_spawn_locs + 1 n_sources]);
            end
            
            car(car_index).prev_node = source_nodes(rand_index); %New car spawning node.
            
            type_of_dest_loc = rand;
            if type_of_dest_loc <= p_dest_residential
                rand_index = randi([1 n_res_dest_locs]);
            elseif type_of_dest_loc > p_dest_residential && type_of_dest_loc < p_dest_city + p_dest_residential
                rand_index = randi([n_res_dest_locs + 1 n_city_dest_locs + n_res_dest_locs]);
            elseif type_of_dest_loc > p_dest_city + p_dest_residential && type_of_dest_loc <= p_dest_influx + p_dest_city + p_dest_residential
                rand_index = randi([n_city_dest_locs + n_res_dest_locs + 1 n_city_dest_locs + n_res_dest_locs + n_influx_dest_locs])
            else
                rand_index = randi([n_city_dest_locs + n_res_dest_locs + 1 n_dests]);
            end
            
%             rand_index = randi(n_dests);
            car(car_index).dest = dest_nodes(rand_index); %New car destination node.
            car(car_index).path = spawn_loc_paths{car(car_index).prev_node}(car(car_index).dest);
            car(car_index).parkings_tried = [];

            if ~isempty(car(car_index).path{1}) && car(car_index).prev_node ~= car(car_index).dest
                stop = 1;
            end
        end

        car(car_index).prevNd_arr_time = t;
        car(car_index).nodes_passed = 1;
        car(car_index).next_node = car(car_index).path{1}(car(car_index).nodes_passed + 1); %Next node on path.
        car(car_index).edge = edge_index(car(car_index).prev_node,car(car_index).next_node); %Saves the edge that the car is spawned on.

        if ~isempty(edge(car(car_index).edge).cars) %If there are cars on the edge that the new car is spawned on.
            car(car_index).next_car = edge(car(car_index).edge).cars(end);
            car(car(car_index).next_car).car_behind = car_index;
        else %If there is no car on the edge that the new car is spawned on.
            car(car_index).next_car = 0;
        end

        edge(car(car_index).edge).cars = [edge(car(car_index).edge).cars car_index]; %Adds the new car to the edge.
        car(car_index).vel_factor = normrnd(1,0.1); %Randomizes new velocity factor.
        car(car_index).vel = min(edge(car(car_index).edge).vel_lim,edge(car(car_index).edge).avg_speed)*car(car_index).vel_factor; %Use velocity factor to determine the speed ofthe car.
        car(car_index).dist = 0;
        car(car_index).car_behind = 0;

    end
 end

for i = 1:n_edges
    
    if CGM_sparse(edge(i).from,edge(i).to) ~= 0 && CGM_sparse(edge(i).from,edge(i).to) ~= inf && ~isempty(edge(i).time_on_edge)
        CGM_sparse(edge(i).from,edge(i).to) = (CGM_sparse(edge(i).from,edge(i).to) + mean(edge(i).time_on_edge./3600))/2;
    end
end

% test_plot; %Plot background.
% axis('equal')
% axis('tight')
% 
% % for i = car_plot(t/4).cars_in_network
% %     car_pos = [intnd(car(i).prev_node).lon intnd(car(i).prev_node).lat];
% %     rand_color = rand(1,3);
% %     car_object(i) = rectangle('position',[car_pos 1.6 1.6],'facecolor',rand_color);
% %     set(car_object(i),'position',[car_pos 4 4]); %The position of the car is plotted.
% %     set(car_object(i),'visible','off')
% % end
% %car_object = zeros(1, car_plot(t/4).cars_in_network(length(car_plot(t/4).cars_in_network)));
% max_cars = 0;
% for i = 1:t/4
%     n_cars_network = max(size(car_plot(i).cars_in_network));
%     if n_cars_network > max_cars
%         max_cars = n_cars_network;
%     end
% end
% car_object = zeros(1, 400);
% 
% node_pos = [edge(car_plot(1).edge(1)).node_matrix(1,1) edge(car_plot(1).edge(1)).node_matrix(2,1)];
% rand_color = rand(1,3);
% car_pos = [intnd(car(1).prev_node).lon intnd(car(1).prev_node).lat];
% car_object(1) = rectangle('position',[car_pos 0.0004 0.0004],'facecolor',rand_color);
% for i = 1:t/4
%    for j = car_plot(i).cars_in_network
%        if car_plot(i).dist(j) < edge(car_plot(i).edge(j)).dist
%            if car_object(j) == 0
%                node_pos = [edge(car_plot(i).edge(j)).node_matrix(1,1) edge(car_plot(i).edge(j)).node_matrix(2,1)];
%                rand_color = rand(1,3);
%                car_object(j) = rectangle('position',[car_pos 0.0004 0.0004],'facecolor',rand_color);
%            end
%            plot_car_i
%        end
%    end
%    for k = car_plot(i).car_done
%        set(car_object(k), 'visible', 'off');
%    end
%    pause(0.01);
% end

car_all_shortest_path_agent = graphallshortestpaths(CGM_sparse);
car_path_toParking = car_all_shortest_path_agent(:,intnd_map(park_nodes));
walk_path_fromParking = walk_all_shortest_path(intnd_map(park_nodes),:);

for i = 1:intnd_count
    [minD,index] = min(walk_path_fromParking(:,i));
    carTo_walkFrom_parking_agent(:,i) = minD + car_path_toParking(:,index); %Snabbaste vägen med bil givet att man måste parkera.
end

clear car_path_toParking

save('graph_data.mat','CGM_sparse','car_all_shortest_path_agent','carTo_walkFrom_parking_agent','-append')
%save('graph_data.mat','CGM_sparse','carTo_walkFrom_parking_agent','-append')
end