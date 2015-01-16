function times = allToOne(Dep, idxA, d, t, n)
times = inf*ones(n,1,'int32');
times(idxA)=0;
T = zeros(n,1,'int32');
T(idxA) = t;
queue = [];

nei = findNeighbours(Dep, idxA, t, d);
t = findTravelTime(0, T(idxA), Dep, nei, idxA, d);
for i = 1:max(size(nei))
    times(nei(i)) = t(i);
    T(nei(i)) = T(idxA) - t(i);
    queue = [queue nei(i)];
end

while ~isempty(queue)
    idx = queue(1);
    queue = queue(2:end);
    
    nei = findNeighbours(Dep, idx, T(idx), d);
    t = findTravelTime(times(idx), T(idx), Dep, nei, idx, d);
    for i = 1:max(size(nei))
        if t(i) < times(nei(i))
            times(nei(i)) = t(i);
            T(nei(i)) = T(idxA) - t(i);
            if ~any(queue==nei(i))
                queue = [queue nei(i)];
            end
        end
    end
end

end
