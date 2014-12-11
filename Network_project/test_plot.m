load('graph_data.mat')
load('data_umea.mat')
close all
grey=[0.5, 0.5, 0.5];
figure('units','normalized','outerposition',[0 0 1 1])
set(gca,'Color',[0.1 0.5 0]);
hold on

[x n_intnd] = size(intnd);
[x n_ways] = size(way);




for i = 1:n_ways %Plottar v�garna mellan noderna, notera att ALLA noder anv�nds (�ven de som inte �r intersection nodes) f�r att rita ut v�garna.
    [x n_ndref] = size(way(i).ndref);
    X = zeros(1,n_ndref);
    Y = zeros(1,n_ndref);
    for j = 1:n_ndref
        X(j) = node(id_map(way(i).ndref{j})).lon;
        Y(j) = node(id_map(way(i).ndref{j})).lat;
    end
    
    line('Ydata',Y,'Xdata',X, 'color',grey,'LineWidth',10);
    line('Ydata',Y,'Xdata',X, 'color','w');
   % line('Ydata',Y,'Xdata',X);
    
end

% for i = 1:n_intnd %Plottar itersection nodes.
%     lat = intnd(i).lat;
%     lon = intnd(i).lon;
% %     plot(lon,lat,'o','MarkerEdgeColor',grey,'MarkerFaceColor',grey,...
% %       'MarkerSize',7);
%     text(lon,lat,num2str(i));
% end
