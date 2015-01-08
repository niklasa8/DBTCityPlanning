function fastest_trip = busTest2(node_source,graph_data,time,day,generalCost,alphaPar,betaPar)
%% Räknar ut snabbaste vägen

load('Data/bus_stop_nodes');
load('Data/walkTo_bs');
load('Departures.mat')

walkCost = 1;
busCost = 1;
ticketCost = 0;
alpha = 1;
beta = 0;

% Om generellkostnad används
if generalCost
	walkCost = 135;
	busCost = 33;
	ticketCost = 25;
    alpha = aplhaPar;
    beta = betaPar;
end
	

%dest = intnd_map(id_map('444493179'));
%t = 800; %i och t är 
%d = 1; % Dag: 1(Mån-Tors),2(Fre),3(Lör),4(Sön)

dest = graph_data.intnd_map(graph_data.id_map(node_source));
t = time; %i och t är 
%%dagar d = 1; Dag: 1(Mån-Tors),2(Fre),3(Lör),4(Sön)
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

limit_walk = 20; %Algoritmen räknar inte ut hur lång tid det tar att ta sig från en plats till en annan med buss om det tar överdrivet lång tid att gå till busshållplatsen.  
fastest_trip = inf(graph_data.intnd_count,1);
n_stops = max(size(bus_stop_nodes));

for j = 1:n_stops %Loop över alla slutstationer.
    
    if walkTo_bs(dest,j) > limit_walk
        continue;
    end
    
    times = allToOne(Dep,j,d,int32(t-walkTo_bs(dest,j)),n_stops);

    for k = 1:n_stops %Loop över alla startstationer.
                
        trip_plus_wait_time = times(k) + int32(walkTo_bs(:,k)) + int32(walkTo_bs(dest,j));
        disp('busTest2')
        disp(size(trip_plus_wait_time))
        disp(size(fastest_trip))
        idx = find(trip_plus_wait_time < fastest_trip);
        
        fastest_trip(idx) = trip_plus_wait_time(idx);
        
    end
end

fastest_trip = (alpha*busCost*fastest_trip)/60 + beta*ticketCost;
%Denna del räknar ut snabbaste vägen att ta sig från alla noder till i med buss. 
end