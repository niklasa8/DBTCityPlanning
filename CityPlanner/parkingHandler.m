function varargout = parkingHandler(varargin)
% PARKINGHANDLER MATLAB code for parkingHandler.fig
%      PARKINGHANDLER, by itself, creates a new PARKINGHANDLER or raises the existing
%      singleton*.
%
%      H = PARKINGHANDLER returns the handle to a new PARKINGHANDLER or the handle to
%      the existing singleton*.
%
%      PARKINGHANDLER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARKINGHANDLER.M with the given input arguments.
%
%      PARKINGHANDLER('Property','Value',...) creates a new PARKINGHANDLER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before parkingHandler_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to parkingHandler_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help parkingHandler

% Last Modified by GUIDE v2.5 06-Jan-2015 15:08:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @parkingHandler_OpeningFcn, ...
                   'gui_OutputFcn',  @parkingHandler_OutputFcn, ...
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

% --- Executes just before parkingHandler is made visible.
function parkingHandler_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to parkingHandler (see VARARGIN)

% Choose default command line output for parkingHandler
handles.output = hObject;

handles.main = varargin{1};%1st arg => handle from main.m

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes parkingHandler wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = parkingHandler_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

function edit_n_Callback(hObject, eventdata, handles)
% hObject    handle to edit_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_n as text
%        str2double(get(hObject,'String')) returns contents of edit_n as a double

end

% --- Executes during object creation, after setting all properties.
function edit_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function edit_price_Callback(hObject, eventdata, handles)
% hObject    handle to edit_price (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_price as text
%        str2double(get(hObject,'String')) returns contents of edit_price as a double

end

% --- Executes during object creation, after setting all properties.
function edit_price_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_price (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function edit_current_Callback(hObject, eventdata, handles)
% hObject    handle to edit_current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_current as text
%        str2double(get(hObject,'String')) returns contents of edit_current as a double

end

% --- Executes during object creation, after setting all properties.
function edit_current_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
end

% --- Executes on button press in cb_parking.
function cb_parking_Callback(hObject, eventdata, handles)
% hObject    handle to cb_parking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_parking
if get(hObject,'Value')
    set(handles.parking_settings,'visible','on')
else
    set(handles.parking_settings,'visible','off')
end

end

% --- Executes on button press in select_node.
function select_node_Callback(hObject, eventdata, handles)
% hObject    handle to select_node (see GCBO)
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
    found_node_pos = decrypt_coords_add(hObject,handles,0.00100); %sista är "sensivity
    
    handles.node_pos = found_node_pos{1};
    handles.node_type = found_node_pos{2};
    
    if strcmp(handles.node_type,'intnd')
        handles.current_node = handles.main.graph_data.intnd(handles.node_pos);
    elseif strcmp(handles.node_type,'add_node')
        handles.current_node = handles.main.add_node(handles.node_pos);
    elseif strcmp(handles.node_type,'false')
        msgbox('No nearby node was found!')
        handles.current_node = 0;
    end
    
    if class(handles.current_node) == 'struct' %Om vi hittade nån node
        set(handles.settings,'visible','on') %sätter på parking setting CB
        ispoint = isfield(handles,'im3');
        if ispoint == 1;
            delete(handles.im3);
        end
        handles.im3 = impoint(handles.main.axes1,[handles.current_node.lon, handles.current_node.lat]);
        setColor(handles.im3,'g');
        guidata(hObject,handles);
        
        current_parking = handles.current_node.parking; % 1: max capacity, 2: price/h, 3: current load
        if length(current_parking) > 1 %Om det finns nån parkering här
            set(handles.cb_parking,'value',1)
            set(handles.parking_settings,'visible','on')
            set(handles.edit_n,'string',num2str(current_parking(1))) %max capacity
            if length(current_parking) >= 2
                set(handles.edit_price,'string',num2str(current_parking(2))) %price/h
            elseif length(current_parking) == 3
                set(handles.edit_price,'string',num2str(current_parking(3))) %current load
            end
        else %Om det inte finns nån parkering här (parking = [])
            set(handles.cb_parking,'value',0)
            set(handles.parking_settings,'visible','off')
        end
    end
    guidata(hObject,handles);
end

end

% --- Executes on button press in submit.
function submit_Callback(hObject, eventdata, handles)
% hObject    handle to submit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'im3');
    delete(handles.im3);
end

if isfield(handles,'node_pos') %kollar att node e selectad
    if get(handles.cb_parking,'Value') %kollar ifall parking är ikryssad
        mainhandles = guidata(handles.main.figure1); %Läser in handle från main

        if get(handles.edit_n,'string') %läser maxcapacity
            a = get(handles.edit_n,'string');
            to_num = str2num(a);
            if to_num > 0
                capacity = to_num;
            else
                capacity = 10; %default värdet är 10 parkeringar
            end
        end

        if get(handles.edit_price,'string') %price
            a = get(handles.edit_price,'string');
            to_num = str2num(a);
            if to_num > 0
                price = to_num;
            else
                price = 5; %default värdet är 5kr/timme
            end
        end

        if get(handles.edit_current,'string') %current
            a = get(handles.edit_current,'string');
            to_num = str2num(a);
            if to_num > 0
                current = to_num;
            else
                current = 0; %default värdet är 0 currently parked cars
            end
        end

        if strcmp(handles.node_type,'intnd')

            if isfield(mainhandles,'add_parking_attribute')
                pos = length(mainhandles.add_parking_attribute)+1;
                mainhandles.add_parking_attribute(pos) = {[handles.node_pos;capacity;price;current]};
            else
                mainhandles.add_parking_attribute(1) = {[handles.node_pos;capacity;price;current]};
            end

        elseif strcmp(handles.node_type,'add_node')
            mainhandles.add_node(handles.node_pos).parking = [capacity price current];
        end

        guidata(handles.main.figure1,mainhandles); %Uppdaterar handles i main
    
    else %om parking ej är ikryssad vill vi ta bort denna attribut
        mainhandles = guidata(handles.main.figure1); %Läser in handle från main
        
        if strcmp(handles.node_type,'intnd')

            if isfield(mainhandles,'add_parking_attribute')
                pos = length(mainhandles.add_parking_attribute)+1;
                mainhandles.add_parking_attribute(pos) = {[]};
            else
                mainhandles.add_parking_attribute(1) = {[]};
            end

        elseif strcmp(handles.node_type,'add_node')
            mainhandles.add_node(handles.node_pos).parking = [];
        end

        guidata(handles.main.figure1,mainhandles); %Uppdaterar handles i main
    end
end

delete(handles.figure1);

end


function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'im3');
    delete(handles.im3);
end

delete(handles.figure1);
        
end

% --- Executes on button press in apply.
function apply_Callback(hObject, eventdata, handles)
% hObject    handle to apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'node_pos') & get(handles.cb_parking,'Value')
    mainhandles = guidata(handles.main.figure1); %Läser in handle från main
    
    if get(handles.edit_n,'string') %läser maxcapacity
        a = get(handles.edit_n,'string');
        to_num = str2num(a);
        if to_num > 0
            capacity = to_num;
        else
            capacity = 10; %default värdet är 10 parkeringar
        end
    end
    
    if get(handles.edit_price,'string') %price
        a = get(handles.edit_price,'string');
        to_num = str2num(a);
        if to_num > 0
            price = to_num;
        else
            price = 5; %default värdet är 5kr/timme
        end
    end
    
    if get(handles.edit_current,'string') %current
        a = get(handles.edit_current,'string');
        to_num = str2num(a);
        if to_num > 0
            current = to_num;
        else
            current = 0; %default värdet är 0 currently parked cars
        end
    end
    
    if strcmp(handles.node_type,'intnd')

        if isfield(mainhandles,'add_parking_attribute')
            pos = length(mainhandles.add_parking_attribute)+1;
            mainhandles.add_parking_attribute(pos) = {[handles.node_pos;capacity;price;current]};
        else
            mainhandles.add_parking_attribute(1) = {[handles.node_pos;capacity;price;current]};
        end

    elseif strcmp(handles.node_type,'add_node')
        mainhandles.add_node(handles.node_pos).parking = [capacity price current];
    end
    
    guidata(handles.main.figure1,mainhandles); %Uppdaterar handles i main
end
msgbox('Parking saved!')
end
