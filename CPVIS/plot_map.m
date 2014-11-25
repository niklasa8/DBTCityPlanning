tic
[umeavatten,~] = shaperead('umeavatten1');
[umeafarm,~] = shaperead('umeafarm1');
[umearesidential,~] = shaperead('umearesidential1');

mapshow(umeafarm,'facecolor',[1 0.9 0.65],'edgecolor',[1 0.9 0.65]);
title('Umeå med omnejd')
xlabel('° E')
ylabel('° N')
daspect([1 0.44 1])
%axis([20.1129 20.4617 63.7845 63.8771])
axis([20.10 20.48 63.77 63.89])
hold on

mapshow(umearesidential,'facecolor',[0.95 0.85 0.95],'edgecolor',[0.95 0.85 0.95]);
mapshow(umeavatten,'facecolor',[0.5 0.75 1],'edgecolor',[0.5 0.75 1]);
toc

set(gca,'layer','top') % Axlarna visas över polygonerna.
set(gca,'color',[0.7 1 0.7]) % Grön bakgrund.
% Copyrightrelaterat:
h_p = plot(20.2,63.8,'.w','markersize',1);
h_l = legend(h_p,'© OpenStreetMaps bidragsgivare');
h_l = legend(h_l,'location','southeast');
h_l = legend(h_l,'boxoff');
set(h_l,'fontsize',8)