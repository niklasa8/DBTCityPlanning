function dist = latlon2meters(lat1,lat2,lon1,lon2)
%Returns distance in meters given two sets of coordinates.

R = 6378137;
dLat = (lat2-lat1)*pi/180;
dLon = (lon2-lon1)*pi/180;
a = sin(dLat/2)*sin(dLat/2)+cos(lat1*pi/180)*cos(lat2*pi/180)*sin(dLon/2)*sin(dLon/2);
[x Theta] = cart2pol(sqrt(a),sqrt(1-a));
dist = R * Theta;
end

