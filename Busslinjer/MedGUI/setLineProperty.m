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


function setLineProperty(hObject,handles)
graph_data = handles.graph_data;
data_umea = handles.data_umea;

hax = handles.axes1;

hcmenu = uicontextmenu('Parent',handles.figure1);
hcmenu2 = uicontextmenu('Parent',handles.figure1);
hcmenu3 = uicontextmenu('Parent',handles.figure1);
item1 = uimenu(hcmenu,'Label','Select way','Callback',@hcb1);
item2 = uimenu(hcmenu,'Label','Way properties','Callback',@hcb2);

item11 = uimenu(hcmenu2,'Label','Select way','Callback',@hcb11);
item22 = uimenu(hcmenu2,'Label','Way properties','Callback',@hcb22);

item111 = uimenu(hcmenu3,'Label','Undo deletion','Callback',@hcb111);

    function hcb1(src,evt)
        a = get(gco,'XData'); %hämtar Xdata
        b = get(gco,'YData'); %hämtar Ydata
        c = [a' b']; %Ställer upp dem mot varandra på 2xN format
        selectedWay = findWay(graph_data, data_umea, c,'defualt'); %Skickar in dem i findWay 
        handles = guidata(hObject);
        handles.current_way = selectedWay; %Sparar undan vilken som är current selected way
        guidata(hObject,handles)
        %raderna nedan håller ordning på färgning av linjerna
        %(selected way är fetare och röd)
        hline = findobj(gca,'Type','line', '-and','Color', 'red'); %sätter alla (1) selected till not selected
        for i=1:length(hline);
            props = get(hline(i),'LineWidth');
            if props == 1.5
                set(hline(i), 'Color', [0 0 0], 'LineWidth', 0.5);
            elseif props == 1.4
                set(hline(i), 'Color', [0.9100 0.4100 0.1700], 'LineWidth', 0.9);
            elseif props == 1.3
                set(hline(i), 'Color', [0.9100 0.4100 0.1700], 'LineWidth', 1.3);
            end
        end
        
        if get(gco,'Color') == [0.9100 0.4100 0.1700] %sätter current selected
            set(gco,'Color', 'red', 'LineWidth', 1.4); %om den är orange får den 1.4
        else
            set(gco,'Color', 'red', 'LineWidth', 1.5); %annars 1.5
        end
        guidata(hObject, handles);
    end

    function hcb2(src,evt)
        if not(get(gco,'LineWidth') == 1.5) %om den inte tidigare var selected, så kör vi den först
            hcb1()
        end

        if get(gco,'LineWidth') == 1.4 %1.4 om den är tidigare redigerad
            mapProperties(handles.figure1,'properties');
        else
            mapProperties(handles.figure1,false); %annars är den 1.5 och den är ej redigerad tidigare
        end
    end

    function hcb11(src,evt)
        a = get(gco,'XData'); %hämtar Xdata
        b = get(gco,'YData'); %hämtar Ydata
        c = [a' b']; %Ställer upp dem mot varandra på 2xN format
        handles = guidata(hObject);
        %nodesWay hinnehåller här alla nodes som den redigerade vägen
        %man klickat på innehåller {1,2,3,4}
        nodesWay = findWay(graph_data, data_umea, c,'edited');
        
        if isfield(handles,'delete_edge')
            len_delete_edge = length(handles.delete_edge);
            len_selected_way = length(nodesWay);

            for i=1:len_delete_edge
                current_ways = handles.delete_edge{i};
                current_way_ancestor = current_ways{1};
                current_way = 0;
                len_way1 = length(current_ways{2});
                if length(current_ways) == 4
                    len_way2 = length(current_ways{4});
                else
                    len_way2 = 0
                end
                
                if len_selected_way == len_way1
                    if isequal(nodesWay,current_ways{2})
                        current_way = current_ways{2}
                        disp('##########')
                        break
                    end
                elseif len_selected_way == len_way2
                    if isequal(nodesWay,current_ways{4})
                        current_way = current_ways{4}
                        disp('##########')
                        break
                    end
                end
            end
            handles = guidata(hObject);
            handles.current_way = {current_way_ancestor, current_way};
            guidata(hObject, handles);
            
            hline = findobj(gca,'Type','line', '-and','Color', 'red'); %sätter alla (1) selected till not selected
            for i=1:length(hline);
                props = get(hline(i),'LineWidth');
                if props == 1.5
                    set(hline(i), 'Color', [0 0 0], 'LineWidth', 0.5);
                elseif props == 1.4
                    set(hline(i), 'Color', [0.9100 0.4100 0.1700], 'LineWidth', 0.9);
                elseif props == 1.3
                    set(hline(i), 'Color', [0.9100 0.4100 0.1700], 'LineWidth', 1.3);
                end 
            end
            if get(gco,'Color') == [0.9100 0.4100 0.1700] & get(gco,'LineWidth') == 1.3
                set(gco,'Color', 'red');
            end
        else
            disp('Error setLineProperty HCB11')
        end

    end

    function hcb22(src,evt)
        if get(gco,'Color') == 'red' & get(gco,'LineWidth') == 1.3 %röd om den redan är selected
            mapProperties(handles.figure1,'structure');
        else %annars så selectar vi först
            hcb11()
            mapProperties(handles.figure1,'structure');
        end
    end

    function hcb111(src,evt)
        a = get(gco,'XData'); %hämtar Xdata
        b = get(gco,'YData'); %hämtar Ydata
        c = [a' b']; %Ställer upp dem mot varandra på 2xN format
        handles = guidata(hObject);
        %nodesWay hinnehåller här alla nodes som den redigerade vägen
        %man klickat på innehåller {1,2,3,4}
        nodesWay = findWay(graph_data, data_umea, c,'edited');
        
        if isfield(handles,'delete_edge')
            len_delete_edge = length(handles.delete_edge);
            len_selected_way = length(nodesWay);

            for i=1:len_delete_edge
                current_ways = handles.delete_edge{i};
                len_deleted_way = length(current_ways{3});
                
                if len_selected_way == len_deleted_way
                    if isequal(nodesWay,current_ways{3})
                        ancestor = current_ways{1};
                        if ischar(ancestor)
                            ancestor = str2double(ancestor)
                        end
                        way1 = current_ways{2};
                        deleted_way = current_ways{3};
                        if length(current_ways) > 3
                            way2 = current_ways{4};
                        %else
                           % way2 = 0;
                        end
                        i_delete = i;
                        break
                    end
                end
            end
           
            if length(way1) > 0
                way1_lon = [];
                way1_lat = [];
                for i=way1
                    i = i{1};
                    id_mapped = graph_data.id_map(num2str(i));
                    node = data_umea.node(id_mapped);
                    way1_lon = [way1_lon node.lon];
                    way1_lat = [way1_lat node.lat];
                end
            end
            
            if exist('way2')
                way2_lon = [];
                way2_lat = [];
                for i=way2
                    i = i{1};
                    id_mapped = graph_data.id_map(num2str(i));
                    node = data_umea.node(id_mapped);
                    way2_lon = [way2_lon node.lon];
                    way2_lat = [way2_lat node.lat];
                end
            end
            
            if length(way1) > 0
                if exist('way2')
                    ancestor_nodes = [way1 deleted_way(2:len_deleted_way-1) way2];
                else
                    ancestor_nodes = [way1 deleted_way(2:len_deleted_way)];  
                end
            else
                ancestor_nodes = deleted_way;
            end
            
            ancestor_lon = [];
            ancestor_lat = [];
            for i = ancestor_nodes
                i = i{1};
                id_mapped = graph_data.id_map(num2str(i));
                node = data_umea.node(id_mapped);
                ancestor_lon = [ancestor_lon node.lon];
                ancestor_lat = [ancestor_lat node.lat];  
            end
            
            if length(way1) > 0
                hline = findobj(gca,'XData', way1_lon, '-and','YData', way1_lat); %sätter alla (1) selected till not selected
                for i=1:length(hline);
                    props = get(hline(i),'Visible');
                    if strcmp(props,'on')
%                         set(hline(i), 'Visible','off');
                        delete(hline(i))
                    end
                end
            end
            
            if exist('way2')
                hline = findobj(gca,'XData', way2_lon, '-and','YData', way2_lat); %sätter alla (1) selected till not selected
                for i=1:length(hline);
                    props = get(hline(i),'Visible');
                    if strcmp(props,'on')
%                         set(hline(i), 'Visible','off');
                        delete(hline(i))
                    end
                end
            end
            
%             set(gco, 'Visible','off')
            delete(gco)
            
            hline = findobj(gca,'XData', ancestor_lon, '-and','YData', ancestor_lat); %sätter alla (1) selected till not selected
            %ibland hittar han inget.. har något med i vilken ordning way1
            %och deleted hamnar i. Enda gången detta förkommer är om man
            %sätter (delete) node 1 längst ut på en väg, men endast i en
            %viss ände. Har förmodligen något att göra med tilldelningen
            %till ancestor_nodes <se ovan>, att den kapar deleted på något
            %sätt som inte är passande. Löser detta "enkelt" men "fult/långsamt"
            %genom att bara göra en loop i hela way-strukturen och hämta
            %koordinaterna därifrån
            if length(hline) == 0
                for i=1:length(data_umea.way)
                    if str2double(data_umea.way(i).id) == ancestor
                        ancestor_lon = [];
                        ancestor_lat = [];
                        for i = data_umea.way(i).ndref
                            i = i{1};
                            id_mapped = graph_data.id_map(num2str(i));
                            node = data_umea.node(id_mapped);
                            ancestor_lon = [ancestor_lon node.lon];
                            ancestor_lat = [ancestor_lat node.lat];  
                        end
                        hline = findobj(gca,'XData', ancestor_lon, '-and','YData', ancestor_lat);
                        break
                    end
                end
            end        
            
            for i=1:length(hline);
                props = get(hline(i),'Visible');
                if strcmp(props,'off')
                    set(hline(i), 'Visible','on', 'LineWidth', 0.5, 'Color', [0 0 0]);
                end
            end
            handles = guidata(hObject);
            handles.delete_edge(i_delete) = [];
            
            if isfield(handles,'change_edge')
                change_edge_list = handles.change_edge;
                len_way_list = length(change_edge_list);
                edge_changes_delete = [];
                for i=1:len_way_list
                    change_edge_list{i}{1};
                    if str2double(change_edge_list{i}{1}) == ancestor
                        edge_changes_delete = [edge_changes_delete i];
                    end
                end
                edge_changes_delete = fliplr(edge_changes_delete);
                for i=edge_changes_delete
                    handles.change_edge(i) = [];
                end
            end
            guidata(hObject, handles);
            
            hlines = findall(hax,'Type','line', '-and','LineWidth', 0.5, '-and');
            for line_in_graph = 1:length(hlines)
                set(hlines(line_in_graph),'uicontextmenu',hcmenu)
            end
  
        else
            disp('Error setLineProperty HCB111')
        end

    end

%Sätter property på alla "vanliga" linjer (width 0.5)
hlines = findall(hax,'Type','line', '-and','LineWidth', 0.5, '-and');
for line_in_graph = 1:length(hlines)
    set(hlines(line_in_graph),'uicontextmenu',hcmenu)
end
%Sätter property på samtliga vägar där strukturen förändrats (width 1.3, färg orange)
hlines = findall(hax,'Type','line', '-and','LineWidth', 1.3, '-and', 'Color', [0.9100 0.4100 0.1700]);
for line_in_graph = 1:length(hlines)
    set(hlines(line_in_graph),'uicontextmenu',hcmenu2)
end
%Sätter property på deleted roads
hlines = findall(hax,'Type','line', '-and','LineWidth', 1.3, '-and', 'LineStyle', '- -');
for line_in_graph = 1:length(hlines)
    set(hlines(line_in_graph),'uicontextmenu',hcmenu3)
end

end
