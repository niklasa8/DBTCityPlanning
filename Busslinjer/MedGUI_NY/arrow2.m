x = 0:10
y = 0:10
plot(x,y)
hold on
quiver(x(1:end-1),  y(1:end-1), ones(len(x)-1,1), y(2:end) - y(1:end-1))