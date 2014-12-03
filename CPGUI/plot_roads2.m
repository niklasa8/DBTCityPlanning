function handles=plot_roads2(hObject,handles)
testf = guidata(handles.test);
data_umea=testf.data_umea;
graph_data=testf.graph_data;
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


[handles.c1,handles.cont1]=color_pop(hObject,handles,handles.pop1);
[handles.c2,handles.cont2]=color_pop(hObject,handles,handles.pop2);
[handles.c3,handles.cont3]=color_pop(hObject,handles,handles.pop3);
[handles.c4,handles.cont4]=color_pop(hObject,handles,handles.pop4);
[handles.c5,handles.cont5]=color_pop(hObject,handles,handles.pop5);
[handles.c6,handles.cont6]=color_pop(hObject,handles,handles.pop6);
[handles.c7,handles.cont7]=color_pop(hObject,handles,handles.pop7);
[handles.c8,handles.cont8]=color_pop(hObject,handles,handles.pop8);
[handles.c9,handles.cont9]=color_pop(hObject,handles,handles.pop9);
[handles.c10,handles.cont10]=color_pop(hObject,handles,handles.pop10);
[handles.c11,handles.cont11]=color_pop(hObject,handles,handles.pop11);



[~,n_ways] = size(data_umea.way);
hold on

is = zeros(2,458);
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
    
    if car == 1 && bic==1 && bus==1
        
        if data_umea.way(i).cycleway == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c1);
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c2);
        elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c3);
        elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c4);
            
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c5);
        elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c6);
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c7);
            
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c8);
        elseif handles.parking==1 && data_umea.way(i).parking == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c10);
        elseif data_umea.way(i).parking == 0 && data_umea.way(i).bicycle == 0 && data_umea.way(i).highway == 0 && data_umea.way(i).cycleway == 0%&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c11);
        else
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color','k');
        end
        
    elseif car == 1 && bic==1 && bus==0
        if data_umea.way(i).cycleway == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c1);
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c2);
        elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c3);
            
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c5);
        elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 && others==1 %&& data_umea.way(i).bus == 1 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c6);
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 && others==1%&& data_umea.way(i).bus == 1 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c7);
            
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c8);
        elseif park==1 && data_umea.way(i).parking == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c10);
        elseif data_umea.way(i).parking == 0 && data_umea.way(i).bicycle == 0 && data_umea.way(i).highway == 0 && data_umea.way(i).cycleway == 0%&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c11);
        else
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color','k')
            
        end
        
    elseif car == 1 && bic==0 && bus==1
        if data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c2);
        elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c4);
            
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 0 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c5);
        elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c6);
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c7);
            
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c8);
        elseif park==1 && data_umea.way(i).parking == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c10);
        elseif data_umea.way(i).parking == 0 && data_umea.way(i).bicycle == 0 && data_umea.way(i).highway == 0 && data_umea.way(i).cycleway == 0%&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c11);
        else
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color','k')
        end
        
    elseif car == 0 && bic==1 && bus==1
        if data_umea.way(i).cycleway == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c1);
        elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c3);
        elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c4);
            
            
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 0 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c5);
        elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c6);
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 && others==1%&& data_umea.way(i).bus == 1 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c7);
            
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c8);
        elseif park==1 && data_umea.way(i).parking == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c10);
        else
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color','k')
        end
        
    elseif car == 1 && bic==0 && bus==0
        
        if data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 && others==1 %&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c2);
            
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 0 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c);
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 && others==1%&& data_umea.way(i).bus == 1 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color','r');
            
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color','r');
        elseif park==1 && data_umea.way(i).parking == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c10);
        elseif data_umea.way(i).parking == 0 && data_umea.way(i).bicycle == 0 && data_umea.way(i).highway == 0 && data_umea.way(i).cycleway == 0%&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c11);
        else
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color','k')
        end
        
    elseif car == 0 && bic==1 && bus==0
        if data_umea.way(i).cycleway == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c1);
            
        elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 && others==1 %&& data_umea.way(i).bus == 0
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c3);
            
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 0 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c5);
        elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c6);
            
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c8);
        elseif park==1 && data_umea.way(i).parking == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c10);
        else
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color','k')
        end
        
    elseif car == 0 && bic==0 && bus==1
        
        if data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c4);
            
        elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c6);
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 && others==1%&& data_umea.way(i).bus == 1 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c7);
            
        elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c8);
        elseif park==1 && data_umea.way(i).parking == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c10);
        else
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color','k')
        end
        
    elseif park == 1
        if data_umea.way(i).parking == 1
            set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c10);
        end
        
        
    end
    if one==1
        if data_umea.way(i).oneway == 1
            
            set(testf.ch(n_ways + testf.n_one - i + 1),'LineStyle', '--');
            
            [~, n_ndref] = size(data_umea.way(i).ndref);
            
            
            
            c_more = c_more + 1;
            is(1,c_more)=i;
            is(2,c_more)=n_ndref;
            
            
            %set(testf.ch(n_ways + testf.n_one - i + 1), '*m','MarkerSize', 20)
            %                set(line, 'LineStyle', '--');
            %                set(line, 'Color','m') % Later on no colour
            %             %+make sth with nodes
            %                 if j==1 %data_umea.way(i).ndref()
            
            %                     plot(X(j),Y(j), '*m','MarkerSize', 20)
            %                 end
            
        end
        
        
        
        
        
        
        
        
    end

end    
l_is = length(is);
if handles.one_direction == 1 && isfield(testf,'one_cre') == 0;
    for j = 1:l_is
        
        i = is(1,j);
        n_ndref = is(2,j);
        
        
        X(1) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{1})).lon;
        Y(1) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{1})).lat;
        
        X(2) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{n_ndref})).lon;
        Y(2) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{n_ndref})).lat;
        
        plot(X(1),Y(1), '+m','MarkerSize', 10)
        plot(X(2),Y(2), 'og','MarkerSize', 10)
        
    end
    testf.one_dir=1;
    testf.one_cre=1;
    testf.n_one = c_more*2;
    testf.one_there=1;
    testf.ch = get(testf.axes1,'children');

elseif handles.one_direction == 0 && isfield(testf,'one_cre') == 1 && testf.one_there==1;
   
    for i = 1:testf.n_one
        set(testf.ch(testf.n_one - i + 1),'Visible', 'off');
    end
    set(testf.one_there,'Value',0);
    
elseif handles.one_direction == 1 && isfield(testf,'one_cre') == 1 && testf.one_there==0;
    
    for i = 1:testf.n_one
        set(testf.ch(testf.n_one - i + 1),'Visible', 'on');               
    end
    set(testf.one_there,'Value',1);
end

% elseif handles.footway  == 1
%         a=3
%         set(testf.ch(n_ways + testf.n_one - i + 1),'Color',handles.c9,'LineStyle', ':' )

if handles.nonodes == 1 && isfield(testf,'nodes_manip') == 0;
    n = graph_data.intnd_count;
    for i = 1:n
        set(testf.ch(n_ways + n +testf.n_one - i + 1),'Visible', 'off');
    end
    testf.nodes_there=0;
    testf.nodes_manip=1;
    
elseif handles.nonodes == 0 && isfield(testf,'nodes_manip') == 1 && testf.nodes_there==0;
    n = graph_data.intnd_count;
    for i = 1:n
        set(testf.ch(n_ways + n +testf.n_one - i + 1),'Visible', 'on');
    end
    set(testf.nodes_there,'Value',1);

elseif handles.nonodes == 1 && isfield(testf,'nodes_manip') == 1 && testf.nodes_there==1;
    n = graph_data.intnd_count;
    for i = 1:n
        set(testf.ch(n_ways + n +testf.n_one - i + 1),'Visible', 'off');
    end
    set(testf.nodes_there,'Value',0);
       
end 
    

    
testf.handlesrv=handles;
guidata(handles.test, testf);
hold off
end 

