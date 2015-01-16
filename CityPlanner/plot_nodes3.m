function plot_nodes3(fastest_trip, handles)

generalCost = handles.generalCost;
alpha = handles.alpha;
beta = handles.beta;
parkingtime = handles.parkDef;

%handles.travBike
%handles.travBus
%handles.travCar

% agenttttt
if handles.agentOn
    load('graph_data.mat','bicycling_path','carTo_walkFrom_parking_agent','car_dist_shortest_path')
    carTo_walkFrom_parking = carTo_walkFrom_parking_agent;
else
    load('graph_data.mat','bicycling_path','carTo_walkFrom_parking','car_dist_shortest_path')
end

if generalCost
    cycleCost = handles.tvBic;
    carCost = handles.tvCar;
    parkingCost = handles.parkTic;
    milageCost = handles.carCosts/10; % Per km
        
    carTo_walkFrom_parking = alpha*carCost*carTo_walkFrom_parking + beta*parkingCost + beta*car_dist_shortest_path*milageCost;
    bicycling_path = alpha*cycleCost*bicycling_path;
    
end

node_source = handles.current_node;
[~,n_ways] = size(handles.data_umea.way);

nr = handles.n_one + handles.n_footways + handles.n_pot + handles.n_bus;
n = handles.graph_data.intnd_count;


if (handles.travBike + handles.travCar + handles.travBus) < 2
    rectangle('Position',[20.42,63.8,0.02,0.06/10],'Facecolor',[1,1,0], 'Edgecolor', 'none')
    rectangle('Position',[20.42,63.8+0.06/10*1,0.02,0.06/10],'Facecolor',[1,0.8,0], 'Edgecolor', 'none')
    rectangle('Position',[20.42,63.8+0.06/10*2,0.02,0.06/10],'Facecolor',[1,0.6,0], 'Edgecolor', 'none')
    rectangle('Position',[20.42,63.8+0.06/10*3,0.02,0.06/10],'Facecolor',[1,0.4,0], 'Edgecolor', 'none')
    rectangle('Position',[20.42,63.8+0.06/10*4,0.02,0.06/10],'Facecolor',[1,0.2,0], 'Edgecolor', 'none')
    rectangle('Position',[20.42,63.8+0.06/10*5,0.02,0.06/10],'Facecolor',[1,0,0], 'Edgecolor', 'none')
    rectangle('Position',[20.42,63.8+0.06/10*6,0.02,0.06/10],'Facecolor',[0.8,0,0], 'Edgecolor', 'none')
    rectangle('Position',[20.42,63.8+0.06/10*7,0.02,0.06/10],'Facecolor',[0.6,0,0], 'Edgecolor', 'none')
    rectangle('Position',[20.42,63.8+0.06/10*8,0.02,0.06/10],'Facecolor',[0.4,0,0], 'Edgecolor', 'none')
    rectangle('Position',[20.42,63.8+0.06/10*9,0.02,0.06/10],'Facecolor',[0.2,0,0], 'Edgecolor', 'none')

    text(20.445,63.803+0.06/10*10,'Minutes')
    text(20.445,63.803,'< 5')
    text(20.445,63.803+0.06/10*1,'5 - 10')
    text(20.445,63.803+0.06/10*2,'10 - 15')
    text(20.445,63.803+0.06/10*3,'15 - 20')
    text(20.445,63.803+0.06/10*4,'20 - 25')
    text(20.445,63.803+0.06/10*5,'25 - 30')
    text(20.445,63.803+0.06/10*6,'30 - 35')
    text(20.445,63.803+0.06/10*7,'35 - 40')
    text(20.445,63.803+0.06/10*8,'40 - 45')
    text(20.445,63.803+0.06/10*9,'> 45')
end

for i = 1:n %Plottar itersection nodes och f�rgl�gger dem enligt snabbaste f�rds�ttet.

    set(handles.ch(n_ways + nr + n - i + 1),'visible','off');
    
    if handles.travBike && handles.travCar && handles.travBus

        if carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) ~= inf
            if bicycling_path(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) < (carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) + parkingtime/60) && bicycling_path(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) < fastest_trip(i)
                set(handles.ch(n_ways + nr + n - i + 1),'color','r','visible','on');
            end
        end

        if (carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) + parkingtime/60) < bicycling_path(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) && (carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) + parkingtime/60) < fastest_trip(i)
            set(handles.ch(n_ways + nr + n - i + 1),'color','g','visible','on');
        end

        if carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) ~= inf
            if fastest_trip(i) < bicycling_path(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) && fastest_trip(i) < (carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) + parkingtime/60)
                 set(handles.ch(n_ways + nr + n - i + 1),'color','b','visible','on');
            end
        end
    elseif handles.travBike && handles.travCar
        % l�gger p� tio procent p� bilens tid
        if carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) ~= inf
            if bicycling_path(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) < (carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) + parkingtime/60)
                set(handles.ch(n_ways + nr + n - i + 1),'color','r','visible','on');
            end
        end

        if (carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) + parkingtime/60) < bicycling_path(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source)))
            set(handles.ch(n_ways + nr + n - i + 1),'color','g','visible','on');
        end
    elseif handles.travBike && handles.travBus

        if carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) ~= inf
            if bicycling_path(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) < fastest_trip(i)
                set(handles.ch(n_ways + nr + n - i + 1),'color','r','visible','on');
            end
        end

        if carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) ~= inf
            if fastest_trip(i) < bicycling_path(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source)))
                 set(handles.ch(n_ways + nr + n - i + 1),'color','b','visible','on');
            end
        end
    elseif handles.travBus && handles.travCar

        if (carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) + parkingtime/60) < fastest_trip(i)
            set(handles.ch(n_ways + nr + n - i + 1),'color','g','visible','on');
        end

        if carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) ~= inf
            if fastest_trip(i) < (carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) + parkingtime/60)
                 set(handles.ch(n_ways + nr + n - i + 1),'color','b','visible','on');
            end
        end
    elseif handles.travBus
        % PLOT endast busstider
        if fastest_trip(i) < 5/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,1,0],'visible','on');
        end
        if fastest_trip(i) > 5/60 && fastest_trip(i) < 10/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,0.8,0],'visible','on');
        end
        if fastest_trip(i) > 10/60 && fastest_trip(i) < 15/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,0.6,0],'visible','on');
        end
        if fastest_trip(i) > 15/60 && fastest_trip(i) < 20/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,0.4,0],'visible','on');
        end
        if fastest_trip(i) > 20/60 && fastest_trip(i) < 25/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,0.2,0],'visible','on');
        end
        if fastest_trip(i) > 25/60 && fastest_trip(i) < 30/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,0,0],'visible','on');
        end
        if fastest_trip(i) > 30/60 && fastest_trip(i) < 35/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[0.8,0,0],'visible','on');
        end
        if fastest_trip(i) > 35/60 && fastest_trip(i) < 40/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[0.6,0,0],'visible','on');
        end
        if fastest_trip(i) > 40/60 && fastest_trip(i) < 45/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[0.4,0,0],'visible','on');
        end
        if fastest_trip(i) > 45/60 
            set(handles.ch(n_ways + nr + n - i + 1),'color',[0.2,0,0],'visible','on');
        end
    elseif handles.travCar
        % PLOT endast biltider
        cartime = 1.1*(carTo_walkFrom_parking(i,handles.graph_data.intnd_map(handles.graph_data.id_map(node_source))) + parkingtime/60);
        
        if  cartime < 5/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,1,0],'visible','on');
        end
        if cartime > 5/60 && cartime < 10/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,0.8,0],'visible','on');
        end
        if cartime > 10/60 && cartime < 15/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,0.6,0],'visible','on');
        end
        if cartime > 15/60 && cartime < 20/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,0.4,0],'visible','on');
        end
        if cartime > 20/60 && cartime < 25/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,0.2,0],'visible','on');
        end
        if cartime > 25/60 && cartime < 30/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,0,0],'visible','on');
        end
        if cartime > 30/60 && cartime < 35/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[0.8,0,0],'visible','on');
        end
        if cartime > 35/60 && cartime < 40/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[0.6,0,0],'visible','on');
        end
        if cartime > 40/60 && cartime < 45/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[0.4,0,0],'visible','on');
        end
        if cartime > 45/60 %&& cartime < Inf
            set(handles.ch(n_ways + nr + n - i + 1),'color',[0.2,0,0],'visible','on');
        end
    elseif handles.travBike
        % PLOT endast cykeltider
        if fastest_trip(i) < 5/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,1,0],'visible','on');
        end
        if fastest_trip(i) > 5/60 && fastest_trip(i) < 10/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,0.8,0],'visible','on');
        end
        if fastest_trip(i) > 10/60 && fastest_trip(i) < 15/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,0.6,0],'visible','on');
        end
        if fastest_trip(i) > 15/60 && fastest_trip(i) < 20/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,0.4,0],'visible','on');
        end
        if fastest_trip(i) > 20/60 && fastest_trip(i) < 25/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,0.2,0],'visible','on');
        end
        if fastest_trip(i) > 25/60 && fastest_trip(i) < 30/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[1,0,0],'visible','on');
        end
        if fastest_trip(i) > 30/60 && fastest_trip(i) < 35/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[0.8,0,0],'visible','on');
        end
        if fastest_trip(i) > 35/60 && fastest_trip(i) < 40/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[0.6,0,0],'visible','on');
        end
        if fastest_trip(i) > 40/60 && fastest_trip(i) < 45/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[0.4,0,0],'visible','on');
        end
        if fastest_trip(i) > 45/60
            set(handles.ch(n_ways + nr + n - i + 1),'color',[0.2,0,0],'visible','on');
        end
    end
    
end

end
