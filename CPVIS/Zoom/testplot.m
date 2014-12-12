% data_handling2;
%clear
%if exist('graph_data.mat')
%    delete('graph_data.mat');
%end
%create_graph_all;
%data_bus;
%bus;
plot_map;
plot_nodes5;

% Välj denna ...
zoomNodesandText(h_mapax,h_nodes);

% Eller denna ...
%zoomNodes(h_mapax,h_nodes);
% ... plus en av dessa ...
%map_annotation;
%map_legend;
