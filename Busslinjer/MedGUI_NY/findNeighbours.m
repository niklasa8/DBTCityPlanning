function neighbours = findNeighbours(dep, x, t, d)
neighbours = [];
for i = 1:max(size(dep))
    if ~isempty(dep{i,x})
        if dep{i,x}(d,t)~=0
            neighbours = [neighbours i];
        end
    end
end
end