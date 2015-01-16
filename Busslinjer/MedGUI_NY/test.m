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

% Last Modified by GUIDE v2.5 12-Jan-2015 14:53:25

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
handles.current_node = '283324062';
handles.current_day = 'Monday';

% exists??
if exist('data_umea.mat','file') > 0
    handles.data_umea = load('data_umea.mat');
else
    data_handling2
    handles.data_umea = load('data_umea.mat');
end

%handles.data_umea = load('data_umea.mat');%,'node','way','foot_way','park_nodes');

if exist('graph_data.mat','file') > 0
    handles.graph_data = load('graph_data.mat','intnd_count','intnd','intnd_map','id_map');
else
    create_graph_all_agent
    handles.graph_data = load('graph_data.mat','intnd_count','intnd','intnd_map','id_map');
end

%handles.graph_data = load('graph_data.mat','intnd_count','intnd','intnd_map','id_map');

waitbar(0.5,h);

plot_map
plot_nodes_init(handles.graph_data, handles.data_umea);
setLineProperty(hObject, handles)
waitbar(1,h);
delete(h)


% Sparar undan "children" till figuren (inneh�ller alla grafikobjekt som
% tex v�gar och noder)
handles.ch = get(handles.axes1,'children');
handles.n_one = 0;
handles.n_footways = 0;
handles.n2_one = 0;
handles.n2_footways = 0;
handles.oneline_there = 0;
handles.pot_cre = 0;
handles.n_pot = 0;
handles.bus_cre = 0;
handles.n_bus = 0;

% win2 stuff
handles.carDef = 1.0;
handles.bikeDef = 15.0;
handles.walkDef = 4.0;
handles.parkDef = 1.0;

handles.tvCar = 59;
handles.tvBus = 33;
handles.tvBic = 135;
handles.carCosts = 30;
handles.parkTic = 20;
handles.busTic = 20;

% General cost stuff
handles.generalCost = 1;
handles.alpha = 1;      % Timevalue parameter [0,1]
handles.beta = 1;       % Actualcost parameter [0,1]

handles.travBike = 1;
handles.travBus = 1;
handles.travCar = 1;
handles.radiobutton = 0;

%agent on/off, off by def
handles.agentOn = 0;

% position p�current node
handles.pospoint = [handles.graph_data.intnd(handles.graph_data.intnd_map(handles.graph_data.id_map(handles.current_node))).lon, handles.graph_data.intnd(handles.graph_data.intnd_map(handles.graph_data.id_map(handles.current_node))).lat];

set(zoom(handles.axes1),'ActionPostCallback',@(obj,event_obj)zoomcallbkfnkt(obj,event_obj,handles));

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
                       

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to coord_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.generalCost
handles.agentOn
h = waitbar(0,'Computing..');
% Computes the fastest trip and plots the result in axes1
wayProperties_save(handles)
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

%fastest_trip = bus(handles.current_node,handles.graph_data,travelTime);
%fastest_trip = busTime(handles.current_node,handles.graph_data,travelTime,handles.current_day);
%generalCost = 0;
%alpha = 1;      % Timevalue parameter [0,1]
%beta = 0.5;       % Actualcost parameter [0,1]

fastest_trip = busTime(handles.current_node,handles.graph_data,travelTime,handles.current_day,handles.generalCost,handles.alpha,handles.beta);
waitbar(0.5,h);
axes(handles.axes1)
[~,n_ways] = size(handles.data_umea.way);
nr = handles.n_one + handles.n_footways;
n = handles.graph_data.intnd_count;
ax = axis(handles.axes1);
set(handles.ch(n_ways+nr+1:n_ways + nr + n),'MarkerSize',min([45,2.5/(ax(4)-ax(3))]))
plot_nodes3(fastest_trip,handles)%,generalCost,alpha,beta)
handles = guidata(hObject);


% Generera bild var tredje minut som sparas som pngfil med namn ex "0035.png"
% i mappen Img/.
% travelTime = 1;
% for i=1:480
%     tempTime = travelTime + 3*(i-1);  
%     fastest_trip = busTime(handles.current_node,handles.graph_data,tempTime,handles.current_day,handles.generalCost,handles.alpha,handles.beta);
%     axes(handles.axes1)
%     tMin = num2str(mod(tempTime,60));
%     tHour = num2str(floor(tempTime/60));
%     if length(tMin)==1
%         tMin = strcat('0',tMin);
%     end
%     if length(tHour)==1
%         tHour = strcat('0',tHour);
%     end
%     fileName = strcat('Img/',strcat(tHour,'_',tMin));
%     set(handles.time_edit,'string',strcat(tHour,':',tMin));
%     plot_nodes3(fastest_trip,handles)
% 
%     export_fig(fileName,'-png','-native')
% end



ispoint = isfield(handles,'im3');
if ispoint == 1;
    delete(handles.im3);
end
try
    handles.im3 = impoint(gca,handles.pospoint);
    setColor(handles.im3,'y');
    guidata(hObject,handles);
catch
    disp('Please, choose a location to be able to see a choosen location')
    waitbar(1,h);
    delete(h)
    exit
end

waitbar(1,h);
delete(h)


function time_edit_Callback(hObject, eventdata, handles)
% hObject    handle to time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and use r data (see GUIDATA)

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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
str = get(hObject,'String');
val = get(hObject,'Value');
handles.current_day = str{val};
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%plot_roads(handles.graph_data,handles.data_umea,handles);%göra spec handles för import
%test2=getfield(handles, 'rv3');
%handles.apple=0
rv(handles.figure1);

guidata(hObject,handles);



function x_edit_Callback(hObject, eventdata, handles)
% hObject    handle to x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_edit as text
%        str2double(get(hObject,'String')) returns contents of x_edit as a double


% --- Executes during object creation, after setting all properties.
function x_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_edit_Callback(hObject, eventdata, handles)
% hObject    handle to y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_edit as text
%        str2double(get(hObject,'String')) returns contents of y_edit as a double
get(hObject,'String')

% --- Executes during object creation, after setting all properties.
function y_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xcor = get(handles.x_edit, 'String');
ycor = get(handles.y_edit, 'String');

xcor = str2num(xcor);
ycor = str2num(ycor);


ispoint = isfield(handles,'point');
if ispoint == 1;
    delete(handles.point)
end
handles.point = impoint(gca,xcor,ycor);
handles.coordinates = getPosition(handles.point);
set(handles.text1,'string',{'Pixels',num2str(handles.coordinates(1,1))...
    num2str(handles.coordinates(1,2))});
guidata(hObject,handles);


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
win2(handles.figure1);
guidata(hObject,handles);


% --------------------------------------------------------------------
function zoom_reset_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to zoom_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.axes1,'XLim',[20.05 20.54],'YLim',[63.77 63.90]);


% --- Executes on button press in AddWay.
function AddWay_Callback(hObject, eventdata, handles)
% hObject    handle to AddWay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

addWay(handles, false)

function zoomcallbkfnkt(obj,event_obj,handles)
[~,n_ways] = size(handles.data_umea.way);
nr = handles.n_one + handles.n_footways;
n = handles.graph_data.intnd_count;
ax = axis(handles.axes1);
set(handles.ch(n_ways+nr+1:n_ways + nr + n),'MarkerSize',min([35,0.75/(ax(4)-ax(3))]))


% --- Executes on button press in parking.
function parking_Callback(hObject, eventdata, handles)
% hObject    handle to parking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

parkingHandler(handles)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('graph_data.mat','CGM_sparse')

disp('1')
create_closest_park_nodes(handles.graph_data, handles.data_umea)
disp('2')
create_spawn_paths(handles.graph_data,handles.data_umea, CGM_sparse)
disp('3')
agent_model22(handles.graph_data,handles.data_umea, CGM_sparse)
%delete graph_data.mat
%disp('4')
%create_graph_all_agent(handles.data_umea)
clear CGM_sparse
disp('klar')


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
if get(hObject,'Value')
    handles.agentOn = 1;
else
    handles.agentOn = 0;
end
guidata(hObject,handles);
