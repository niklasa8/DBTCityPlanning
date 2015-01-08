function fastest_trip = busTest2(node_source,graph_data,time,day,generalCost,alphaPar,betaPar)
%% R�knar ut snabbaste v�gen

load('Data/bus_stop_nodes');
load('Data/walkTo_bs');
load('Departures.mat')

walkCost = 1;
busCost = 1;
ticketCost = 0;
alpha = 1;
beta = 0;

% Om generellkostnad anv�nds
if generalCost
	walkCost = 135;
	busCost = 33;
	ticketCost = 25;
    alpha = aplhaPar;
    beta = betaPar;
end
	

%dest = intnd_map(id_map('444493179'));
%t = 800; %i och t �r 
%d = 1; % Dag: 1(M�n-Tors),2(Fre),3(L�r),4(S�n)

dest = graph_data.intnd_map(graph_data.id_map(node_source));
t = time; %i och t �r 
%%dagar d = 1; Dag: 1(M�n-Tors),2(Fre),3(L�r),4(S�n)
if strcmp(day,'Monday') || strcmp(day,'Tuesday') || strcmp(day,'Wednesday') || strcmp(day,'Thursday')
    d = 1;
elseif strcmp(day,'Friday')
    d = 2;
elseif strcmp(day,'Saturday')
    d = 3;
elseif strcmp(day,'Sunday')
    d = 4;
end

% If time is between 00:00-04:00, shift to end of previous day 
if t>=0 & t<=240
    
    if strcmp(day,'Friday') || strcmp(day,'Saturday') || strcmp(day,'Sunday')
        d = d-1;
    end
    if strcmp(day,'Monday')
       d = 4; 
    end
    t = t + 1200;
else
    t = t - 240;
end

limit_walk = 20; %Algoritmen r�knar inte ut hur l�ng tid det tar att ta sig fr�n en plats till en annan med buss om det tar �verdrivet l�ng tid att g� till bussh�llplatsen.  
fastest_trip = inf(graph_data.intnd_count,1);
n_stops = max(size(bus_stop_nodes));

for j = 1:n_stops %Loop �ver alla slutstationer.
    
    if walkTo_bs(dest,j) > limit_walk
        continue;
    end
    
    times = allToOne(Dep,j,d,int32(t-walkTo_bs(dest,j)),n_stops);

    for k = 1:n_stops %Loop �ver alla startstationer.
                
        trip_plus_wait_time = times(k) + int32(walkTo_bs(:,k)) + int32(walkTo_bs(dest,j));
        disp('busTest2')
        disp(size(trip_plus_wait_time))
        disp(size(fastest_trip))
        idx = find(trip_plus_wait_time < fastest_trip);
        
        fastest_trip(idx) = trip_plus_wait_time(idx);
        
    end
end

fastest_trip = (alpha*busCost*fastest_trip)/60 + beta*ticketCost;
%Denna del r�knar ut snabbaste v�gen att ta sig fr�n alla noder till i med buss. 
end