

%Input arguments: Handles, changes_pre (false/'structure'/'properties')

function varargout = mapProperties(varargin)
% mapProperties MATLAB code for mapProperties.fig
%      mapProperties, by itself, creates a new mapProperties or raises the existing
%      singleton*.
%
%      H = mapProperties returns the handle to a new mapProperties or the handle to
%      the existing singleton*.
%
%      mapProperties('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in mapProperties.M with the given input arguments.
%
%      mapProperties('Property','Value',...) creates a new mapProperties or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mapProperties_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mapProperties_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mapProperties

% Last Modified by GUIDE v2.5 26-Nov-2014 15:56:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mapProperties_OpeningFcn, ...
                   'gui_OutputFcn',  @mapProperties_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end


% --- Executes just before mapProperties is made visible.
function mapProperties_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mapProperties (see VARARGIN)


handles.input1 = varargin{1};%1st arg => handle from main.m
handles.changes_pre = varargin{2};%2nd arg => road previously modified? (false/'properties'/structure)

handles.main = guidata(handles.input1);

% Choose default command line output for mapProperties
handles.output = hObject;
guidata(hObject, handles);

%Laddar in sånt som behövs oavsett utfall
handles.graph_data = handles.main.graph_data;
handles.data_umea = handles.main.data_umea;

if not(length(handles.main.current_way) > 1);
    current_way = handles.main.current_way;
    way = handles.main.data_umea.way;
    handles.current_way_struct = way(current_way);%Denna kommer användas i andra fcn!
end
handles.deleteCoord1 = false;
handles.deleteCoord2 = false;

%<Om inga tidigare ändringar på vägen gjorts>
if not(handles.changes_pre)
    %Sätter info i wayProperties-rutan beroende på vägens data

    handles.structure_changed = false; %--::--
    handles.deleteCoord1 = false;
    handles.deleteCoord2 = false;

    %sätter checkboxar beroende på vägens data
    if way(current_way).highway
        set(handles.cb_car,'value',1)
    end

%     if way(current_way).parking
%         set(handles.cb_car,'value',1)
%         set(handles.parking_box,'visible','on')
%     end

    if way(current_way).bicycle
        set(handles.cb_bicycle,'value',1)
    else
        set(handles.cb_bicycle,'value',0)
    end

    if way(current_way).cycleway
        set(handles.cb_car,'value',0)
        set(handles.cb_bus,'value',0)
    end
    
    if way(current_way).oneway
        set(handles.cb_oneway,'value',1)
    else
        set(handles.cb_oneway,'value',0)
    end

%     if way(current_way).parking
%         set(handles.cb_parking,'value',1)
%         set(handles.parking_box,'visible','on')
%     else
%         set(handles.cb_parking,'value',0)
%         set(handles.parking_box,'visible','off')
%     end


    %edit_speedLimit
    maxspeed = way(current_way).maxspeed;
    set(handles.edit_speedLimit,'string',num2str(maxspeed))
%</Om inga tidigare ändringar på vägen gjorts>  

%<Om egenskaper på vägen ändrats> (ej struktur!!)
elseif strcmp(handles.changes_pre,'properties')
    current_way_struct = handles.current_way_struct;
    if isfield(handles.main,'change_way')
        change_way_list = handles.main.change_way;
        len_way_list = length(change_way_list);
        
        for i=1:len_way_list
            if str2double(change_way_list{i}{1}) == str2double(current_way_struct.id) %om IDt stämmer överens
                way_load_settings = change_way_list{i};
                handles.change_way_pos = i;
                break
            end
        end
        handles.way_load_settings = way_load_settings;
%change_way={ID,highway, maxspeed, bicycle, oneway, parking, cycleway,footway}   
            %1    2          3          4      5       6        7       8
%change_way={ID,highway, maxspeed, bicycle, oneway, cycleway}
            %1    2          3          4      5       6       
        if isfield(handles,'way_load_settings')
            if way_load_settings{2}
                set(handles.cb_car,'value',1)
            end

%             if way_load_settings{6}
%                 set(handles.cb_car,'value',1)
%                 set(handles.parking_box,'visible','on')
%             end

            if way_load_settings{4}
                set(handles.cb_bicycle,'value',1)
            else
                set(handles.cb_bicycle,'value',0)
            end
            
            if way_load_settings{5}
                set(handles.cb_oneway,'value',1)
            else
                set(handles.cb_oneway,'value',0)
            end

            if way_load_settings{6}
                set(handles.cb_car,'value',0)
                set(handles.cb_bus,'value',0)
            end

%             if way_load_settings{8}
%                 set(handles.cb_walking,'value',1)
%             else
%                 set(handles.cb_walking,'value',0)
%             end

%             if way_load_settings{6}
%                 set(handles.cb_parking,'value',1)
%                 set(handles.parking_box,'visible','on')
%             else
%                 set(handles.cb_parking,'value',0)
%                 set(handles.parking_box,'visible','off')
%             end

            %edit_speedLimit
            maxspeed = way_load_settings{3};
            set(handles.edit_speedLimit,'string',num2str(maxspeed))
        else
            disp('Error in mapProperties, way_load_settings')
        end
    else
        disp('Error in mapProperties, load change_way from handles')
    end
elseif strcmp(handles.changes_pre,'structure')
    current_way_id = handles.main.current_way{1};
    current_way_nodes = handles.main.current_way{2};
    if isfield(handles.main,'change_edge') & ~isempty(handles.main)
        change_edge_list = handles.main.change_edge;
        len_way_list = length(change_edge_list);
        
        for i=1:len_way_list
            if str2double(change_edge_list{i}{1}) == current_way_id %om IDt stämmer överens
                if isequal(change_edge_list{i}{7}, current_way_nodes) %om även deras ndref stämmer
                    way_load_settings = change_edge_list{i};
                    handles.change_way_pos = i;
                    break
                end
            end
        end
        handles.way_load_settings = way_load_settings;
%change_way={ID,highway, maxspeed, bicycle, oneway, parking, cycleway,footway}   
            % 1     2       3          4      5        6        7        8
%change_way={ID,highway, maxspeed, bicycle, oneway, cycleway}
        if isfield(handles,'way_load_settings')
            
            %första vi gör är att ta bort delete way boxen
            set(handles.structure_box,'visible','off')
            
            if way_load_settings{2}
                set(handles.cb_car,'value',1)
            end

%             if way_load_settings{6}
%                 set(handles.cb_car,'value',1)
%                 set(handles.parking_box,'visible','on')
%             end

            if way_load_settings{4}
                set(handles.cb_bicycle,'value',1)
            else
                set(handles.cb_bicycle,'value',0)
            end
            
            if way_load_settings{5}
                set(handles.cb_oneway,'value',1)
            else
                set(handles.cb_oneway,'value',0)
            end

            if way_load_settings{6}
                set(handles.cb_car,'value',0)
                set(handles.cb_bus,'value',0)
            end

%             if way_load_settings{8}
%                 set(handles.cb_walking,'value',1)
%             else
%                 set(handles.cb_walking,'value',0)
%             end

%             if way_load_settings{6}
%                 set(handles.cb_parking,'value',1)
%                 set(handles.parking_box,'visible','on')
%             else
%                 set(handles.cb_parking,'value',0)
%                 set(handles.parking_box,'visible','off')
%             end

            %edit_speedLimit
            maxspeed = way_load_settings{3};
            set(handles.edit_speedLimit,'string',num2str(maxspeed))
        else
            disp('Error in mapProperties, way_load_settings')
        end
    else
        disp('Error in mapProperties, load change_way from handles')
    end
end
%</Om egenskaper på vägen ändrats>

    
    


% UIWAIT makes mapProperties wait for user response (see UIRESUME)
% uiwait(handles.wayPropertiesWindow);


% Choose default command line output for mapProperties
handles.output = hObject;
guidata(hObject, handles);

end


% --- Outputs from this function are returned to the command line.
function varargout = mapProperties_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes on button press in cb_car.
function cb_car_Callback(hObject, eventdata, handles)
% hObject    handle to cb_car (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_car
end

% --- Executes on button press in cb_walking.
function cb_walking_Callback(hObject, eventdata, handles)
% hObject    handle to cb_walking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_walking
end

% --- Executes on button press in cb_bus.
function cb_bus_Callback(hObject, eventdata, handles)
% hObject    handle to cb_bus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_bus
end

% --- Executes on button press in cb_bicycle.
function cb_bicycle_Callback(hObject, eventdata, handles)
% hObject    handle to cb_bicycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_bicycle
end


function edit_parkingTime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_parkingTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_parkingTime as text
%        str2double(get(hObject,'String')) returns contents of edit_parkingTime as a double
end

% --- Executes during object creation, after setting all properties.
function edit_parkingTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_parkingTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit_speedLimit_Callback(hObject, eventdata, handles)
% hObject    handle to edit_speedLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_speedLimit as text
%        str2double(get(hObject,'String')) returns contents of edit_speedLimit as a double
end

% --- Executes during object creation, after setting all properties.
function edit_speedLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_speedLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
end


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in cb_parking.
function cb_parking_Callback(hObject, eventdata, handles)
% hObject    handle to cb_parking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_parking
if get(hObject,'Value') == 1
    set(handles.cb_parking,'value',1)
    set(handles.parking_box,'visible','on')
else
    set(handles.cb_parking,'value',0)
    set(handles.parking_box,'visible','off')
end

end

% --- Executes on button press in delete_node_1.
function delete_node_1_Callback(hObject, eventdata, handles)
% hObject    handle to delete_node_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')  
    set(handles.main.figure1,'WindowButtonMotionFcn', @cursor_coord);
    ispoint = isfield(handles,'point');
    if ispoint == 1;
        delete(handles.point)
    end
    handles.point = impoint(handles.main.axes1,[]);
    handles.coordinates = getPosition(handles.point);
    delete(handles.point);
    coords = mapProp_deleteWay(hObject, handles);
    handles.deleteCoord1 = coords;
    
    handles.pospoint = [handles.graph_data.intnd(coords).lon,handles.graph_data.intnd(coords).lat];
    ispoint = isfield(handles,'im3');
    if ispoint == 1;
        delete(handles.im3);
    end
    handles.im3 = impoint(handles.main.axes1,handles.pospoint);
    setColor(handles.im3,'g');
    guidata(hObject,handles);
end

end

% --- Executes on button press in delete_node_2.
function delete_node_2_Callback(hObject, eventdata, handles)
% hObject    handle to delete_node_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')  
    set(handles.main.figure1,'WindowButtonMotionFcn', @cursor_coord);
    ispoint = isfield(handles,'point');
    if ispoint == 1;
        delete(handles.point)
    end
    handles.point = impoint(handles.main.axes1,[]);
    handles.coordinates = getPosition(handles.point);
    delete(handles.point);
    coords = mapProp_deleteWay(hObject, handles);
    handles.deleteCoord2 = coords;
    
    handles.pospoint = [handles.graph_data.intnd(coords).lon,handles.graph_data.intnd(coords).lat];
    ispoint = isfield(handles,'im4');
    if ispoint == 1;
        delete(handles.im4);
    end
    handles.im4 = impoint(handles.main.axes1,handles.pospoint);
    setColor(handles.im4,'g');
    guidata(hObject,handles);
end
end

% --- Executes on button press in submit.
function submit_Callback(hObject, eventdata, handles)
% hObject    handle to submit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%importerar "nuvarande inställningar" för vägen
if not(handles.changes_pre)
    w = handles.current_way_struct;
    currentSettings = {w.id, w.highway, w.maxspeed, w.bicycle, w.oneway, w.cycleway, w.ndref};
elseif strcmp(handles.changes_pre, 'properties')
    w = handles.way_load_settings;
    currentSettings = {w{1}, w{2}, w{3}, w{4}, w{5}, w{6}, handles.current_way_struct.ndref}
elseif strcmp(handles.changes_pre, 'structure')
    w = handles.way_load_settings;
    currentSettings = {w{1}, w{2}, w{3}, w{4}, w{5}, w{6}, w{7}}
end

%change_way={ID,highway, maxspeed, bicycle, oneway, parking, cycleway,footway}   
            % 1     2       3          4      5        6        7        8
%change_way={ID,highway, maxspeed, bicycle, oneway, cycleway}

changes = false;
% <Start deleteWay>
if (handles.deleteCoord1 & handles.deleteCoord2) & ~(handles.deleteCoord1 == handles.deleteCoord2)
    changes = true;
    osm_1 = str2double(handles.graph_data.intnd(handles.deleteCoord1).id);
    osm_2 = str2double(handles.graph_data.intnd(handles.deleteCoord2).id);
    way_ndref = currentSettings{7};
    way1 = {};
    way2 = {};
    deleted = {};
    delete_toggle = false;
    way = 1;
    for i = 1:length(way_ndref)
        current_way_ndref = str2double(way_ndref{i});
        tester = [0,0];
        
        %de två första if-satserna nedan ersätter raden som följer:
%         if not((osm_1 == current_way_ndref) | (osm_2 == current_way_ndref)) & not(delete_toggle) & way == 1
        %Vet inte om det är mitt matlab som är cp, men den vill bara inte
        %funka, så fick komma på ett annat sätt att formulera sekvensen
        if osm_1 == current_way_ndref
            tester(1) = true;
        else
            tester(1) = false;
        end
        if osm_2 == current_way_ndref
            tester(2) = true;
        else
            tester(2) = false;
        end
        
        if not(tester(1) | tester(2)) & not(delete_toggle) & way == 1
            way1=[way1 {current_way_ndref}];
        elseif not(tester(1) | tester(2)) & not(delete_toggle) & way == 2
            way2=[way2 {current_way_ndref}];
        elseif osm_1 == current_way_ndref | osm_2 == current_way_ndref
            if not(delete_toggle)
                delete_toggle = true;
                deleted = [deleted {current_way_ndref}];
                way1=[way1 {current_way_ndref}];
                way = 2;
            else
                delete_toggle = false;
                deleted = [deleted {current_way_ndref}];
                way2=[way2 {current_way_ndref}];
            end
        elseif delete_toggle
            deleted = [deleted {current_way_ndref}];
        end
    end
    
%     osm_1
%     osm_2
%     way_ndref
%      way1
%     deleted
%      way2
    disp('###')
    
    if length(way1) < length(way2)
        if length(way1) == 1
            way1 = way2;
            way2 = [0];
        end
    end

    if length(way2) == 1 & length(way1) > 1%En nod läggs alltid till när delete_toggle switchar
        mainhandles = guidata(handles.main.figure1); %Läser in main handles

        if not(handles.changes_pre)
            ancest_id = str2double(handles.current_way_struct.id);
        else
            ancest_id = str2double(handles.way_load_settings{1});
        end
        
        if isfield(mainhandles,'delete_edge')
            pos = length(mainhandles.delete_edge)+1;
            mainhandles.delete_edge(pos) = {[ancest_id;{way1};{deleted}]};
        else
            %mainhandles.delete_edge(1) = {[w.id;{way1};{deleted}]};
            mainhandles.delete_edge(1) = {[ancest_id;{way1};{deleted}]};
        end
        guidata(handles.main.figure1,mainhandles) %Uppdaterar/sparar handles.main
        
        hline = findobj(handles.main.figure1,'Type','line', '-and','LineWidth', 1.5, '-or','LineWidth',1.4); %Fetchar "current selected line"
        
        set(hline,'Color', [0.9100 0.4100 0.1700], 'LineWidth', 1.4, 'Visible', 'off'); %sätter linjen som "redigerad" samt off
        
        len_way1 = length(way1);
        X = zeros(1,len_way1);
        Y = zeros(1,len_way1);
        
        for i=1:len_way1
            node_id_osm = num2str(way1{i});
            id_mapped = handles.graph_data.id_map(node_id_osm);
            X(i) = handles.data_umea.node(id_mapped).lon;
            Y(i) = handles.data_umea.node(id_mapped).lat;
        end
        line('Ydata',Y,'Xdata',X,'Color', [0.9100 0.4100 0.1700], 'LineWidth', 1.3, 'Parent', handles.main.axes1);
        
        len_delete = length(deleted);
        X = zeros(1,len_delete);
        Y = zeros(1,len_delete);
        for i=1:len_delete
            node_id_osm = num2str(deleted{i});
            id_mapped = handles.graph_data.id_map(node_id_osm);
            X(i) = handles.data_umea.node(id_mapped).lon;
            Y(i) = handles.data_umea.node(id_mapped).lat;
        end
        line('Ydata',Y,'Xdata',X,'LineStyle', '- -', 'LineWidth', 1.3, 'Parent', handles.main.axes1);
        
        %Fixar sparningen så den tar hänsyn till om man ändrat egenskaper
        %på vägen
        handles.changes_pre = 'structure';
        currentSettings{7} = way1;
        if isfield(handles.main,'change_edge')
            handles.change_way_pos = length(handles.main.change_edge)+1;
        else
            handles.change_way_pos = 1;
        end
        disp('###')
    elseif length(way1) > 1 
        mainhandles = guidata(handles.main.figure1); %Läser in main handles
        
        if not(handles.changes_pre)
            ancest_id = str2double(handles.current_way_struct.id);
        else
            ancest_id = str2double(handles.way_load_settings{1});
        end
        
        if isfield(mainhandles,'delete_edge')
            pos = length(mainhandles.delete_edge)+1;
            mainhandles.delete_edge(pos) = {[ancest_id;{way1};{deleted};{way2}]};
        else
            %mainhandles.delete_edge(1) = {[w.id;{way1};{deleted}]};
            mainhandles.delete_edge(1) = {[ancest_id;{way1};{deleted};{way2}]};
        end
        guidata(handles.main.figure1,mainhandles) %Uppdaterar/sparar handles.main
        
        hline = findobj(handles.main.figure1,'Type','line', '-and','LineWidth', 1.5, '-or','LineWidth',1.4); %Fetchar "current selected line"
        
        set(hline,'Color', [0.9100 0.4100 0.1700], 'LineWidth', 1.4, 'Visible', 'off'); %sätter linjen som "redigerad" samt off
        
        len_way1 = length(way1);
        X = zeros(1,len_way1);
        Y = zeros(1,len_way1);
        for i=1:len_way1
            node_id_osm = num2str(way1{i});
            id_mapped = handles.graph_data.id_map(node_id_osm);
            X(i) = handles.data_umea.node(id_mapped).lon;
            Y(i) = handles.data_umea.node(id_mapped).lat;
        end
        line('Ydata',Y,'Xdata',X,'Color', [0.9100 0.4100 0.1700], 'LineWidth', 1.3, 'Parent', handles.main.axes1);
        
        len_delete = length(deleted);
        X = zeros(1,len_delete);
        Y = zeros(1,len_delete);
        for i=1:len_delete
            node_id_osm = num2str(deleted{i});
            id_mapped = handles.graph_data.id_map(node_id_osm);
            X(i) = handles.data_umea.node(id_mapped).lon;
            Y(i) = handles.data_umea.node(id_mapped).lat;
        end
        line('Ydata',Y,'Xdata',X,'LineStyle', '- -', 'LineWidth', 1.3, 'Parent', handles.main.axes1);
        
        len_way2 = length(way2);
        X = zeros(1,len_way2);
        Y = zeros(1,len_way2);
        for i=1:len_way2
            node_id_osm = num2str(way2{i});
            id_mapped = handles.graph_data.id_map(node_id_osm);
            X(i) = handles.data_umea.node(id_mapped).lon;
            Y(i) = handles.data_umea.node(id_mapped).lat;
        end
        line('Ydata',Y,'Xdata',X,'Color', [0.9100 0.4100 0.1700], 'LineWidth', 1.3, 'Parent', handles.main.axes1);
        
        %Fixar sparningen så den tar hänsyn till om man ändrat egenskaper
        %på vägen
        handles.changes_pre = 'newStructure';
        currentSettings{7} = {way1,way2};
        if isfield(handles.main,'change_edge')
            handles.change_way_pos = length(handles.main.change_edge)+1;
        else
            handles.change_way_pos = 1;
        end
        
        disp('###')
    else
        mainhandles = guidata(handles.main.figure1); %Läser in main handles
        
        if not(handles.changes_pre)
            ancest_id = str2double(handles.current_way_struct.id);
        else
            ancest_id = str2double(handles.way_load_settings{1});
        end
        
        if isfield(mainhandles,'delete_edge')
            pos = length(mainhandles.delete_edge)+1;
            mainhandles.delete_edge(pos) = {[ancest_id;{[]};{deleted}]};
        else
            mainhandles.delete_edge(1) = {[ancest_id;{[]};{deleted}]};
        end
        
        guidata(handles.main.figure1,mainhandles) %Uppdaterar/sparar handles.main
        
        hline = findobj(handles.main.figure1,'Type','line', '-and','LineWidth', 1.5, '-or','LineWidth',1.4); %Fetchar "current selected line"
        set(hline,'Color', [0.9100 0.4100 0.1700], 'LineWidth', 1.4, 'Visible', 'off'); %sätter linjen som "redigerad" samt off
        
        len_delete = length(deleted);
        X = zeros(1,len_delete);
        Y = zeros(1,len_delete);
        for i=1:len_delete
            node_id_osm = num2str(deleted{i});
            id_mapped = handles.graph_data.id_map(node_id_osm);
            X(i) = handles.data_umea.node(id_mapped).lon;
            Y(i) = handles.data_umea.node(id_mapped).lat;
        end
        line('Ydata',Y,'Xdata',X,'LineStyle', '- -', 'LineWidth', 1.3, 'Parent', handles.main.axes1);
        handles.changes_pre = 'delete';
    end
else
    if (handles.deleteCoord1 & handles.deleteCoord2)
        msgbox('Both coordinates must be selected and they may not be the same!')
    end
end
    
% <Start checkboxar/speed/parking>
%change_way={ID,highway, maxspeed, bicycle, oneway, parking, cycleway,footway}   
            % 1     2       3          4      5        6        7        8
%change_way={ID,highway, maxspeed, bicycle, oneway, cycleway}
settingsType = {'id','highway','maxspeed','bicycle','oneway','cycleway','ndref'};

newSettings = currentSettings;

if get(handles.cb_car,'value') == 1
    newSettings{2} = 1;
else
    newSettings{2} = 0;
end

% if get(handles.cb_walking,'value') == 1
%     newSettings{8} = 1;
% else
%     newSettings{8} = 0;
% end

if get(handles.cb_bus,'value') == 1
    newSettings{2} = 1;
elseif get(handles.cb_car,'value') == 0 %om både buss/bil är 0. "True fallen" är täckta redan
    newSettings{2} = 0;
end

% if get(handles.cb_parking,'value') == 1
%     newSettings{6} = 1;
% else
%     newSettings{6} = 0;
% end

if get(handles.cb_oneway,'value') == 1
    newSettings{5} = 1;
else
    newSettings{5} = 0;
end

if get(handles.cb_bicycle,'value') == 1 & get(handles.cb_car,'value') == 0 & get(handles.cb_bus,'value') == 0
    newSettings{6} = 1;
    newSettings{4} = 1;
elseif get(handles.cb_bicycle,'value') == 1
    newSettings{4} = 1;
else
    newSettings{4} = 0;
end

if get(handles.edit_speedLimit,'string')
    a = get(handles.edit_speedLimit,'string');
    to_num = str2num(a);
    if to_num > 0
        newSettings{3} = to_num;
    end
end
%change_way={ID,highway, maxspeed, bicycle, oneway, parking, cycleway,footway}   
            % 1     2       3          4      5        6        7        8
%change_way={ID,highway, maxspeed, bicycle, oneway, cycleway}

% </checkboxar och allt förutom deleteWay>

% <avgöra om changes blivit gjorda>
for i = 1:length(newSettings)-1 %-1 pga sista position är en cell med noderna
    if not(isempty(newSettings{i}))
        if not(currentSettings{i} == newSettings{i})
            changes = true;
            disp(strcat('# Change _', settingsType{i}, ' to_ ', num2str(newSettings{i})))
        end
    end
end
% </end>

% <Byta färg på vägen vilken indikerar användaren att en ändring gjorts>
if changes
    h = waitbar(0,'Saving changes...');
    mainhandles = guidata(handles.main.figure1); %Läser in handles.main
    if not(handles.changes_pre)
        hline = findobj(handles.main.figure1,'Type','line', '-and','LineWidth', 1.5);
        for i=1:length(hline);
            set(hline(i), 'Color', [0.9100 0.4100 0.1700], 'LineWidth', 0.9); %Färgar orange
        end
        waitbar(0.5,h);
        if isfield(mainhandles,'change_way')
            pos = length(mainhandles.change_way)+1;
            mainhandles.change_way{pos} = newSettings;
        else
            mainhandles.change_way{1} = newSettings;
        end
        
    elseif strcmp(handles.changes_pre,'properties')
        hline = findobj(handles.main.figure1,'Type','line', '-and','LineWidth', 1.4);
        for i=1:length(hline);
            set(hline(i), 'Color', [0.9100 0.4100 0.1700], 'LineWidth', 0.9); %Färgar orange
        end
        waitbar(0.5,h);
        pos = handles.change_way_pos;
        mainhandles.change_way{pos} = newSettings;
        
    elseif strcmp(handles.changes_pre,'structure')
        hline = findobj(handles.main.figure1,'Type','line', '-and','LineWidth', 1.3, '-and','Color', 'red');
        for i=1:length(hline);
            set(hline(i), 'Color', [0.9100 0.4100 0.1700], 'LineWidth', 1.3); %Färgar orange
        end
        waitbar(0.5,h);
        pos = handles.change_way_pos;
        mainhandles.change_edge{pos} = newSettings;
%
        if isfield(mainhandles,'change_way')
            change_way_list = mainhandles.change_way;
            len_way_list = length(change_way_list);
            way_changes_delete = [];
            for i=1:len_way_list
                change_way_list{i}{1};
                if str2double(change_way_list{i}{1}) == str2double(newSettings{1})
                    way_changes_delete = [way_changes_delete i];
                end
            end
            way_changes_delete = fliplr(way_changes_delete);
            for i=way_changes_delete
                mainhandles.change_way(i) = [];
            end
        end
%
    elseif strcmp(handles.changes_pre,'newStructure')
        waitbar(0.5,h);
        pos = handles.change_way_pos;
        ways = newSettings{7};
        newSettings{7} = ways{1};
        mainhandles.change_edge{pos} = newSettings;
        newSettings{7} = ways{2};
        mainhandles.change_edge{pos+1} = newSettings;
%
        if isfield(mainhandles,'change_way')
            change_way_list = mainhandles.change_way;
            len_way_list = length(change_way_list);
            way_changes_delete = [];
            for i=1:len_way_list
                change_way_list{i}{1};
                if str2double(change_way_list{i}{1}) == str2double(newSettings{1})
                    way_changes_delete = [way_changes_delete i];
                end
            end
            way_changes_delete = fliplr(way_changes_delete);
            for i=way_changes_delete
                mainhandles.change_way(i) = [];
            end
        end
%
    elseif strcmp(handles.changes_pre,'delete')
        waitbar(0.5,h);
%        
        if isfield(mainhandles,'change_way')
            change_way_list = mainhandles.change_way;
            len_way_list = length(change_way_list);
            way_changes_delete = [];
            for i=1:len_way_list
                change_way_list{i}{1};
                if str2double(change_way_list{i}{1}) == str2double(newSettings{1})
                    way_changes_delete = [way_changes_delete i];
                end
            end
            way_changes_delete = fliplr(way_changes_delete);
            for i=way_changes_delete
                mainhandles.change_way(i) = [];
            end
        end
%        
    end
    waitbar(0.75,h);
    guidata(handles.main.figure1,mainhandles); %Uppdaterar/sparar handles.main
    waitbar(1,h);
    delete(h)
end
if changes | (handles.deleteCoord1 & handles.deleteCoord2)
    setLineProperty(handles.main.figure1, handles.main); %uppdaterar lineproperties
end
% </Byta färg på vägen vilken indikerar användaren att en ändring gjorts>
% set line property
ispoint = isfield(handles,'im3');
if ispoint == 1;
    delete(handles.im3);
end
ispoint = isfield(handles,'im4');
if ispoint == 1;
    delete(handles.im4);
end
delete(handles.wayPropertiesWindow);
end

% --- Executes on button press in delete_node_1.
function cancel_deletion_Callback(hObject, eventdata, handles)
% hObject    handle to delete_node_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ispoint = isfield(handles,'im3');
if ispoint == 1;
    delete(handles.im3);
end
ispoint = isfield(handles,'im4');
if ispoint == 1;
    delete(handles.im4);
end

handles.deleteCoord1 = false;
handles.deleteCoord2 = false;
end

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ispoint = isfield(handles,'im3');
if ispoint == 1;
    delete(handles.im3);
end
ispoint = isfield(handles,'im4');
if ispoint == 1;
    delete(handles.im4);
end
if strcmp(handles.changes_pre,'properties')
    hline = findobj(handles.main.figure1,'Type','line', '-and','LineWidth', 1.4);
    for i=1:length(hline);
        set(hline(i), 'Color', [0.9100 0.4100 0.1700], 'LineWidth', 0.9); %Färgar orange
    end
    pos = handles.change_way_pos;
end
    
delete(handles.wayPropertiesWindow);
end
