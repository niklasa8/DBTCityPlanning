clear
load('graph_data')
load('data')

n = 10000;%number of timesteps.
n_cars = 1; %number of cars.
[x n_edges] = size(edge);
dt = 0.1;%seconds per timestep.
max_wait_time = 100;

test_plot; %Plot background.
axis('equal')
axis('tight')
intnd(10).traffic_signals = 1;
intnd(38).traffic_signals = 1;
traffic_lights;

% traffic_lights_index = find([intnd.traffic_lights]);
% [x n_traffic_lights] = size(traffic_lights_index);
% 
% for i = 1:n_traffic_lights
%     traffic_lights(i).edges_dir1
%     traffic_lights(i).edges_dir2
% end

car(1).prev_node = 1; %First car spawning location.
car(1).dest = 7; %First car destination.
[~,car_path,pred] = graphshortestpath(sparse(graph_matrix),car(1).prev_node,car(1).dest); %Fastest path of first car.

car(1).path =car_path;
car(1).it = 2;

car(1).next_node = car(1).path(car(1).it); %Next node on path.
car(1).edge = edge_index(car(1).prev_node,car(1).next_node); %Edge that first car is spawned on.
edge(car(1).edge).cars = [edge(car(1).edge).cars 1]; 
car(1).vel_factor = normrnd(1,0.1); %Velocity factor of first car.
car(1).vel = edge(car(1).edge).vel_lim*car(1).vel_factor; %Velocity calculated using velocity factor.
car(1).dist = 0;
car(1).next_car = 0;
car(1).car_behind = 0;
car_pos = [intnd(car(1).prev_node).lon intnd(car(1).prev_node).lat];
car_object(1) = rectangle('position',[car_pos 5 5],'facecolor','k');
cars_in_network = n_cars;
[x n_intnd] = size(intnd);
source_nodes = [1 7 8 12 20 22 23 28 29 30 34 37 42 44 45 46 47];
% source_nodes = [30];
dest_nodes = [1 7 8 12 20 22 23 28 29 30 34 37 42 44 45 46 47];
% dest_nodes = [34];
[x n_sources] = size(source_nodes);

 for t = 1:n
    
    for i = cars_in_network
        
        temp_dist = car(i).dist + car(i).vel*dt;
        
        if temp_dist > edge(car(i).edge).dist %If car reaches next node.
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

                for j = 1:n_edges %Loop that recalculates the graph matrix.
                    if ~isempty(edge(j).cars)
                        edge(j).avg_speed = mean([car(edge(j).cars).vel]);
                    end
                    graph_matrix(edge(j).from,edge(j).to) = min(edge(j).dist./min(edge(j).vel_lim,edge(j).avg_speed),max_wait_time);
                end

                %[~,car_path,pred] = graphshortestpath(sparse(graph_matrix),car(i).prev_node,car(i).dest); %graph_matrix is used to calculate fastest path.
                car(i).it = car(i).it + 1;
                car(i).next_node = car(i).path(car(i).it); %The next node the car will reach is the next node in the fastest path.
                car(i).edge = edge_index(car(i).prev_node,car(i).next_node); %The edge that the car is riding on is updated.
                edge(car(i).edge).n_usage = edge(car(i).edge).n_usage + 1;

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
                set(car_object(i),'visible','off')
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
          if car(i).dest ~= edge(car(i).edge).to
              if edge(car(i).edge).edge_to_right ~= 0%If there exist a edge to the right.
                  if edge(edge(car(i).edge).edge_to_right).from ~= car(i).path(car(i).it + 1)
                      if ~isempty(edge(edge(car(i).edge).edge_to_right).cars) % If there exist at least one car on that edge.
                          
                          % Take into account velocity of cars..??
                          % Check time distance between cars
                          %d1 = edge(car(i).edge).dist - temp_dist; % Distance to node for car i.
                          d2 = edge(car(edge(edge(car(i).edge).edge_to_right).cars(1)).edge).dist - car(edge(edge(car(i).edge).edge_to_right).cars(1)).dist; % Distance to node for car on the edge to right.
                          if d2/(car(edge(edge(car(i).edge).edge_to_right).cars(1)).vel) < 4
                              force = break_force(car(i).dist,edge(car(i).edge).dist - 2,car(i).vel,edge(car(i).edge).vel_lim*0.3);
                              breaking = 1;
                          end
                      end
                  end
              end
          end 
        end
        %% VÄJNINGSPLIKT. When turning to the left
        if car(i).dest ~= edge(car(i).edge).to
            if edge(car(i).edge).edge_to_front ~= 0
                if edge(car(i).edge).edge_to_left ~= 0%If there exist a edge to the front.
                    if edge(edge(car(i).edge).edge_to_left).from == car(i).path(car(i).it + 1)
                        if ~isempty(edge(edge(car(i).edge).edge_to_front).cars) % If there exist at least one car on that edge.
                            
                            % Take into account velocity of cars..??
                            % Check time distance between cars
                            %d1 = edge(car(i).edge).dist - temp_dist; % Distance to node for car i.
                            d2 = edge(car(edge(edge(car(i).edge).edge_to_front).cars(1)).edge).dist - car(edge(edge(car(i).edge).edge_to_front).cars(1)).dist; % Distance to node for car on the edge to right.
                            if d2/(car(edge(edge(car(i).edge).edge_to_front).cars(1)).vel) < 4
                                force = break_force(car(i).dist,edge(car(i).edge).dist - 2,car(i).vel,0);
                                breaking = 1;
                            end
                        end
                    end
                end
            end
        end
        
        %% TURNING. Slow down as the car approaches a turn
        if breaking == 0
        right = 0;
        left = 0;
        if edge(car(i).edge).edge_to_right ~= 0
            right = (car(i).path(car(i).it + 1) == edge(edge(car(i).edge).edge_to_right).from);
        end
        if edge(car(i).edge).edge_to_left ~= 0
            left =(car(i).path(car(i).it + 1) == edge(edge(car(i).edge).edge_to_left).from);
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
        
        if breaking == 0 %If car has no obstacles it accelerates to its preffered speed.
            force = acc_force(car(i).vel,car(i).vel_factor,edge(car(i).edge).vel_lim);
        end
        
        %Update positions
        car(i).vel = car(i).vel + force*dt;
        
         if car(i).vel < 0
             car(i).vel = 0;
         end
        
        car(i).dist = car(i).dist + car(i).vel * dt;
        
        if car(i).dist < edge(car(i).edge).dist
            plot_car_i;
        end
    end

    if mod(t,15) == 0 %Spawn new car.
        n_cars = n_cars + 1;
        cars_in_network = [cars_in_network n_cars];
        rand_index = randi([1 n_sources]);
        car(n_cars).prev_node = source_nodes(rand_index); %New car spawning node.
        rand_index = randi([1 n_sources]);
        car(n_cars).dest = dest_nodes(rand_index); %New car destination node.
        while car(n_cars).dest == car(n_cars).prev_node
            rand_index = randi([1 n_sources]);
            car(n_cars).dest = dest_nodes(rand_index); %New car destination node.
        end
        
        for j = 1:n_edges %Recalculate the graph matrix
            
            if ~isempty(edge(j).cars)
                edge(j).avg_speed = mean([car(edge(j).cars).vel]);
            else
                edge(j).avg_speed = edge(j).vel_lim;
            end
            
            graph_matrix(edge(j).from,edge(j).to) = min(edge(j).dist./min(edge(j).vel_lim,edge(j).avg_speed),max_wait_time);
            
            
        end
        
        [~,car_path,pred] = graphshortestpath(sparse(graph_matrix),car(n_cars).prev_node,car(n_cars).dest); %Calculate fastest path.
        car(n_cars).it = 2;
        car(n_cars).path = car_path;
        car(n_cars).next_node = car(n_cars).path(car(n_cars).it); %Next node on path.
        car(n_cars).edge = edge_index(car(n_cars).prev_node,car(n_cars).next_node); %Saves the edge that the car is spawned on.
        edge(car(i).edge).n_usage = edge(car(i).edge).n_usage + 1;
        
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
        car_pos = [intnd(car(i).prev_node).lon intnd(car(i).prev_node).lat];
        rand_color = rand(1,3);
        car_object(n_cars) = rectangle('position',[car_pos 1.6 1.6],'facecolor',rand_color);
        car(n_cars).next_car;
    end
    
    %% TRAFIKLJUS.
    for k = 1:nr_of_lights
        if light(k).mode == 1% Depend only on time
            light(k).timer = light(k).timer + dt;
            if abs(light(k).timer - light(k).period/2) < 10^(-6)
                set(light_object(k), 'facecolor', 'red');
                light(i).first = 0;
                light(i).second = 1;
            end
            
            light(k).timer
            light(k).period
            if abs(light(k).timer - light(k).period) < 10^(-6)
                set(light_object(k), 'facecolor', 'green');
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
                        set(light_object(k), 'facecolor', 'red');
                    end
                    if light(k).secondEdges(j) ~= 0 && isempty(edge(light(k).secondEdges(j)).cars)
                        light(k).first = 1;
                        light(k).second = 0;
                        set(light_object(k), 'facecolor', 'green');
                    end
                end
            elseif abs(light(k).timer-light(k).period/2) < 10^(-6)
                for j = 1:2
                    if light(k).secondEdges(j) ~= 0 && (~isempty(edge(light(k).secondEdges(j)).cars))
                        if (light(k).first == 1)
                            light(k).first = 0;
                            light(k).second = 1;
                            light(k).timer = 0;
                            set(light_object(k), 'facecolor', 'red');
                        else
                            light(k).timer = 0;
                        end
                    elseif light(k).firstEdges(j) ~= 0 && (~isempty(edge(light(k).firstEdges(j)).cars))
                        if (light(k).second == 1)
                            light(k).first = 1;
                            light(k).second = 0;
                            light(k).timer = 0;
                            set(light_object(k), 'facecolor', 'green');
                        else
                            light(k).timer = 0;
                        end
                    else
                        light(k).timer = 0;
                    end
                end
            end
            light(k).timer = light(k).timer + dt;
%             light(k).timer
            
        end
        if light(k).mode == 3% Green wave
            if abs(light(k).timer -light(k).period/light(k).GW_tot*(light(k).GW_nr-1)) < 10^(-6)
                light(k).second = 0;
                light(k).first = 1;
                set(light_object(k), 'facecolor', 'green');
            end
            if light(k).GW_nr == light(k).GW_tot
                if abs(light(k).timer -light(k).period/light(k).GW_tot) < 10^(-6)
                    light(k).second = 1;
                    light(k).first = 0;
                    set(light_object(k), 'facecolor', 'red');
                end
            elseif (light(k).GW_nr + 1) == light(k).GW_tot    
                light(k).timer
                if light(k).timer < 10^(-6)
                    light(k).second = 1;
                    light(k).first = 0;
                    set(light_object(k), 'facecolor', 'red');
                end                
            else
                if abs(light(k).timer - 2*light(k).period/light(k).GW_tot*(light(k).GW_nr)) < 10^(-6)
                    light(k).second = 1;
                    light(k).first = 0;
                    set(light_object(k), 'facecolor', 'red');
                end
            end
            light(k).timer = light(k).timer + dt;
            
            if abs(light(k).timer - light(k).period) < 10^(-6)
                light(k).timer = 0;
            end
        end
        
        
    end
    %%
    pause(0.01)
 end