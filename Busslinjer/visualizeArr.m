ArrSpy = zeros(175,175);
for i=1:175
    for j=1:175
        ArrSpy(i,j) = ~isempty(Arr{i,j});
    end
end
spy(ArrSpy)