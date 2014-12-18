tic
[umeafarm,~] = shaperead('umeafarm');
[umearesidential,~] = shaperead('umearesidential');
[umeawater,~] = shaperead('umeawater');

mapshow(umeafarm,'FaceColor',[1 0.9 0.65],'EdgeColor','none');
title('Umeå')
xlabel('° E')
ylabel('° N')
daspect([1 0.44 1])
%axis([20.1129 20.4617 63.7845 63.8771])
axis([20.10 20.48 63.77 63.89])
hold on

mapshow(umearesidential,'FaceColor',[0.95 0.85 0.95],'EdgeColor','none');
mapshow(umeawater,'FaceColor',[0.65 0.85 1],'EdgeColor',[0.5 0.75 1]);
toc

set(gca,'Layer','top') % Axlarna visas över polygonerna.
set(gca,'Color',[0.7 1 0.7]) % Grön bakgrund.

h_mapax = gca;