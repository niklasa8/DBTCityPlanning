load('graph_data.mat','intnd')
close all
grey=[0.5, 0.5, 0.5];
figure('units','normalized','outerposition',[0 0 1 1])
set(gca,'Color',[1 1 1]);
intnd_count = max(size(intnd));
hold on

% for i = 1:n_intnd %Plottar itersection nodes.
%     lat = intnd(i).lat;
%     lon = intnd(i).lon;
%     plot(lon,lat,'o','MarkerEdgeColor',grey,'MarkerFaceColor',grey,...
%       'MarkerSize',3);
% end

max_usage = 0.7*max([edge.n_usage]);
jet_ = hot;
max_jet = max(size(jet_)) - 10;

for i = 1:intnd_count %Plottar vägarna mellan noderna, notera att ALLA noder används (även de som inte är intersection nodes) för att rita ut vägarna.
    for j = 1:intnd_count
        if edge_index(i,j) ~= 0
            n = edge_index(i,j);
            m = edge_index(j,i);
            usage = edge(n).n_usage + edge(m).n_usage;
            X = edge(n).node_matrix(1,:);
            Y = edge(n).node_matrix(2,:);
%             for j = 1:n_ndref
%                 X(j) = node(id_map(way(i).ndref{j})).lon;
%                 Y(j) = node(id_map(way(i).ndref{j})).lat;
%             end
            if usage > max_usage
                usage = max_usage;
            end
            
            rgb_color = jet_(int32((max_jet - 1)/max_usage*usage) + 1,:);
            line('Ydata',Y,'Xdata',X,'color',rgb_color,'LineWidth',4);
            %pause
        end
    end
end