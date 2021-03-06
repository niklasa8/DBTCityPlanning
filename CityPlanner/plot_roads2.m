function handles=plot_roads2(hObject,handles)
% Function that change the settings of the roads and some details of the
% nodes before replotting the map.

testf = guidata(handles.test);
data_umea=testf.data_umea;
graph_data=testf.graph_data;
path = matfile('busPaths2.mat');
busP = load('busPaths2.mat');


axes(testf.axes1)
car=get(handles.car,'Value');
bic=get(handles.bic,'Value');
bus=get(handles.bus,'Value');


one=get(handles.one,'Value');
only=get(handles.only,'Value');
others=get(handles.others,'Value');
park=get(handles.park,'Value');

handles.car=car;
handles.bic=bic;
handles.bus=bus;

handles.one=one;
handles.only=only;
handles.others=others;
handles.park=park;

handles.radiobutton1=get(handles.radiobutton1,'Value');
handles.one_direction=get(handles.one_direction,'Value');
handles.footway=get(handles.footway,'Value');

handles.nonodes=get(handles.nonodes,'Value');

% handles.reset = get(handles.reset,'Value');
% if handles.reset == 1
%     handles.c1 = 'k'
    

[handles.c1,handles.cont1]=color_pop(hObject,handles,handles.pop1);
[handles.c2,handles.cont2]=color_pop(hObject,handles,handles.pop2);
% [handles.c3,handles.cont3]=color_pop(hObject,handles,handles.pop3);
[handles.c4,handles.cont4]=color_pop(hObject,handles,handles.pop4);
[handles.c5,handles.cont5]=color_pop(hObject,handles,handles.pop5);
% [handles.c6,handles.cont6]=color_pop(hObject,handles,handles.pop6);
% [handles.c7,handles.cont7]=color_pop(hObject,handles,handles.pop7);
% [handles.c8,handles.cont8]=color_pop(hObject,handles,handles.pop8);
[handles.c9,handles.cont9]=color_pop(hObject,handles,handles.pop9);
% [handles.c10,handles.cont10]=color_pop(hObject,handles,handles.pop10);
% [handles.c11,handles.cont11]=color_pop(hObject,handles,handles.pop11);



[~,n_ways] = size(data_umea.way);
hold on

is = zeros(2,456);
c_more=0;


%is =[];
for i = 1:n_ways %Plottar v�garna mellan noderna, notera att ALLA noder anv�nds (�ven de som inte �r intersection nodes) f�r att rita ut v�garna.
    
    %         [~, n_ndref] = size(data_umea.way(i).ndref);
    %         X = zeros(1,2);
    %         Y = zeros(1,2);%n_ndref
    %         for j = 1:n_ndref
    %             X(j) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{j})).lon;
    %             Y(j) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{j})).lat;
    %         end
    
    
    
    %set(handles.ch(n - i + 1),'color','g');
    %infoga bus only när finns
    
%     if car == 1 && bic==1 && bus==1
%         
%         if data_umea.way(i).cycleway == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c1);
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 0
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c2);
%         elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c3);
%         elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c4);
%             
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c5);
%         elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c6);
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c7);
%             
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c8);
%         %elseif handles.parking==1 && data_umea.way(i).parking == 1
%         %   set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c10);
%         elseif  data_umea.way(i).bicycle == 0 && data_umea.way(i).highway == 0 && data_umea.way(i).cycleway == 0%&& data_umea.way(i).bus == 0
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c11);
%         else
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color','k');
%         end
        
    if car == 1 && bic==1 %&& bus==0
        if data_umea.way(i).cycleway == 1
            set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'color',handles.c1);
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'color',handles.c2);
%         elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c3);
            
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'color',handles.c5);
%         elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 && others==1 %&& data_umea.way(i).bus == 1 x
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c6);
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 && others==1%&& data_umea.way(i).bus == 1 x
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c7);
%             
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c8);
%         elseif park==1 && data_umea.way(i).parking == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c10);
%         elseif  data_umea.way(i).bicycle == 0 && data_umea.way(i).highway == 0 && data_umea.way(i).cycleway == 0%&& data_umea.way(i).bus == 0
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c11);
        else
            set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'color','k')
            
        end
        
%     elseif car == 1 && bic==0 && bus==1
%         if data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 0
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c2);
%         elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c4);
%             
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 0 x
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c5);
%         elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c6);
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c7);
%             
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c8);
%         elseif park==1 && data_umea.way(i).parking == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c10);
%         elseif  data_umea.way(i).bicycle == 0 && data_umea.way(i).highway == 0 && data_umea.way(i).cycleway == 0%&& data_umea.way(i).bus == 0
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c11);
%         else
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color','k')
%         end
        
%     elseif car == 0 && bic==1 && bus==1
%         if data_umea.way(i).cycleway == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c1);
%         elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c3);
%         elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c4);
%             
%             
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 0 x
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c5);
%         elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c6);
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 && others==1%&& data_umea.way(i).bus == 1 x
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c7);
%             
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c8);
%         elseif park==1 && data_umea.way(i).parking == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c10);
%         else
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color','k')
%         end
        
    elseif car == 1 && bic==0 %&& bus==0
        
        if data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 && others==1 %&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'color',handles.c2);
            
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 0 x
            set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'color',handles.c5);
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 && others==1%&& data_umea.way(i).bus == 1 x
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c7);
%             
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c8);
%         elseif park==1 && data_umea.way(i).parking == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c10);
%         elseif  data_umea.way(i).bicycle == 0 && data_umea.way(i).highway == 0 && data_umea.way(i).cycleway == 0%&& data_umea.way(i).bus == 0
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c11);
        else
            set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'color','k')
        end
        
    elseif car == 0 && bic==1 %&& bus==0
        if data_umea.way(i).cycleway == 1
            set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'color',handles.c1);
            
%         elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 && others==1 %&& data_umea.way(i).bus == 0
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c3);
%             
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 0 x
            set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'color',handles.c5);
%         elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c6);
%             
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c8);
%         elseif park==1 && data_umea.way(i).parking == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c10);
        else
            set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'color','k')
        end
        
%     elseif car == 0 && bic==0 && bus==1
%         
%         if data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c4);
%             
%         elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c6);
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 && others==1%&& data_umea.way(i).bus == 1 x
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c7);
%             
%         elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c8);
%         elseif park==1 && data_umea.way(i).parking == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c10);
%         else
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color','k')
%         end
        
%     elseif park == 1
%         if data_umea.way(i).parking == 1
%             set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Color',handles.c10);
%         end
    
    % Reseting line
    else
        set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'color','k')
        
    end
    if one==1 && isfield(testf,'oneline_cre') == 0;
        if data_umea.way(i).oneway == 1;
            
            set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Linewidth', 1.6, 'LineStyle', '--');
            %line2arrow(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot - i + 1))%,'LineStyle', '--');
            [~, n_ndref] = size(data_umea.way(i).ndref);
            
            
            
            c_more = c_more + 1;
            is(1,c_more)=i;
            is(2,c_more)=n_ndref;
        end
    end
%     elseif 
% 
%             
%             
%             %set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1), '*m','MarkerSize', 20)
%             %                set(line, 'LineStyle', '--');
%             %                set(line, 'Color','m') % Later on no colour
%             %             %+make sth with nodes
%             %                 if j==1 %data_umea.way(i).ndref()
%             
%             %                     plot(X(j),Y(j), '*m','MarkerSize', 20)
%             %                 end
%             
%         end
        
        
        
        
        
        
        
        
    

end    
%l_is = length(is);
%c_more;

is_park = zeros(3,10);
is_light = zeros(1,20);

countPark = 0;
countLight = 0;


n = testf.graph_data.intnd_count;


if testf.pot_cre == 0
    
    for i = 1:n %Plottar itersection nodes och f�rgl�gger dem enligt snabbaste f�rds�ttet.
        if not(isempty(data_umea.node(i).parking));
            
            countPark = countPark + 1;
            [parkinfo] = data_umea.node(i).parking;
            parkinfo1 = parkinfo(1);
            parkinfo2 = parkinfo(2);
            is_park(1,countPark) = i;
            is_park(2,countPark) = parkinfo1;
            is_park(3,countPark) = parkinfo2;  
            
            lat = graph_data.intnd(i).lat;
            lon = graph_data.intnd(i).lon;
            
            P = num2str(parkinfo1);
            P2 = num2str(parkinfo2);
            pStr = strcat('P, ',' No:', P,', SEK:', P2); 
            
            if park == 1;
                text(lon,lat, pStr , 'color', 'r')
            elseif park == 0
                text(lon,lat, pStr, 'color', 'r','Visible', 'off')
            end
            
        end
        
        if data_umea.node(i).traffic_signals == 1 
            countLight = countLight + 1;
            is_light(1,countLight) = i;
            lat = graph_data.intnd(i).lat;
            lon = graph_data.intnd(i).lon;
            
            if park == 1;
                text(lon,lat, 'T' , 'color', 'r')
            elseif park == 0
                text(lon,lat, 'T', 'color', 'r','Visible', 'off')
            end
            
        end
        
    end
    
    n_pot = countPark + countLight;
    
    testf.pot_cre = 1;
    testf.n_pot = n_pot;
    
    testf.ch = get(testf.axes1,'children');
    
    if park == 1;
        testf.pot_there = 1;
    else
        testf.pot_there = 0;
    end
    
    
    
    
else
    if park == 1 && testf.pot_there == 0;
        for i = 1:testf.n_pot
            set(testf.ch(testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Visible', 'on');
        end
        testf.pot_there = 1;

    elseif park == 0 && testf.pot_there == 1
        for i = 1:testf.n_pot
            set(testf.ch(testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Visible', 'off');
        end
        testf.pot_there = 0;
        
    end
end


% Plotting the bus lines 
lines = who(path);
n_bus = length(lines);

if testf.bus_cre == 0
    
    
    

    for i = 1:n_bus
        
        line2 = lines{i};
        
        [~,ncols] = size(busP.(line2));
        X = zeros(1,ncols);
        Y = zeros(1,ncols);
        for j = 1:ncols%ncols
            se = char(busP.(line2){j});
            
            % busP(i).(line){j})
            se2 = data_umea.node(graph_data.id_map(se)).lon;
            %class(se2);
            X(j) = se2;
            Y(j) = data_umea.node(graph_data.id_map(se)).lat;
        end
        
        
        %size(X);
        %size(Y);
        %class(X);
        
        if bus == 1;
            line('Ydata',Y,'Xdata',X, 'color', handles.c4, 'LineStyle', ':');
        elseif bus == 0
            line('Ydata',Y,'Xdata',X, 'color', handles.c4, 'LineStyle', ':', 'Visible', 'off');
        end
        %n_bus = n_bus + 1;
        
        
        %line('Ydata',Y,'Xdata',X, 'color', 'r');
    end
    
    
    
    testf.bus_cre = 1;
    testf.n_bus = n_bus;
    testf.buscol = handles.c4; % Remembering the present colour.
    
    testf.ch = get(testf.axes1,'children');
    
    if bus == 1;
        testf.bus_there = 1;
    else
        testf.bus_there = 0;
    end
    
    
    
    
else
    if bus == 1 && testf.bus_there == 0;
        for i = 1:testf.n_bus
            set(testf.ch(testf.n_one + testf.n_footways + testf.n_bus - i + 1),'Visible', 'on', 'color', handles.c4);
        end
        testf.bus_there = 1;
        testf.buscol = handles.c4;

    elseif bus == 0 && testf.bus_there == 1
        for i = 1:testf.n_bus
            set(testf.ch(testf.n_one + testf.n_footways + testf.n_bus - i + 1),'Visible', 'off');
        end
        testf.bus_there = 0;
        
    elseif bus == 1 && testf.bus_there == 1 && ~strcmp(testf.buscol, handles.c4);
        for i = 1:testf.n_bus
            set(testf.ch(testf.n_one + testf.n_footways + testf.n_bus - i + 1),'Visible', 'on', 'color', handles.c4);
        end
        testf.buscol = handles.c4;
    end
end

%Slut

if one == 0 && testf.oneline_there==1 && isfield(testf,'oneline_cre') == 1;
    for j = 1:testf.c_more
        i = testf.is(1,j);
        set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Linewidth', 0.5,'LineStyle', '-');
    end
    testf.oneline_there=0;
    
elseif one == 1 && testf.oneline_there==0 && isfield(testf,'oneline_cre') == 1;
    for j = 1:testf.c_more
        i = testf.is(1,j);
        set(testf.ch(n_ways + testf.n_one + testf.n_footways + testf.n_pot + testf.n_bus - i + 1),'Linewidth', 1.6,'LineStyle', '--');
    end
    testf.oneline_there=1;
end

if isfield(testf,'oneline_cre') == 0 && one == 1;
    testf.oneline_cre = 1;
    testf.oneline_there=1;
    testf.c_more = c_more;
    testf.is = is;
end

arrows = 0;
if handles.one_direction == 1 && isfield(testf,'one_cre') == 0;
    for j = 1:testf.c_more
        i = testf.is(1,j);    
        
        [~, n_ndref] = size(data_umea.way(i).ndref);
        start = zeros(n_ndref-1,2);
        stop = zeros(n_ndref-1,2);
        for k = 1:n_ndref-1
            start(k,1) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{k})).lon;
            start(k,2) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{k})).lat;
            stop(k,1) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{k+1})).lon;
            stop(k,2) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{k+1})).lat;
        end
        arrow('Start', start, 'Stop', stop, 'Length', 0.3 , 'LineWidth', 0.001)
        %('Ydata',Y,'Xdata',X);
        
        arrows = arrows + n_ndref - 1;

    
        
%         i = testf.is(1,j);
%         n_ndref = testf.is(2,j);
%         
%         %a=graph_data.id_map(data_umea.way(i).ndref{1});
%         X(1) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{1})).lon;
%         Y(1) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{1})).lat;
%         
%         X(2) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{n_ndref})).lon;
%         Y(2) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{n_ndref})).lat;
%         
%         plot(X(1),Y(1), '+m','MarkerSize', 10)
%         plot(X(2),Y(2), 'og','MarkerSize', 10)
        
    end
    %testf.one_dir=1;
    testf.one_cre=1;
    testf.n_one = arrows; %c_more*2;
    testf.one_there=1;
    testf.ch = get(testf.axes1,'children');
    if testf.n_footways > 0
        testf.n2_one = testf.n_one;
    end
    


elseif handles.one_direction == 0 && isfield(testf,'one_cre') == 1 && testf.one_there==1;
   
    for i = 1:testf.n_one
        set(testf.ch(testf.n2_footways + testf.n_one - i + 1),'Visible', 'off');
    end
    testf.one_there=0;
    
elseif handles.one_direction == 1 && isfield(testf,'one_cre') == 1 && testf.one_there==0;
    
    for i = 1:testf.n_one
        set(testf.ch(testf.n2_footways + testf.n_one - i + 1),'Visible', 'on');               
    end
    testf.one_there=1;
end


if handles.nonodes == 1 && isfield(testf,'nodes_manip') == 0;
    n = graph_data.intnd_count;
    for i = 1:n
        set(testf.ch(n_ways + n +testf.n_one +testf.n_footways + testf.n_pot - i + 1),'Visible', 'off');
    end
    testf.nodes_there=0;
    testf.nodes_manip=1;
    
elseif handles.nonodes == 0 && isfield(testf,'nodes_manip') == 1 && testf.nodes_there==0;
    n = graph_data.intnd_count;
    for i = 1:n
        set(testf.ch(n_ways + n +testf.n_one + testf.n_footways + testf.n_pot - i + 1),'Visible', 'on');
    end
    testf.nodes_there=1;

elseif handles.nonodes == 1 && isfield(testf,'nodes_manip') == 1 && testf.nodes_there==1;
    n = graph_data.intnd_count;
    for i = 1:n
        set(testf.ch(n_ways + n +testf.n_one + testf.n_footways + testf.n_pot - i + 1),'Visible', 'off');
    end
    testf.nodes_there=0;
       
end 

if handles.footway  == 1 && isfield(testf,'foot_cre') == 0;
         

    [~,n_footways] = size(data_umea.foot_way);%data_umea.way



    for i = 1:n_footways %Plottar v�garna mellan noderna, notera att ALLA noder anv�nds (�ven de som inte �r intersection nodes) f�r att rita ut v�garna.
        
        [~, n_ndref] = size(data_umea.foot_way(i).ndref);
        X = zeros(1,n_ndref);
        Y = zeros(1,n_ndref);
        for j = 1:n_ndref
            X(j) = data_umea.node(graph_data.id_map(data_umea.foot_way(i).ndref{j})).lon;
            Y(j) = data_umea.node(graph_data.id_map(data_umea.foot_way(i).ndref{j})).lat;
        end
        
        line('Ydata',Y,'Xdata',X,'color',handles.c9,'LineStyle', ':');
        
    end
    %testf.foot_dir=1;
    testf.foot_cre=1;
    testf.n_footways = n_footways;
    testf.foot_there=1;
    testf.ch = get(testf.axes1,'children');
    if testf.n_one > 0
        testf.n2_footways = testf.n_footways;
    end

elseif handles.footway == 0 && isfield(testf,'foot_cre') == 1 && testf.foot_there==1;
   
    for i = 1:testf.n_footways
        set(testf.ch(testf.n_footways + testf.n2_one - i + 1),'Visible', 'off');
    end
    testf.foot_there=0;
    
elseif handles.footway == 1 && isfield(testf,'foot_cre') == 1 && testf.foot_there==0;
    
    for i = 1:testf.n_one
        set(testf.ch(testf.n_footways + testf.n2_one - i + 1),'Visible', 'on');               
    end
    testf.foot_there=1;
end
    

    
    
    
    
             
testf.handlesrv=handles;
guidata(handles.test, testf);
hold off
end
 

