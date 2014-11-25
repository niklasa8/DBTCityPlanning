function dist = latlon2meters(lat1,lat2,lon1,lon2)
%Returns distance in meters given two sets of coordinates.
R = 6378137;
C = 2*pi*R/360;
k = cos(pi/180*(lat1+lat2)/2);
dist = norm([lat1-lat2 k*(lon1-lon2)])*C;
% Haversine formula:
% dLat = (lat2-lat1)*pi/180;
% dLon = (lon2-lon1)*pi/180;
% a = sin(dLat/2)*sin(dLat/2)+cos(lat1*pi/180)*cos(lat2*pi/180)*sin(dLon/2)*sin(dLon/2);
% Theta = 2*asin(sqrt(a));
% dist = R * Theta;
end