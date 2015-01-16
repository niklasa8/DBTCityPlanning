function fastest_trip = busTime(handles,time)
%% Räknar ut snabbaste vägen från en nod till alla andra när man reser med buss
% In:   node_source - destinationsnod
%       grap_data - datafil 
%       time - minut på dygnet[0-1440]
%       day - sträng, ex 'Monday'
%       generalCost - 1 om snabbast resan ska ta hänsyn till generell
%                     kostnad, annars 0.
%       alphaPar - Tidsberoende för generell kostnad, intervall [0,1]. Om
%                  generalCost=0, alphaPar = 1.
%       betaPar - Kostnadsberoende för generell kostnad. Om
%                 generalCost=0, betaPar = 0.
% Ut:   fastest_trip - Vektor innehållande restider från alla noder till
%                      destinationsnoden. Varje element motsvarar en
%                      busshållplats, vilken nod varje index svarar mot
%                      finns i busMapInt.

load('graph_data.mat','walk_all_shortest_path')
load('Data/bus_stop_nodes');
load('Data/busMapInt')
load('Departures.mat')


node_source = handles.current_node;
graph_data = handles.graph_data;
day = handles.current_day;
generalCost = handles.generalCost;
alphaPar = handles.alpha;
betaPar = handles.beta;

% Läs in busnoder
for i=1:175
    bus_stop_nodes(i) = graph_data.intnd_map(graph_data.id_map(num2str(busMapInt(i)))); 
end

% Snabbaste vägen att gå från godtycklig nod till alla busshållplatser.
walkTo_bs = walk_all_shortest_path(:,bus_stop_nodes)*60; 

% Parametrar om inte generell kostnad används
busCost = 1;
ticketCost = 0;
alpha = 1;
beta = 0;

% Om generellkostnad används
if generalCost
	busCost = handles.tvBus;
	ticketCost = handles.busTic;
    alpha = alphaPar;
    beta = betaPar;
end


dest = graph_data.intnd_map(graph_data.id_map(node_source));
t = time;  
% Dag: 1(Mån-Tors),2(Fre),3(Lör),4(Sön)
if strcmp(day,'Monday') || strcmp(day,'Tuesday') || strcmp(day,'Wednesday') || strcmp(day,'Thursday')
    d = 1;
elseif strcmp(day,'Friday')
    d = 2;
elseif strcmp(day,'Saturday')
    d = 3;
elseif strcmp(day,'Sunday')
    d = 4;
end

% Om angiven tid för ankomst är mellan 00:00-04:00, skifta tid till slutet
% på föregående dag. 
dayChange = 0;
if t>=0 & t<=240    
    if strcmp(day,'Friday') || strcmp(day,'Saturday') || strcmp(day,'Sunday')
        d = d-1;
    end
    if strcmp(day,'Monday')
       d = 4; 
    end
    t = t + 1200;
    dayChange = 1;
else
    t = t - 240;
end

limit_walk = 20; %Algoritmen räknar inte ut hur lång tid det tar att ta sig från en plats till en annan med buss om det tar överdrivet lång tid att gå till busshållplatsen.  
fastest_trip = inf(graph_data.intnd_count,1);
n_stops = max(size(bus_stop_nodes));

for j = 1:n_stops %Loop över alla slutstationer.
    
    % Om gångtid till dsetinations-hållplats är längre än 20 min, ignorera hållplats
    if walkTo_bs(dest,j) > limit_walk
        continue; 
    end
    
    atBusstop = int32(t-walkTo_bs(dest,j));   % Tid när man anländer till busshållplats

    % Om man är framme vid sluthållplats dagen före, ändra dag och minut.
    tempDay = d;
    if atBusstop <= 0
        if dayChange % Om dygnsbyte skett tidigare  
            if strcmp(day,'Saturday') || strcmp(day,'Sunday') || strcmp(day,'Monday')
                tempDay = d-1;
            end
            if strcmp(day,'Tuesday')
               tempDay = 4; 
            end         
        else
            if strcmp(day,'Friday') || strcmp(day,'Saturday') || strcmp(day,'Sunday')
                tempDay = d-1;
            end
            if strcmp(day,'Monday')
               tempDay = 4; 
            end
        end
        atBusstop = 1440 + atBusstop;
    end

    % Beräkna restider
    times = allToOne(Dep,j,tempDay,atBusstop,n_stops);

    for k = 1:n_stops %Loop över alla startstationer.
        if j == k
            continue;
        end
        
        % Restid: gå till starthållplats, åk buss, gå till slutdestination
        trip_plus_wait_time = times(k) + int32(walkTo_bs(:,k)) + int32(walkTo_bs(dest,j));
        idx = find(trip_plus_wait_time < fastest_trip);        
        fastest_trip(idx) = trip_plus_wait_time(idx);
        
    end
end

fastest_trip = (alpha*busCost*fastest_trip)/60 + beta*ticketCost;
end