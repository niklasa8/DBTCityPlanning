%2 inputs, 1:a handle, 2:a "previously changed?" (true/false)

function varargout = addWay(varargin)
% ADDWAY MATLAB code for addWay.fig
%      ADDWAY, by itself, creates a new ADDWAY or raises the existing
%      singleton*.
%
%      H = ADDWAY returns the handle to a new ADDWAY or the handle to
%      the existing singleton*.
%
%      ADDWAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADDWAY.M with the given input arguments.
%
%      ADDWAY('Property','Value',...) creates a new ADDWAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before addWay_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to addWay_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help addWay

% Last Modified by GUIDE v2.5 10-Dec-2014 15:32:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @addWay_OpeningFcn, ...
                   'gui_OutputFcn',  @addWay_OutputFcn, ...
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

% --- Executes just before addWay is made visible.
function addWay_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to addWay (see VARARGIN)

% Choose default command line output for addWay
handles.output = hObject;

handles.main = varargin{1};%1st arg => handle from main.m
handles.changes_pre = varargin{2};%2nd arg => new road or are we just modifying it? (true/false)

% Update handles structure
guidata(hObject, handles);

if handles.changes_pre %om tidigare ändringar gjorts
    if isfield(handles.main,'add_way') 
        for i=1:length(handles.main.add_way);
            if (handles.main.add_way(i).id) == handles.main.current_way %current_way fås av rightclick i setLineProp
                handles.way_load_settings = handles.main.add_way(i);
                handles.add_way_pos = length(handles.main.add_way)+1;
                break
            end
        end
%add_way={ID, highway, maxspeed, bicycle, oneway, parking, cycleway, footway, ndref}   
        
        if isfield(handles,'way_load_settings')
            if way(current_way).highway
                set(handles.cb_car,'value',1)
            end

%             if way(current_way).parking
%                 set(handles.cb_car,'value',1)
%                 set(handles.parking_box,'visible','on')
%             end

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

%             if way(current_way).parking
%                 set(handles.cb_parking,'value',1)
%                 set(handles.parking_box,'visible','on')
%             else
%                 set(handles.cb_parking,'value',0)
%                 set(handles.parking_box,'visible','off')
%             end


            %edit_speedLimit
            maxspeed = way(current_way).maxspeed;
            set(handles.edit_speedLimit,'string',num2str(maxspeed))
        else
            disp('Error in addWay, way_load_settings')
        end
    
    else
        disp('Error in addWay, load change_way from handles')
    end
else
    if isfield(handles.main,'add_way') 
        handles.add_way_pos = length(handles.main.add_way)+1;
    else
        handles.add_way_pos = 1;
        handles.main.add_way = {}
    end
end

guidata(handles.main.figure1,handles.main);
guidata(hObject,handles);
end

% --- Outputs from this function are returned to the command line.
function varargout = addWay_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in cb_oneway.
function cb_oneway_Callback(hObject, eventdata, handles)
% hObject    handle to cb_oneway (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_oneway
end

% --- Executes on button press in cb_parking.
function cb_parking_Callback(hObject, eventdata, handles)
% hObject    handle to cb_parking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_parking
end


function parking_time_Callback(hObject, eventdata, handles)
% hObject    handle to parking_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parking_time as text
%        str2double(get(hObject,'String')) returns contents of parking_time as a double
end

% --- Executes during object creation, after setting all properties.
function parking_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parking_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

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

% --- Executes on button press in add_node.
function add_node_Callback(hObject, eventdata, handles)
% hObject    handle to add_node (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')
    handles.main = guidata(handles.main.figure1);
    set(handles.main.figure1,'WindowButtonMotionFcn', @cursor_coord);
    ispoint = isfield(handles,'point');
    if ispoint == 1;
        delete(handles.point)
    end
    handles.point = impoint(handles.main.axes1,[]);
    handles.coordinates = getPosition(handles.point);
    delete(handles.point);
    coords = decrypt_coords_add(hObject,handles,0.00020); %sista är "sensivity"
    
%     coordinates(1) = lon coordinates(2) = lat
    if isfield(handles.main,'add_node')
        node_pos = length(handles.main.add_node)+1;
    else
        node_pos = 1;
    end
    currently_plotted_lon = [];
    currently_plotted_lat = [];
    if length(handles.main.add_way) == handles.add_way_pos
        if isfield(handles.main.add_way(handles.add_way_pos),'ndref') & length(handles.main.add_way(handles.add_way_pos).ndref) >= 2
            for i=1:length(handles.main.add_way(handles.add_way_pos).ndref)
                %om den är double betyder det att den ligger i add_node, annars
                %i data_umea.node
                current_node_ref = handles.main.add_way(handles.add_way_pos).ndref{i};
                if strcmp(class(current_node_ref), 'double')
                    currently_plotted_lon = [currently_plotted_lon handles.main.add_node(current_node_ref-1000).lon];
                    currently_plotted_lat = [currently_plotted_lat handles.main.add_node(current_node_ref-1000).lat];

                elseif strcmp(class(current_node_ref), 'char')
                    id_mapped = handles.main.graph_data.intnd_map(handles.main.graph_data.id_map(current_node_ref));

                    currently_plotted_lon = [currently_plotted_lon handles.main.graph_data.intnd(id_mapped).lon];
                    currently_plotted_lat = [currently_plotted_lat handles.main.graph_data.intnd(id_mapped).lat];
                end
            end

            hline = findobj(handles.main.axes1,'XData', currently_plotted_lon, '-and','YData', currently_plotted_lat); %sätter alla (1) selected till not selected
            for i=1:length(hline);
                delete(hline(i))
            end
        end
    end
    
    if strcmp(coords{2},'false') %om inte coords, dvs decrypt gav något, använder vi coordinates
        handles.main.add_node(node_pos).id = 1000 + node_pos;
        handles.main.add_node(node_pos).lon = handles.coordinates(1);
        handles.main.add_node(node_pos).lat = handles.coordinates(2);
        handles.main.add_node(node_pos).parking = [];
        guidata(hObject,handles);
        if not(length(handles.main.add_way) == handles.add_way_pos)
            handles.main.add_way(handles.add_way_pos).ndref{1} = handles.main.add_node(node_pos).id;
        else
            if ~isfield(handles.main.add_way(handles.add_way_pos),'ndref')
                handles.main.add_way(handles.add_way_pos).ndref{1} = handles.main.add_node(node_pos).id;
            else
                len_ndref = length(handles.main.add_way(handles.add_way_pos).ndref);
                handles.main.add_way(handles.add_way_pos).ndref{len_ndref+1} = handles.main.add_node(node_pos).id;
            end
        end
        
    else
        if strcmp(coords{2},'intnd') %om vi fick en nod som existerar i intnd
            if not(length(handles.main.add_way) == handles.add_way_pos)
                handles.main.add_way(handles.add_way_pos).ndref{1} = handles.main.graph_data.intnd(coords{1}).id;
            else
                if ~isfield(handles.main.add_way(handles.add_way_pos),'ndref')
                    handles.main.add_way(handles.add_way_pos).ndref{1} = handles.main.graph_data.intnd(coords{1}).id;
                else
                    len_ndref = length(handles.main.add_way(handles.add_way_pos).ndref);
                    handles.main.add_way(handles.add_way_pos).ndref{len_ndref+1} = handles.main.graph_data.intnd(coords{1}).id;
                end
            end
        elseif strcmp(coords{2},'add_node') %om vi fick en nod som existerar i add_node
            if not(length(handles.main.add_way) == handles.add_way_pos)
                handles.main.add_way(handles.add_way_pos).ndref{1} = handles.main.add_node(coords{1}).id;
            else
                if ~isfield(handles.main.add_way(handles.add_way_pos),'ndref')
                    handles.main.add_way(handles.add_way_pos).ndref{1} = handles.main.add_node(coords{1}).id;
                else
                    len_ndref = length(handles.main.add_way(handles.add_way_pos).ndref);
                    handles.main.add_way(handles.add_way_pos).ndref{len_ndref+1} = handles.main.add_node(coords{1}).id;
                end
            end
        end
    end
    plot_lon = [];
    plot_lat = [];
    
    if isfield(handles.main.add_way(handles.add_way_pos),'ndref') & length(handles.main.add_way(handles.add_way_pos).ndref) >= 2
        for i=1:length(handles.main.add_way(handles.add_way_pos).ndref)
            %om den är double betyder det att den ligger i add_node, annars
            %i data_umea.node
            current_node_ndref = handles.main.add_way(handles.add_way_pos).ndref{i};
            if strcmp(class(current_node_ndref), 'double')
                plot_lon = [plot_lon handles.main.add_node(current_node_ndref-1000).lon];
                plot_lat = [plot_lat handles.main.add_node(current_node_ndref-1000).lat];
                
            elseif strcmp(class(current_node_ndref), 'char')
                id_mapped = handles.main.graph_data.intnd_map(handles.main.graph_data.id_map(current_node_ndref));
                
                plot_lon = [plot_lon handles.main.graph_data.intnd(id_mapped).lon];
                plot_lat = [plot_lat handles.main.graph_data.intnd(id_mapped).lat];
            end
        end
        line('Ydata',plot_lat,'Xdata',plot_lon,'parent',handles.main.axes1,'LineWidth',0.6); %YData = lat, XData = lon
    end
    
    if strcmp(coords{2},'false')
        handles.pospoint = [handles.main.add_node(node_pos).lon,handles.main.add_node(node_pos).lat];
        ispoint = isfield(handles,'im3');
        if ispoint == 1;
            delete(handles.im3);
        end
        handles.im3 = impoint(handles.main.axes1,handles.pospoint);
        setColor(handles.im3,'g');
        guidata(hObject,handles);
    elseif strcmp(coords{2},'add_node')
        handles.pospoint = [handles.main.add_node(coords{1}).lon,handles.main.add_node(coords{1}).lat];
        ispoint = isfield(handles,'im3');
        if ispoint == 1;
            delete(handles.im3);
        end
        handles.im3 = impoint(handles.main.axes1,handles.pospoint);
        setColor(handles.im3,'g');
        guidata(hObject,handles);
    else
        handles.pospoint = [handles.main.graph_data.intnd(coords{1}).lon,handles.main.graph_data.intnd(coords{1}).lat];

        if isfield(handles,'im3');
            delete(handles.im3);
        end
        handles.im3 = impoint(handles.main.axes1,handles.pospoint);
        setColor(handles.im3,'g');
        guidata(hObject,handles);
    end
end
guidata(handles.main.figure1,handles.main)

end

% --- Executes on button press in remove_latest.
function remove_latest_Callback(hObject, eventdata, handles)
% hObject    handle to remove_latest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value') 
    handles.main = guidata(handles.main.figure1);
    if length(handles.main.add_way) == handles.add_way_pos
        if isfield(handles.main.add_way(handles.add_way_pos),'ndref')
            len_ndref = length(handles.main.add_way(handles.add_way_pos).ndref);
            if len_ndref == 0
                msgbox('No node has been added yet!')
                
            elseif len_ndref == 1
                handles.main.add_way(handles.add_way_pos).ndref(1) = [];
                
            elseif len_ndref >= 2
                currently_plotted_lon = [];
                currently_plotted_lat = [];
                
                for i=1:length(handles.main.add_way(handles.add_way_pos).ndref)
                    %om den är double betyder det att den ligger i add_node, annars
                    %i data_umea.node
                    current_node_ref = handles.main.add_way(handles.add_way_pos).ndref{i};
                    
                    if strcmp(class(current_node_ref), 'double')
                        currently_plotted_lon = [currently_plotted_lon handles.main.add_node(current_node_ref-1000).lon];
                        currently_plotted_lat = [currently_plotted_lat handles.main.add_node(current_node_ref-1000).lat];

                    elseif strcmp(class(current_node_ref), 'char')
                        id_mapped = handles.main.graph_data.intnd_map(handles.main.graph_data.id_map(current_node_ref));

                        currently_plotted_lon = [currently_plotted_lon handles.main.graph_data.intnd(id_mapped).lon];
                        currently_plotted_lat = [currently_plotted_lat handles.main.graph_data.intnd(id_mapped).lat];
                    end
                end

                hline = findobj(handles.main.axes1,'XData', currently_plotted_lon, '-and','YData', currently_plotted_lat); %sätter alla (1) selected till not selected
                for i=1:length(hline);
                    delete(hline(i))
                end
                
                handles.main.add_way(handles.add_way_pos).ndref(len_ndref) = []; %deletar den senast tillagda
                guidata(handles.main.figure1,handles.main)
                
                if len_ndref >= 3 %om längden var minst 3 innan betyder det att den är minst 2 nu, dvs en linje kan ritas ut!
                    plot_lon = [];
                    plot_lat = [];

                    for i=1:length(handles.main.add_way(handles.add_way_pos).ndref)
                        %om den är double betyder det att den ligger i add_node, annars
                        %i data_umea.node
                        current_node_ndref = handles.main.add_way(handles.add_way_pos).ndref{i};
                        if strcmp(class(current_node_ndref), 'double')
                            plot_lon = [plot_lon handles.main.add_node(current_node_ndref-1000).lon];
                            plot_lat = [plot_lat handles.main.add_node(current_node_ndref-1000).lat];

                        elseif strcmp(class(current_node_ndref), 'char')
                            id_mapped = handles.main.graph_data.intnd_map(handles.main.graph_data.id_map(current_node_ndref));

                            plot_lon = [plot_lon handles.main.graph_data.intnd(id_mapped).lon];
                            plot_lat = [plot_lat handles.main.graph_data.intnd(id_mapped).lat];
                        end
                    end
                    line('Ydata',plot_lat,'Xdata',plot_lon,'parent',handles.main.axes1,'LineWidth',0.6); %YData = lat, XData = lon
                end
            end  
        else
            msgbox('No node has been added yet!')
        end
    else
        msgbox('No node has been added yet!')
    end
    
end
if isfield(handles,'im3');
    delete(handles.im3);
end
guidata(handles.main.figure1,handles.main)
end


% --- Executes on button press in submit.
function submit_Callback(hObject, eventdata, handles)
% hObject    handle to submit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close = true;
if length(handles.main.add_way) == handles.add_way_pos
    if isfield(handles.main.add_way(handles.add_way_pos),'ndref')
        if length(handles.main.add_way(handles.add_way_pos).ndref) >= 2
%   {id, highway, maxspeed, bicycle, oneway, parking, cycleway, footway, ndref}
            if get(handles.cb_car,'value') == 1
                handles.main.add_way(handles.add_way_pos).highway = 1;
            else
                handles.main.add_way(handles.add_way_pos).highway = 0;
            end

%             if get(handles.cb_walking,'value') == 1
%                 handles.main.add_way(handles.add_way_pos).footway = 1;
%             else
%                 handles.main.add_way(handles.add_way_pos).footway = 0;
%             end

            if get(handles.cb_bus,'value') == 1
                handles.main.add_way(handles.add_way_pos).highway = 1;
            elseif get(handles.cb_car,'value') == 0 %om både buss/bil är 0. "True fallen" är täckta redan
                handles.main.add_way(handles.add_way_pos).highway = 0;
            end

            if get(handles.cb_oneway,'value') == 1
                handles.main.add_way(handles.add_way_pos).oneway = 1;
            else
                handles.main.add_way(handles.add_way_pos).oneway = 0;
            end

            if get(handles.cb_bicycle,'value') == 1 & get(handles.cb_car,'value') == 0 & get(handles.cb_bus,'value') == 0
                handles.main.add_way(handles.add_way_pos).cycleway = 1;
                handles.main.add_way(handles.add_way_pos).bicycle = 1;
            elseif get(handles.cb_bicycle,'value') == 1
                handles.main.add_way(handles.add_way_pos).bicycle = 1;
                handles.main.add_way(handles.add_way_pos).cycleway = 0;
            else
                handles.main.add_way(handles.add_way_pos).cycleway = 0;
                handles.main.add_way(handles.add_way_pos).bicycle = 0;
            end

            if get(handles.edit_speedLimit,'string')
                a = get(handles.edit_speedLimit,'string');
                to_num = str2num(a);
                if to_num > 0
                    handles.main.add_way(handles.add_way_pos).maxspeed = to_num;
                else
                    handles.main.add_way(handles.add_way_pos).maxspeed = 0;
                end
            end
        else
            msgbox('At least two nodes must be added in order to create a way!')
            close = false;
        end
    else
        msgbox('You havent added any nodes to the way yet!')
        close = false;
    end
else
    msgbox('You havent added any nodes to the way yet!')
    close = false;
end
if isfield(handles,'im3');
    delete(handles.im3);
end

if close
    guidata(handles.main.figure1,handles.main);
    addWay_setLineProperty(handles)
    delete(handles.figure1);
end


end



% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.main = guidata(handles.main.figure1);
if length(handles.main.add_way) == handles.add_way_pos
    if isfield(handles.main.add_way(handles.add_way_pos),'ndref')
        if length(handles.main.add_way(handles.add_way_pos).ndref) >= 2
            currently_plotted_lon = [];
            currently_plotted_lat = [];
            for i=1:length(handles.main.add_way(handles.add_way_pos).ndref)
                %om den är double betyder det att den ligger i add_node, annars
                %i data_umea.node
                current_node_ref = handles.main.add_way(handles.add_way_pos).ndref{i};
                if strcmp(class(current_node_ref), 'double')
                    currently_plotted_lon = [currently_plotted_lon handles.main.add_node(current_node_ref-1000).lon];
                    currently_plotted_lat = [currently_plotted_lat handles.main.add_node(current_node_ref-1000).lat];

                elseif strcmp(class(current_node_ref), 'char')
                    id_mapped = handles.main.graph_data.intnd_map(handles.main.graph_data.id_map(current_node_ref));

                    currently_plotted_lon = [currently_plotted_lon handles.main.graph_data.intnd(id_mapped).lon];
                    currently_plotted_lat = [currently_plotted_lat handles.main.graph_data.intnd(id_mapped).lat];
                end
            end
            
            hline = findobj(handles.main.axes1,'XData', currently_plotted_lon, '-and','YData', currently_plotted_lat); %sätter alla (1) selected till not selected
            for i=1:length(hline);
                delete(hline(i))
            end
        end
        
        handles.main.add_way(handles.add_way_pos) = [];
    end
end
if isfield(handles,'im3');
    delete(handles.im3);
end
guidata(handles.main.figure1,handles.main);
delete(handles.figure1);

end
