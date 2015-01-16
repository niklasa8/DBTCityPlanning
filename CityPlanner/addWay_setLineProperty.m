%line widths:
%1.5 = current selected (red)
%1.4 = current selected, way properties changed (red)
%1.3 = way structure changed (red if selected)
%0.9 = way properties changed (orange)
%0.5 = normal (black)

%handles:
%delete_edge={ID_ancestor, way1, deleted, opt way2}
%change_edge={ID_ancestor, highway, maxspeed, bicycle, oneway,
%             parking, cycleway, footway, ndref)
%change_way={ID,highway, maxspeed, bicycle, oneway, parking, cycleway,
%            footway}
%add_way = {id, highway, maxspeed, bicycle, oneway, parking, cycleway, footway, ndref}
%add_node =
%{.waynd,.traffic_signals,.traffic_calming,.name,.parking,.intnd,.bus_step,.id,.lat,.lon}


function addWay_setLineProperty(handles)

hax = handles.main.axes1;

hcmenuAddWay = uicontextmenu('Parent',handles.main.figure1);
item1 = uimenu(hcmenuAddWay,'Label','Delete way','Callback',@hcb1);
% item2 = uimenu(hcmenu,'Label','Way properties','Callback',@hcb2);


    function hcb1(src,evt)
        a = get(gco,'XData'); %hämtar Xdata
        b = get(gco,'YData'); %hämtar Ydata
        c = [a' b']; %Ställer upp dem mot varandra på 2xN format
        add_way = handles.main.add_way;
        len_input = length(c);
        input_data = c;
        possible_ways = [];
        found_way_pos = 0;
        for i=1:length(add_way)
            if len_input == length(add_way(i).ndref)
                possible_ways = [possible_ways i]; %Sparar position i add_ways
            end
        end
        
        if length(possible_ways) >= 2
            for i=possible_ways
                current_way = add_way(i);
                
                %XData (lon)
                aa = [];
                %YData (lat)
                bb = [];
                
                for j=1:length(current_way.ndref)
                    current_ndref = current_way.ndref{j};
                    if ischar(current_ndref)
                        graph_data = handles.main.graph_data;
                        id_mapped = graph_data.intnd_map(graph_data.id_map(current_ndref));
                        aa = [aa handles.main.graph_data.intnd(id_mapped).lon];
                        bb = [bb handles.main.graph_data.intnd(id_mapped).lat];
                    else
                        aa = [aa handles.main.add_node(current_ndref-1000).lon];
                        bb = [bb handles.main.add_node(current_ndref-1000).lat];
                    end
                end
                
                cc = [aa' bb'];

                if isequal(c,cc)
                    found_way_pos = i;
                    break
                end
                        
            end
            
        elseif length(possible_ways) == 1
            found_way_pos = possible_ways(1);
        else
            msgbox('Error: Way not found (addWay_setLineproperty)')
        end
        
        if found_way_pos
            delete(gco)
            handles.main.add_way(found_way_pos) = [];
        end
        guidata(handles.main.figure1,handles.main)
    end

%Sätter property på alla user added ways (width 0.6)
hlines = findall(hax,'Type','line', '-and','LineWidth', 0.6);
for line_in_graph = 1:length(hlines)
    set(hlines(line_in_graph),'uicontextmenu',hcmenuAddWay)
end


end
