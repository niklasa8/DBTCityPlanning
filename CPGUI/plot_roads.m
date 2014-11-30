function handles=plot_roads(hObject,handles)
test = guidata(handles.test);
data_umea=test.data_umea;
graph_data=test.graph_data;
axes(test.axes1)
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


test.handlesrv=handles;
guidata(handles.test, test);


%Fulskript som plottar noder och v�gar f�r att visualisera s� att debugging
%blir l�ttare.

%load('graph_data.mat','intnd_count','intnd','id_map')
%load('data_umea.mat','node','way')

[x,n_ways] = size(data_umea.way);
hold on
% for i = 1:graph_data.intnd_count %Plottar itersection nodes och f�rgl�gger dem enligt snabbaste f�rds�ttet.
%     lat = graph_data.intnd(i).lat;
%     lon = graph_data.intnd(i).lon;
    %plot(lon,lat, '.k')
%end

for i = 1:n_ways %Plottar v�garna mellan noderna, notera att ALLA noder anv�nds (�ven de som inte �r intersection nodes) f�r att rita ut v�garna.
    if data_umea.way(i).footway == 0 
        [x, n_ndref] = size(data_umea.way(i).ndref);
        X = zeros(1,n_ndref);
        Y = zeros(1,n_ndref);
        for j = 1:n_ndref
            X(j) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{j})).lon;
            Y(j) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{j})).lat;
        end
        
        
        
        
        %infoga bus only när finns
        
        if car == 1 && bic==1 && bus==1
            
            if data_umea.way(i).cycleway == 1
                line('Ydata',Y,'Xdata',X,'Color',handles.c1);
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 0 
                line('Ydata',Y,'Xdata',X,'Color',handles.c2);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0 
                line('Ydata',Y,'Xdata',X,'Color',handles.c3);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1 
                line('Ydata',Y,'Xdata',X,'Color',handles.c4);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0 
                line('Ydata',Y,'Xdata',X,'Color',handles.c5);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1 
                line('Ydata',Y,'Xdata',X,'Color',handles.c6);
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1 
                line('Ydata',Y,'Xdata',X,'Color',handles.c7);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1 
                line('Ydata',Y,'Xdata',X,'Color',handles.c8);
            elseif handles.parking==1 && data_umea.way(i).parking == 1 
                line('Ydata',Y,'Xdata',X,'Color',handles.c10);
            elseif data_umea.way(i).parking == 0 && data_umea.way(i).bicycle == 0 && data_umea.way(i).highway == 0 && data_umea.way(i).cycleway == 0%&& data_umea.way(i).bus == 0
                line('Ydata',Y,'Xdata',X,'Color',handles.c11);
            else
                line('Ydata',Y,'Xdata',X,'Color','k');
            end        
            
        elseif car == 1 && bic==1 && bus==0
            if data_umea.way(i).cycleway == 1
                line('Ydata',Y,'Xdata',X,'Color',handles.c1);
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 0 
                line('Ydata',Y,'Xdata',X,'Color',handles.c2);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0 
                line('Ydata',Y,'Xdata',X,'Color',handles.c3);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c5);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 && others==1 %&& data_umea.way(i).bus == 1 x 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c6);
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 && others==1%&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c7);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c8);
            elseif park==1 && data_umea.way(i).parking == 1 
                line('Ydata',Y,'Xdata',X,'Color',handles.c10);
            elseif data_umea.way(i).parking == 0 && data_umea.way(i).bicycle == 0 && data_umea.way(i).highway == 0 && data_umea.way(i).cycleway == 0%&& data_umea.way(i).bus == 0
                line('Ydata',Y,'Xdata',X,'Color',handles.c11);
            else
                line('Ydata',Y,'Xdata',X,'Color','k')
                
            end        
                    
        elseif car == 1 && bic==0 && bus==1
            if data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 0 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c2);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c4);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 0 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c5);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c6);
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c7);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c8);
            elseif park==1 && data_umea.way(i).parking == 1 
                line('Ydata',Y,'Xdata',X,'Color',handles.c10);
            elseif data_umea.way(i).parking == 0 && data_umea.way(i).bicycle == 0 && data_umea.way(i).highway == 0 && data_umea.way(i).cycleway == 0%&& data_umea.way(i).bus == 0
                line('Ydata',Y,'Xdata',X,'Color',handles.c11);
            else
                line('Ydata',Y,'Xdata',X,'Color','k')
            end
            
        elseif car == 0 && bic==1 && bus==1
            if data_umea.way(i).cycleway == 1
                line('Ydata',Y,'Xdata',X,'Color',handles.c1);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c3);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c4);
            
            
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 0 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c5);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c6);
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 && others==1%&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c7);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c8);
            elseif park==1 && data_umea.way(i).parking == 1 
                line('Ydata',Y,'Xdata',X,'Color',handles.c10);
            else
                line('Ydata',Y,'Xdata',X,'Color','k')
            end
       
        elseif car == 1 && bic==0 && bus==0
         
            if data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 && others==1 %&& data_umea.way(i).bus == 0 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c2);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 0 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c);
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 && others==1%&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color','r');
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color','r');         
            elseif park==1 && data_umea.way(i).parking == 1 
                line('Ydata',Y,'Xdata',X,'Color',handles.c10);
            elseif data_umea.way(i).parking == 0 && data_umea.way(i).bicycle == 0 && data_umea.way(i).highway == 0 && data_umea.way(i).cycleway == 0%&& data_umea.way(i).bus == 0
                line('Ydata',Y,'Xdata',X,'Color',handles.c11);
            else
                line('Ydata',Y,'Xdata',X,'Color','k')
            end
            
        elseif car == 0 && bic==1 && bus==0
            if data_umea.way(i).cycleway == 1
                line('Ydata',Y,'Xdata',X,'Color',handles.c1);
            
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 && others==1 %&& data_umea.way(i).bus == 0 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c3);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 0 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c5);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c6);           
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c8);         
            elseif park==1 && data_umea.way(i).parking == 1 
                line('Ydata',Y,'Xdata',X,'Color',handles.c10);
            else
                line('Ydata',Y,'Xdata',X,'Color','k')
            end
            
        elseif car == 0 && bic==0 && bus==1            
           
            if data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c4);                    
            
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c6);
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 && others==1%&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c7);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 && others==1%&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c8);         
            elseif park==1 && data_umea.way(i).parking == 1 
                line('Ydata',Y,'Xdata',X,'Color',handles.c10);
            else
                line('Ydata',Y,'Xdata',X,'Color','k')
            end
         
        elseif park == 1
            if data_umea.way(i).parking == 1
                line('Ydata',Y,'Xdata',X,'Color',handles.c10);
            end
            
            
        end
        if one==1
            if data_umea.way(i).oneway == 1
                line('Ydata',Y,'Xdata',X,'LineStyle', '--');
%                set(line, 'LineStyle', '--');
%                set(line, 'Color','m') % Later on no colour
%             %+make sth with nodes
                if j==1 %data_umea.way(i).ndref()
                    plot(X(j),Y(j), '*k','MarkerSize', 20)
                end
                
            end
        end     
            
            
    elseif handles.footway  == 1
        a=3
        line('Ydata',Y,'Xdata',X,'Color',handles.c9,'LineStyle', ':' )
             
    
    end 
hold off    
end

