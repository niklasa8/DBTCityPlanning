umevatten = shaperead('umevatten');
umenatur1 = shaperead('umenatur1');
umenatur2 = shaperead('umenatur2');
umenatur3 = shaperead('umenatur3');
umeakermark = shaperead('umeakermark');
umefstght = shaperead('umefstght');

tic
mapshow(umenatur1,'facecolor',[0.6 1 0.6],'edgecolor',[0.6 1 0.6]);
title('Umeå med omnejd')
xlabel('° E')
ylabel('° N')
axis equal
axis([20.1129 20.4617 63.7845 63.8771])
hold on

mapshow(umenatur2,'facecolor',[0.6 1 0.6],'edgecolor',[0.6 1 0.6]);
mapshow(umenatur3,'facecolor',[0.6 1 0.6],'edgecolor',[0.6 1 0.6]);
mapshow(umevatten,'facecolor',[0.5 0.75 1],'edgecolor',[0.5 0.75 1]);
mapshow(umeakermark,'facecolor',[1 0.85 0.55],'edgecolor',[1 0.85 0.55]);
mapshow(umefstght,'facecolor',[0.9 0.8 0.9],'edgecolor',[0.9 0.8 0.9]);
toc

h_p = plot(20.2,63.8,'.w');
h_l = legend(h_p,'© OpenStreetMaps bidragsgivare');
h_l = legend(h_l,'location','southeast');
h_l = legend(h_l,'boxoff');
set(h_l,'fontsize',8)