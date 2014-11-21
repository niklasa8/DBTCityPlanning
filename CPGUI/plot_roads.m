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
%handles.rv_pass=1;
%guidata(hObject, handles);

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

set(test.apple,'Value',45)
test.handlesrv=handles;
guidata(hObject, test);

guidata(hObject, handles);
%car=get(handles.car,'Value');
%car=get(handles.car,'Value');
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
        
        %car = 1;
        %car=1;
        %bus=1;
        
        
        
%         handles.c1='y';%bike alone
%         handles.c2='r';%highway
%         handles.c3='g';%bike + car not on highway
%         handles.c4=[255 178 102]/256;%orange bus + car not on highway
%         handles.c5='b';%highway bike
%         handles.c6='c';%bike bus
%         handles.c7='m';%highway bus
%         handles.c8=[153 76 0]/256;%brown highway bike bus
%         handles.c9=[128 128 128]/256;%grey; footway 
%         handles.c10=[102 0 51]/256;%purple; parking
%         handles.c11=[12 75 82]/256;%strange; car other than 
        
        
        
        %handles.one=1;
        
        
        
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
%        if one=1
%         if data_umea.way(i).oneway == 1
%             set(line, 'LineStyle', '--');
%             set(line, 'Color','m')
%             %+make sth with nodes
%             if j==1 %data_umea.way(i).ndref()
%                plot(X(j),Y(j), '.k')
                
%         end
            
            
    elseif handles.footway  == 1
        a=3
        line('Ydata',Y,'Xdata',X,'Color',handles.c9,'LineStyle', ':' )
             end
    
    end 
hold off    
end

