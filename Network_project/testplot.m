function  testplot( car_pos )
hold on
blue = [0.1 0 .4];
x=car_pos(1);
y=car_pos(2);
radius = .5; 
centerX1 = x-.8;
centerY1 = y-1.5;
centerX2 = x+.8;
centerY2 = y+1.5;
centerX3 = x-.8;
centerY3 = y+1.5;
centerX4 = x+.8;
centerY4 = y-1.5;
% en funktion för att skapa bilen och en för att uppdatera positionen,
% använd set
%linje1(i) = 
rectangle('Position',[centerX1 - radius, centerY1 - radius, radius*2, radius*2],...
    'Curvature',[1,1],...
    'FaceColor','k');
rectangle('Position',[centerX2 - radius, centerY2 - radius, radius*2, radius*2],...
    'Curvature',[1,1],...
    'FaceColor','k');
rectangle('Position',[centerX3 - radius, centerY3 - radius, radius*2, radius*2],...
    'Curvature',[1,1],...
    'FaceColor','k');
rectangle('Position',[centerX4 - radius, centerY4 - radius, radius*2, radius*2],...
    'Curvature',[1,1],...
    'FaceColor','k');
rectangle('Position', [x-1 y-2 2 4],'Curvature',[0.8,0.4], 'FaceColor','b');
rectangle('Position', [x-0.7 y+1 1.4 0.5],'Curvature',[0.8,0.4], 'FaceColor',blue);
rectangle('Position', [x-.15 y-1.5 .3 2], 'FaceColor','k');
rectangle('Position', [x-.65 y-1.5 .3 2], 'FaceColor','k');
rectangle('Position', [x+.35  y-1.5 .3 2], 'FaceColor','k');
axis square

end
