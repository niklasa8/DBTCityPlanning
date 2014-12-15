clear
load('graph_data.mat','CGM_sparse','edge','intnd','id_map','edge_index','spawn_locs','spawn_loc_paths')
% load('data_umea.mat','way','node')
%load('allToall_data.mat','spawn_loc_paths','spawn_locs')

n = 864;%number of timesteps.
n_cars = 1; %number of cars.
[x n_edges] = size(edge);
dt = 1;%seconds per timestep.
max_wait_time = 100;


traffic_lights;

car(1).prev_node = 1; %First car spawning location.
car(1).dest = 7; %First car destination.
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
cars_in_network = n_cars;
[x n_intnd] = size(intnd);

source_nodes = spawn_locs;
dest_nodes = 2000:5000;
n_sources = max(size(source_nodes));


car_done = [];

profile on
% car_plot = (n/4);
 for t = 1:n
    t*100/n
    
    for i = cars_in_network
        
        temp_dist = car(i).dist + car(i).vel*dt;
        
        if temp_dist > edge(car(i).edge).dist %If car reaches next node.
            
            time_on_edge = t - car(i).prevNd_arr_time;
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
                
                index = find(cars_in_network == i); %Index of the car that is to be removed.
                cars_in_network(index) = []; %Remove the car that has reached its destination.
                car_done = [car_done i];
%                 set(car_object(i),'visible','off')
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
        
        %% TRAFIKSIGNAL
        if nr_of_lights > 0
        for k = 1:nr_of_lights
        if light(k).node == edge(car(i).edge).to
            if find(light(k).firstEdges == car(i).edge)
                if light(k).first == 0;
                    if edge(car(i).edge).dist - car(i).dist < 10
                        force = break_force(car(i).dist,edge(car(i).edge).dist - 2,car(i).vel,0);
                        breaking = 1;
                    end
                end
            elseif find(light(k).secondEdges == car(i).edge)
                if light(k).second == 0;
                    if edge(car(i).edge).dist - car(i).dist < 10
                        force = break_force(car(i).dist,edge(car(i).edge).dist - 2,car(i).vel,0);
                        breaking = 1;
                    end
                end
            end
        end
        end
        else
        
          %% H�GERREGELN
          if edge(car(i).edge).edge_to_right ~= 0 %If there exist a edge to the right.
              if ~isempty(edge(edge(car(i).edge).edge_to_right).cars) % If there exist at least one car on that edge.
                      dbt2014
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
        end
        %% VÄJNINGSPLIKT. When turning to the left
        if car(i).dest ~= edge(car(i).edge).to
            if edge(car(i).edge).edge_to_front ~= 0
                if edge(car(i).edge).edge_to_left ~= 0%If there exist a edge to the front.
                    if edge(edge(car(i).edge).edge_to_left).from == car(i).path{1}(car(i).nodes_passed + 1)
                        if ~isempty(edge(edge(car(i).edge).edge_to_front).cars) % If there exist at least one car on that edge.
                            
                            % Take into account velocity of cars..??
                            % Check time distance between cars
                            %d1 = edge(car(i).edge).dist - temp_dist; % Distance to node for car i.
                            d2 = edge(car(edge(edge(car(i).edge).edge_to_front).cars(1)).edge).dist - car(edge(edge(car(i).edge).edge_to_front).cars(1)).dist; % Distance to node for car on the edge to right.
                            if d2/(car(edge(edge(car(i).edge).edge_to_front).cars(1)).vel) < 4
                                forcedbt2014 = break_force(car(i).dist,edge(car(i).edge).dist - 2,car(i).vel,0);
                                breaking = 1;
                            end
                        end
                    end
                end
            end
        end
        
        %% TURNING. Slow down as the car approaches a turn
        if breaking == 0 && car(i).next_node ~= car(i).dest
            right = 0;
            left = 0;
            if edge(car(i).edge).edge_to_right ~= 0
                right = (car(i).path{1}(car(i).nodes_passed + 1) == edge(edge(car(i).edge).edge_to_right).from);
            end
            if edge(car(i).edge).edge_to_left ~= 0
                left =(car(i).path{1}(car(i).nodes_passed + 1) == edge(edge(car(i).edge).edge_to_left).from);
            end
            if right || left
                d = edge(car(i).edge).dist - car(i).dist;
                if d < 10 && car(i).vel > edge(car(i).edge).vel_lim*0.5
                    breaking = 1;
                    force = break_force(car(i).dist,edge(car(i).edge).dist,car(i).vel,edge(car(i).edge).vel_lim*0.5);
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
%% Add car position to memory
        if mod(t,4) == 0
            car_plot(t/4).dist(i) = car(i).dist;
            car_plot(t/4).edge(i) = car(i).edge;
        end
    end
    if mod(t,4) == 0
            car_plot(t/4).cars_in_network = cars_in_network;
            car_plot(t/4).car_done = car_done;
            car_done = [];
    end
        
    if mod(t,1) == 0 %Spawn new car.
        n_cars = n_cars + 1;
        cars_in_network = [cars_in_network n_cars];
        
        stop = 0;
        while stop == 0
            rand_index = randi([1 n_sources]);
            car(n_cars).prev_node = source_nodes(rand_index); %New car spawning node.
            rand_index = randi([1 n_sources]);
            car(n_cars).dest = dest_nodes(rand_index); %New car destination node.
            car(n_cars).path = spawn_loc_paths{car(n_cars).prev_node}(car(n_cars).dest);
            
            if ~isempty(car(n_cars).path{1})
                stop = 1;
            end
        end
        
        car(n_cars).prevNd_arr_time = t;
        car(n_cars).nodes_passed = 1;
        car(n_cars).next_node = car(n_cars).path{1}(car(n_cars).nodes_passed + 1); %Next node on path.
        car(n_cars).edge = edge_index(car(n_cars).prev_node,car(n_cars).next_node); %Saves the edge that the car is spawned on.
        
        if ~isempty(edge(car(n_cars).edge).cars) %If there are cars on the edge that the new car is spawned on.
            car(n_cars).next_car = edge(car(n_cars).edge).cars(end);
            car(car(n_cars).next_car).car_behind = n_cars;
        else %If there is no car on the edge that the new car is spawned on.
            car(n_cars).next_car = 0;
        end
        
        edge(car(n_cars).edge).cars = [edge(car(n_cars).edge).cars n_cars]; %Adds the new car to the edge.
        car(n_cars).vel_factor = normrnd(1,0.1); %Randomizes new velocity factor.
        car(n_cars).vel = min(edge(car(n_cars).edge).vel_lim,edge(car(n_cars).edge).avg_speed)*car(n_cars).vel_factor; %Use velocity factor to determine the speed ofthe car.
        car(n_cars).dist = 0;
        car(n_cars).car_behind = 0;
    end
    
        %% TRAFIKLJUS.
    for k = 1:nr_of_lights
        if light(k).mode == 1% Depend only on time
            light(k).timer = light(k).timer + dt;
            if abs(light(k).timer - light(k).period/2) < 10^(-6)
%                 set(light_object(k), 'facecolor', 'red');
                light(i).first = 0;
                light(i).second = 1;
            end
            
            light(k).timer
            light(k).period
            if abs(light(k).timer - light(k).period) < 10^(-6)
%                 set(light_object(k), 'facecolor', 'green');
                light(k).first = 1;
                light(k).second = 0;
                light(k).timer = 0;
            end
        end
        if light(k).mode == 2% depend on traffic
            if light(k).timer < 10^(-6)
                for j = 1:2
                    if light(k).firstEdges(j) ~= 0 && isempty(edge(light(k).firstEdges(j)).cars)
                        light(k).first = 0;
                        light(k).second = 1;
%                         set(light_object(k), 'facecolor', 'red');
                    end
                    if light(k).secondEdges(j) ~= 0 && isempty(edge(light(k).secondEdges(j)).cars)
                        light(k).first = 1;
                        light(k).second = 0;
%                         set(light_object(k), 'facecolor', 'green');
                    end
                end
            elseif abs(light(k).timer-light(k).period/2) < 10^(-6)
                for j = 1:2
                    if light(k).secondEdges(j) ~= 0 && (~isempty(edge(light(k).secondEdges(j)).cars))
                        if (light(k).first == 1)
                            light(k).first = 0;
                            light(k).second = 1;
                            light(k).timer = 0;
%                             set(light_object(k), 'facecolor', 'red');
                        else
                            light(k).timer = 0;
                        end
                    elseif light(k).firstEdges(j) ~= 0 && (~isempty(edge(light(k).firstEdges(j)).cars))
                        if (light(k).second == 1)
                            light(k).first = 1;
                            light(k).second = 0;
                            light(k).timer = 0;
%                             set(light_object(k), 'facecolor', 'green');
                        else
                            light(k).timer = 0;
                        end
                    else
                        light(k).timer = 0;
                    end
                end
            end
            light(k).timer = light(k).timer + dt;    
        end
        
        if light(k).mode == 3% Green wave
            if abs(light(k).timer -light(k).period/light(k).GW_tot*(light(k).GW_nr-1)) < 10^(-6)
                light(k).second = 0;
                light(k).first = 1;
%                 set(light_object(k), 'facecolor', 'green');
            end
            if light(k).GW_nr == light(k).GW_tot
                if abs(light(k).timer -light(k).period/light(k).GW_tot) < 10^(-6)
                    light(k).second = 1;
                    light(k).first = 0;
%                     set(light_object(k), 'facecolor', 'red');
                end
            elseif (light(k).GW_nr + 1) == light(k).GW_tot    
                light(k).timer
                if light(k).timer < 10^(-6)
                    light(k).second = 1;
                    light(k).first = 0;
%                     set(light_object(k), 'facecolor', 'red');
                end                
            else
                if abs(light(k).timer - 2*light(k).period/light(k).GW_tot*(light(k).GW_nr)) < 10^(-6)
                    light(k).second = 1;
                    light(k).first = 0;
%                     set(light_object(k), 'facecolor', 'red');
                end
            end
            light(k).timer = light(k).timer + dt;
            
            if abs(light(k).timer - light(k).period) < 10^(-6)
                light(k).timer = 0;
            end
        end
        
        
    end
    
 end
 
profile viewer
p = profile('info');
profsave(p,'profile_results')


test_plot; %Plot background.
axis('equal')
axis('tight')

% for i = car_plot(t/4).cars_in_network
%     car_pos = [intnd(car(i).prev_node).lon intnd(car(i).prev_node).lat];
%     rand_color = rand(1,3);
%     car_object(i) = rectangle('position',[car_pos 1.6 1.6],'facecolor',rand_color);
%     set(car_object(i),'position',[car_pos 4 4]); %The position of the car is plotted.
%     set(car_object(i),'visible','off')
% end
car_object = zeros(1, car_plot(t/4).cars_in_network(length(car_plot(t/4).cars_in_network)));
node_pos = [edge(car_plot(1).edge(1)).node_matrix(1,1) edge(car_plot(1).edge(1)).node_matrix(2,1)];
rand_color = rand(1,3);
car_pos = [intnd(car(1).prev_node).lon intnd(car(1).prev_node).lat];
car_object(1) = rectangle('position',[car_pos 0.0004 0.0004],'facecolor',rand_color);
for i = 1:t/4
   for j = car_plot(i).cars_in_network
       if car_plot(i).dist(j) < edge(car_plot(i).edge(j)).dist
           if car_object(j) == 0
               node_pos = [edge(car_plot(i).edge(j)).node_matrix(1,1) edge(car_plot(i).edge(j)).node_matrix(2,1)];
               rand_color = rand(1,3);
               car_object(j) = rectangle('position',[car_pos 0.0004 0.0004],'facecolor',rand_color);
           end
           plot_car_i
       end
   end
   for k = car_plot(i).car_done
       set(car_object(k), 'visible', 'off');
   end
   pause(0.01);
end