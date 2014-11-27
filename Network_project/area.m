function area_type = area(lon,lat)
%Takes coordinates and returns what area type it is, i.e residential, inner
%city or other.

ic_xmax = 20.2842;
ic_xmin = 20.2309;
ic_ymax = 63.8345;
ic_ymin = 63.8224;

uni_xmax = 20.3151;
uni_xmin = 20.2916;
uni_ymax = 63.8227;
uni_ymin = 63.8133;


if lon > ic_xmin && lon <= ic_xmax && lat > ic_ymin && lat <= ic_ymax
    area_type = 'innercity';
elseif lon > uni_xmin && lon <= uni_xmax && lat > uni_ymin && lat <= uni_ymax
    area_type = 'university';
else
    area_type = 'residential';
end

end

