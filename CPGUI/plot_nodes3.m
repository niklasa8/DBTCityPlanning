function plot_nodes3(fastest_trip, handles)

load('graph_data.mat','bicycling_path','carTo_walkFrom_parking')

node_source = handles.current_node;

% Sparar undan antal v�gar
[~,n_ways] = size(handles.data_umea.way);

% Antal intersection nodes
n = handles.graph_data.intnd_count;
for i = 1:n %Plottar itersection nodes och f�rgl�gger dem enligt snabbaste f�rds�ttet.
    
    % OBS! Noderna skapas f�re v�garna och kommer d�rf�r att ligga efter i
    % children listan. Sen kommer nod nummer ett att ligga sist av alla
    % noder i listan s� d�rav indexen nedan.
    
    if carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) ~= inf
        if bicycling_path(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) < carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) + 3/60 && bicycling_path(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) < fastest_trip(i)
            % �ndrar f�rg p� noden
            set(handles.ch(n_ways + n - i + 1),'color','r');
        end
    end
    if carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) + 3/60 < bicycling_path(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) && carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) + 3/60 < fastest_trip(i)
        % �ndrar f�rg p� noden
        set(handles.ch(n_ways + n - i + 1),'color','b');
    end
    if carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) ~= inf
        if fastest_trip(i) < bicycling_path(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) && fastest_trip(i) < carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) + 3/60
             % �ndrar f�rg p� noden
             set(handles.ch(n_ways + n - i + 1),'color','g');
             %plot(lon,lat, 'g.')
        end
    end
end

end
