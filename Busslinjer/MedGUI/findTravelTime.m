function t = findTravelTime(tx, T, Dep, nei, idx, d)
t = [];
for i = 1:max(size(nei))
    t = [t tx + (T-Dep{nei(i),idx}(d,T))];
end
end

