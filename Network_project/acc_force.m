function F = acc_force(vel,vel_factor,vel_lim)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

F = 10*(vel_factor.*vel_lim - vel)./(vel_factor.*vel_lim);
end

