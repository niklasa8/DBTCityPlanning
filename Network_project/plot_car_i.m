index = find(edge(car_plot(i).edge(j)).node_matrix(3,:) <= car_plot(i).dist(j),1,'last'); %The index of the node that the car has just passed.
node_pos = [edge(car_plot(i).edge(j)).node_matrix(1,index) edge(car_plot(i).edge(j)).node_matrix(2,index)];%X and Y coordinates for that node.
norm_vec = [edge(car_plot(i).edge(j)).node_matrix(1,index+1) edge(car_plot(i).edge(j)).node_matrix(2,index+1)] - node_pos;
norm_vec = norm_vec/(norm(norm_vec)); %norm_vec is the unit vector from the node the car just passed to the next node on th edge.
right_side_vec = cross([norm_vec 0],[0 0 1]);
dist2 = car_plot(i).dist(j) - edge(car_plot(i).edge(j)).node_matrix(3,index); %How far the car has passed the last node.
car_pos = node_pos + dist2*norm_vec + right_side_vec(1:2) - 2*norm_vec; %Combination of all the above calculated positions and vectors to get the X and Y coordinates of the car.
set(car_object(j),'position',[car_pos 4 4]); %The position of the car is plotted.