function F = break_force(car_dist,same_vel_dist,vel1,vel2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Fmax = -15;
rel_vel = vel1 - vel2;
rel_vel0_dist = same_vel_dist - car_dist;
if rel_vel0_dist < 0.01
    rel_vel0_dist = 0.01;
end


F = -rel_vel^2/(2*rel_vel0_dist);

if F < Fmax
    F = Fmax;
end

end

