function plot_roads(graph_data,data_umea,handles)
%Fulskript som plottar noder och v�gar f�r att visualisera s� att debugging
%blir l�ttare.

%load('graph_data.mat','intnd_count','intnd','id_map')
%load('data_umea.mat','node','way')

[x,n_ways] = size(data_umea.way);
hold on
for i = 1:graph_data.intnd_count %Plottar itersection nodes och f�rgl�gger dem enligt snabbaste f�rds�ttet.
    lat = graph_data.intnd(i).lat;
    lon = graph_data.intnd(i).lon;
    plot(lon,lat, '.k')
end

for i = 1:n_ways %Plottar v�garna mellan noderna, notera att ALLA noder anv�nds (�ven de som inte �r intersection nodes) f�r att rita ut v�garna.
    if data_umea.way(i).footway == 0 
        [x, n_ndref] = size(data_umea.way(i).ndref);
        X = zeros(1,n_ndref);
        Y = zeros(1,n_ndref);
        for j = 1:n_ndref
            X(j) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{j})).lon;
            Y(j) = data_umea.node(graph_data.id_map(data_umea.way(i).ndref{j})).lat;
        end
        
        handles.car = 1;
        handles.bic=1;
        handles.bus=1;
        handles.footway=1;
        
        handles.c1='y';
        handles.c2='r';
        handles.c3='g';
        handles.c4=[255 178 102];%orange
        handles.c5='b';
        handles.c6='c';
        handles.c7='m';
        handles.c8=[153 76 0];%brown
        handles.c9=[128 128 128];%grey
        
        handles.one=0;
        
        
        
        %infoga bus only när finns
        
        if handles.car == 1 && handles.bic==1 && handles.bus==1
            
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
            else
                line('Ydata',Y,'Xdata',X,'Color','k')
            end        
            
        elseif handles.car == 1 && handles.bic==1 && handles.bus==0
            if data_umea.way(i).cycleway == 1
                line('Ydata',Y,'Xdata',X,'Color',handles.c1);
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 0 
                line('Ydata',Y,'Xdata',X,'Color',handles.c2);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0 
                line('Ydata',Y,'Xdata',X,'Color',handles.c3);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c5);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1 x 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c6);
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c7);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c8);
            else
                line('Ydata',Y,'Xdata',X,'Color','k')
                
            end        
                    
        elseif handles.car == 1 && handles.bic==0 && handles.bus==1
            if data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 0 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c2);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c4);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c5);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c6);
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c7);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c8);
            else
                line('Ydata',Y,'Xdata',X,'Color','k')
            end
            
        elseif handles.car == 0 && handles.bic==1 && handles.bus==1
            if data_umea.way(i).cycleway == 1
                line('Ydata',Y,'Xdata',X,'Color',handles.c1);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c3);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c4);
            
            
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c5);
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c6);
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c7);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c8);
            else
                line('Ydata',Y,'Xdata',X,'Color','k')
            end
       
        elseif handles.car == 1 && handles.bic==0 && handles.bus==0
         
            if data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 0 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c2);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0 x
                    line('Ydata',Y,'Xdata',X,'Color',handles.c);
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color','r');
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color','r');         
            else
                line('Ydata',Y,'Xdata',X,'Color','k')
            end
            
        elseif handles.car == 0 && handles.bic==1 && handles.bus==0
            if data_umea.way(i).cycleway == 1
                line('Ydata',Y,'Xdata',X,'Color',handles.c1);
            
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0 
                    line('Ydata',Y,'Xdata',X,'Color',handles.c3);
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 0 x
                    line('Ydata',Y,'Xdata',X,'Color','r');
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color','r');           
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color','r');         
            else
                line('Ydata',Y,'Xdata',X,'Color','k')
            end
            
        elseif handles.car == 0 && handles.bic==0 && handles.bus==1            
           
            if data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1 
                    line('Ydata',Y,'Xdata',X,'Color','r');                    
            
            elseif data_umea.way(i).highway == 0 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color','r');
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 0 %&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color','r');
                    
            elseif data_umea.way(i).highway == 1 && data_umea.way(i).bicycle == 1 %&& data_umea.way(i).bus == 1 x
                    line('Ydata',Y,'Xdata',X,'Color','r');         
            else
                line('Ydata',Y,'Xdata',X,'Color','k')
            end
            
            
        end
        if handles.one == 1
            set(line, 'LineStyle', '--');
            %+make sth with nodes
        end
            
            
    elseif handles.footway  == 1
        line('Ydata',Y,'Xdata',X,'Color',handles.c9,'LineStyle', ':' )
    end
    
end
hold off
