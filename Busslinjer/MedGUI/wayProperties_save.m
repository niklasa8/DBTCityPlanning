function wayProperties_save(handles)
load('data_umea.mat','node','park_nodes')

node = handles.data_umea.node;


handles = guidata(handles.figure1);

add_way_pos = 1;
add_node_pos = 1;

%alla config.<...> är uppbyggda på så sätt att man appendar dem hela tiden.
%{[coord1a,coord2a],<change>,[coord1b,coord2b],<change>}

config.delete_edge = {};
config.speed_limit_edge = {};
added_node_dict = containers.Map;
save_config = false;
save_add_node = false;
save_add_way = false;
save_parking_attribute = false;

%loopen nedan fixar delete_edge och change_edge
if isfield(handles,'delete_edge')
    save_config = true;
    for i=1:length(handles.delete_edge);
        current_delete_edge = handles.delete_edge{i};

        if length(current_delete_edge) == 3
            delete_edge_id = current_delete_edge{1};
            current_delete = current_delete_edge{3};
            len_current_delete = length(current_delete);

            config.delete_edge = [config.delete_edge [current_delete{1};current_delete{len_current_delete}]];

            len_change_edge = length(handles.change_edge);
            for j=1:len_change_edge
                current_change_edge = handles.change_edge{j};
                change_edge_id = str2double(current_change_edge{1});

                if change_edge_id == delete_edge_id
                    len_ndref = length(current_change_edge{7});
                    config.speed_limit_edge = [config.speed_limit_edge,[num2str(current_change_edge{7}{1}),num2str(current_change_edge{7}{len_ndref})],num2str(current_change_edge{3})];
                    break
                end
            end

        elseif length(current_delete_edge) == 4
            delete_edge_id = current_delete_edge{1};
            current_delete = current_delete_edge{3};
            len_current_delete = length(current_delete);

            config.delete_edge = [config.delete_edge [current_delete{1};current_delete{len_current_delete}]];

            len_change_edge = length(handles.change_edge);
            for j=1:len_change_edge
                first_change_edge = handles.change_edge{j};
                change_edge_id = str2double(first_change_edge{1});

                if change_edge_id == delete_edge_id
                    len_ndref = length(first_change_edge{7});

                    config.speed_limit_edge = [config.speed_limit_edge,[num2str(first_change_edge{7}{1}),num2str(first_change_edge{7}{len_ndref})],num2str(first_change_edge{3})];

                    second_change_edge = handles.change_edge{j+1};
                    change_edge_id = str2double(second_change_edge{1});
                    len_ndref = length(second_change_edge{7});

                    config.speed_limit_edge = [config.speed_limit_edge,[num2str(second_change_edge{7}{1}),num2str(second_change_edge{7}{len_ndref})],num2str(second_change_edge{3})];
                    break
                end
            end
        end
    end
end

%change_way
            % 1     2       3          4      5        6      
%change_way={ID,highway, maxspeed, bicycle, oneway, cycleway}
if isfield(handles,'change_way')
    for i=1:length(handles.change_way)
        ndref_start = handles.change_way{i}{7}{1};
        ndref_stop = handles.change_way{i}{7}{length(handles.change_way{i}{7})};
        
        config.speed_limit_edge = [config.speed_limit_edge,[ndref_start,ndref_stop],num2str(handles.change_way{i}{3})];
        %config.x = [config.x,[ndref_start,ndref_stop],handles.change_way{i}{y}];
    end
end

%add_way & add_node
if isfield(handles,'add_way')
    save_add_way = true;
    for i=1:length(handles.add_way)
        
        current_add_way = handles.add_way(i);
        
        for j=1:length(current_add_way.ndref)
            ndref = current_add_way.ndref{j};
            if isfield(handles,'add_node')
                save_add_node = true;
                for k=1:length(handles.add_node)
                    if strcmp(class(ndref),'double')
                        if ndref == handles.add_node(k).id & not(isKey(added_node_dict,num2str(ndref)))
                            current_add_way.ndref{j} = add_node_pos+1000;
                            add_node(add_node_pos).id = num2str(add_node_pos+1000);
                            add_node(add_node_pos).lat = handles.add_node(k).lat;
                            add_node(add_node_pos).lon = handles.add_node(k).lon;

                            add_node(add_node_pos).waynd = 0;
                            add_node(add_node_pos).traffic_signals = 0;
                            add_node(add_node_pos).traffic_calming = 0;
                            add_node(add_node_pos).name = 0;
%                             add_node(add_node_pos).parking = 0;
                            if length(handles.add_node(k).parking) > 1
                                parking_nodes = [parking_nodes, lenght(node)+add_node_pos]
                            end
                            add_node(add_node_pos).intnd = 0;
                            add_node(add_node_pos).bus_stop = 0;
                            
                            added_node_dict(num2str(ndref)) = add_node_pos+1000;
                                                        
                            add_node_pos = add_node_pos + 1;
                        elseif isKey(added_node_dict,num2str(ndref))
                            current_add_way.ndref{j} = added_node_dict(num2str(ndref));
                        end
                    end
                end
            end
        end

        add_way(add_way_pos).id = num2str(add_way_pos+1000);
        add_way(add_way_pos).highway = current_add_way.highway;
        add_way(add_way_pos).maxspeed = current_add_way.maxspeed;
        add_way(add_way_pos).bicycle = current_add_way.bicycle;
        add_way(add_way_pos).oneway = current_add_way.oneway;
        add_way(add_way_pos).cycleway = current_add_way.cycleway;
        add_way(add_way_pos).ndref = current_add_way.ndref;

        add_way_pos = add_way_pos + 1;
    end
end

%parking attribute on existing intnd node
if isfield(handles,'add_parking_attribute')
    save_parking_attribute = true;
    for i=1:length(handles.add_parking_attribute)
        current_entry = handles.add_parking_attribute{i};
        if length(current_entry) == 4 % length(pos,maxcap,price,current) = 4 <add attribute>
            intnd_id = current_entry(1);
            osm_id = handles.graph_data.intnd(intnd_id).id;
            node_id = handles.graph_data.id_map(osm_id);

            node(node_id).parking = [current_entry(2) current_entry(3) current_entry(4)];
            park_nodes = [park_nodes, node_id];
        else %length(pos,[]) = 1 <remove attribute>
            intnd_id = current_entry(1);
            osm_id = handles.graph_data.intnd(intnd_id).id;
            node_id = handles.graph_data.id_map(osm_id);

            node(node_id).parking = [];
            del_pos = find(park_nodes == node_id);
            park_nodes(del_pos) = [];
        end
    end

if not(save_config)
    config = 0;
elseif not(save_add_node)
    add_node = 0;
elseif not(save_add_way)
    add_way = 0;
elseif not(save_parking_attribute)
    save_parking_attribute = 0;
end
config_graph = 1;

save('data_umea.mat','config','add_node','add_way','config_graph','node','park_nodes','-append')
disp('Saved!')
end





