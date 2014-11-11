function varargout = test(varargin)
% TEST MATLAB code for test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test

% Last Modified by GUIDE v2.5 04-Nov-2014 23:40:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
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


% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)

h = waitbar(0,'Initializing..');
handles.current_node = '444493179';
handles.graph_data = load('graph_data.mat','intnd_count','intnd','intnd_map','id_map');
handles.data_umea = load('data_umea.mat','node','way');

waitbar(0.5,h);

plot_nodes_init(handles.graph_data, handles.data_umea);

waitbar(1,h);
delete(h)

% Choose default command line output for test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in coord_button.
function coord_button_callback(hObject, eventdata, handles)
% hObject    handle to coord_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value')  
    set(gcf,'WindowButtonMotionFcn', @cursor_coord);
    
    ispoint = isfield(handles,'point');
    if ispoint == 1;
        delete(handles.point)
    end
    handles.point = impoint(gca,[]);
    handles.coordinates = getPosition(handles.point);
    set(handles.text1,'string',{'Pixels',num2str(handles.coordinates(1,1))...
        num2str(handles.coordinates(1,2))});
    
    guidata(hObject,handles);
    
    
    handles.current_node = decrypt_coords(hObject,handles); %k�r in coordinaterna i "decrypt"
    handles = guidata(hObject);
    % Update handles structure
    
    guidata(hObject,handles);

else
    set(gcf,'WindowButtonMotionFcn','default');
    guidata(hObject,handles);
end
                       

% --- Executes on button press in coord_button.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to coord_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = waitbar(0,'Computing..');
% Computes the fastest trip and plots the result in axes1

travelTime_raw = get(handles.time_edit, 'String');
travelTime_split = strsplit(travelTime_raw,':');
[sizeStart,sizeEnd] = size(travelTime_split);

if sizeEnd == 2
    travelTime_hour = str2num(travelTime_split{1});
    travelTime_min = str2num(travelTime_split{2});
    if (travelTime_hour && travelTime_min) || (travelTime_hour == 0 || travelTime_min == 0)
        if travelTime_hour >= 0 && travelTime_hour <= 24 && travelTime_min >= 0 && travelTime_min <= 60
            travelTime = travelTime_hour*60 + travelTime_min;
        else
            disp('Valid time is between 0-24h and 0-60min!') %tar ej h�nsyn till ex. 24:50
        end
    else
        disp('Valid time format is xx:xx in numbers')
    end
else
    disp('Valid time format is xx:xx in numbers')
end

fastest_trip = bus(handles.current_node,handles.graph_data,travelTime);
waitbar(0.5,h);
axes(handles.axes1)
plot_nodes2(fastest_trip,handles.current_node,handles.graph_data,handles.data_umea)

handles = guidata(hObject);
ispoint = isfield(handles,'im3');
if ispoint == 1;
    delete(handles.im3);
end

handles.im3 = impoint(gca,handles.pospoint);
setColor(handles.im3,'y');
guidata(hObject,handles);

waitbar(1,h);
delete(h)


function time_edit_Callback(hObject, eventdata, handles)
% hObject    handle to time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_edit as text
%        str2double(get(hObject,'String')) returns contents of time_edit as a double


% --- Executes during object creation, after setting all properties.
function time_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
