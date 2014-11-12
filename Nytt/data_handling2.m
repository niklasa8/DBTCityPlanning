%Script som läser in data från en exporterad Open street map fil och sparar 
%relevant data. Det är OSMs overpass API som används.

clear all
file = fopen('Umea'); %Öpnna OSM filen
node_count = 0;
way_count = 0;
pknd_count = 0;
A = fgets(file); %Läs in första raden
map_created = 0;

while ischar(A) %Förstsätt läsa in rader tills allt har lästs in.
    if norm(size(A)) < 7
        A = fgets(file); %Om raden som lästs in är mindre än 7 tecken lång innehåller den inget som är av intresse.
        continue;
    end
    if strcmp(A(4:7),'node') %Om raden som lästs in hör till en nod skall informationen om nodens ID och koordinater sparas.
        node_count = node_count + 1;
        node(node_count).waynd = 0;
        node(node_count).traffic_signals = 0;
        node(node_count).traffic_calming = 0;
        node(node_count).name = 0;
        node(node_count).parking = 0;
        node(node_count).intnd = 0;
        node(node_count).bus_stop = 0;
        id_index = findstr(A,'"');
        node(node_count).id = A((id_index(1)+1):(id_index(2)-1));
        lat_index = findstr(A,'lat="');
        node(node_count).lat = str2double(A((lat_index+5):(lat_index+14)));
        lon_index = findstr(A,'lon="');
        node(node_count).lon = str2double(A((lon_index+5):(lon_index+14)));

        if A(end-2)~='/'
            A = fgets(file);
            while strcmp(A(4:8),'/node')==0
                index = strfind(A,'"');
                k = A((index(1)+1):(index(2)-1)); %k - key, vilken typ av tag som anges. T.ex. "highway" anger att kanten är en väg.
                v = A((index(3)+1):(index(4)-1)); %v - value, vilket värde taggen har. T.ex. "motorway" anger vilken typ av väg kanten är.

                if strcmp(v,'traffic_signals')
                    node(node_count).traffic_signals = 1;
                end
                
                if strcmp(k,'traffic_calming')
                    node(node_count).traffic_calming = 1;
                end
                
                if strcmp(k,'name')
                    node(node_count).name = v;
                end
                
                A = fgets(file);
            end
        end
    end
    
    if strcmp(A(4:6),'way') %Om raden som lästs in är en kant skall information om kanten sparas.
        
        if map_created == 0 %När 'way' lästs in första gången är alla noder inlästa och då skapas en map (?) för noderna. id_map returnerar nodens nummer i grafen, och inparametern till id_map är nodens globala OSM ID.
            id_map = containers.Map({node.id},1:node_count);
            map_created = 1; %Mappen skall inte skapas igen om den redan är skapad.
            node(id_map('613495002')).bus_stop = 1; %Busshållplatser läggs in manuellt.
            node(id_map('1917895812')).bus_stop = 1;
            node(id_map('301142256')).bus_stop = 1;
            node(id_map('282252233')).bus_stop = 1;
            node(id_map('2076294631')).bus_stop = 1;
            node(id_map('283324062')).bus_stop = 1;
            node(id_map('301742816')).bus_stop = 1;
            node(id_map('334746087')).bus_stop = 1;
            node(id_map('2075347365')).bus_stop = 1;
            node(id_map('182858864')).bus_stop = 1;
            node(id_map('613494992')).bus_stop = 1;
            node(id_map('260642516')).bus_stop = 1;
            node(id_map('25478281')).bus_stop = 1;
            node(id_map('291140580')).bus_stop = 1;
            node(id_map('153193859')).bus_stop = 1;
            node(id_map('2087751643')).bus_stop = 1;
            node(id_map('1614952475')).bus_stop = 1;
            node(id_map('153189435')).bus_stop = 1;
            node(id_map('1231595034')).bus_stop = 1;
            node(id_map('1286288144')).bus_stop = 1;
            node(id_map('1542779917')).bus_stop = 1;
            node(id_map('2561598361')).bus_stop = 1;
            node(id_map('274741674')).bus_stop = 1;
            node(id_map('1946746474')).bus_stop = 1;
            node(id_map('2043054425')).bus_stop = 1;
            node(id_map('1983283008')).bus_stop = 1;
            node(id_map('158587486')).bus_stop = 1;
        end
        
        way_count = way_count + 1;
        id_index = findstr(A,'"');
        way(way_count).id = A((id_index(1)+1):(id_index(2)-1)); %Läs in vägens ID och spara.
        ndref_count = 0; %Antalet node referenser, mao hur många noder som är kopplade till kanten.
        way(way_count).highway = 0; %Parameter som anger om kanten skall sparas efter att all information om kanten lästs in. T.ex. skall kanten inte sparas om den hör till en byggnad eller tågräls.
        way(way_count).maxspeed = 30;
        way(way_count).bicycle = 1;
        way(way_count).oneway = 0;
        way(way_count).parking = 0;
        way(way_count).cycleway = 0;
        way(way_count).footway = 0;
        
        A = fgets(file);
        
        while (strcmp(A(4:7),'/way')==0)
            
            ndref_count = ndref_count + 1;
            id_index = findstr(A,'"');
            way(way_count).ndref{ndref_count} = A((id_index(1)+1):(id_index(2)-1)); %Läser in och sprar vilka noder som hör till kanten.
            
            A = fgets(file);
            
            if strcmp(A(4:7),'/way') && way(way_count).highway == 0 %Om raden som lästs in innehåller '/way' betyder detta att alla taggar är inlästa och då skall kanten tas bort om den inte innehåller information som behövs.
                way(way_count) = [];
                way_count = way_count - 1;
            end
                
            while strcmp(A(6:8),'tag') %Läser in alla taggar som hör till kanten.
                
                index = strfind(A,'"');
                k = A((index(1)+1):(index(2)-1)); %k - key, vilken typ av tag som anges. T.ex. "highway" anger att kanten är en väg.
                v = A((index(3)+1):(index(4)-1)); %v - value, vilket värde taggen har. T.ex. "motorway" anger vilken typ av väg kanten är.
                
                if (strcmp(k,'bicycle')*strcmp(v,'no'))
                    way(way_count).bicycle = 0;
                end
                
                if strcmp(k,'maxspeed')
                    way(way_count).maxspeed = str2double(v);
                end
                
                if strcmp(k,'oneway')
                    way(way_count).oneway = 1;
                end
                
                if strcmp(k,'amenity') && strcmp(v,'parking')
                    way(way_count).parking = 1;
                end
                
                if (strcmp(k,'highway')) %Endast kanter som är vägar skall sparas.
                    way(way_count).highway = 1;
                end
                
                if (strcmp(k,'highway')*strcmp(v,'track')) || (strcmp(k,'highway')*strcmp(v,'path')) || (strcmp(k,'highway')*strcmp(v,'footway')) || (strcmp(k,'highway')*strcmp(v,'pedestrian')) || (strcmp(k,'highway')*strcmp(v,'platform')) %Kanter där man inte kan köra bil och/eller cykel skall inte sparas.
                    way(way_count).highway = 0;
                end
                
                if (strcmp(k,'highway')*strcmp(v,'cycleway'))
                    way(way_count).cycleway = 1;
                end
                
                A = fgets(file);
                
                if strcmp(A(4:7),'/way') && way(way_count).highway == 0 && way(way_count).parking == 0 %Om raden som lästs in innehåller '/way' betyder detta att alla taggar är inlästa och då skall kanten tas bort om den inte innehåller information som behövs.
                    way(way_count) = [];
                    way_count = way_count - 1;
                end
            end
        end
    end
    
    A = fgets(file);
end

for i = 1:way_count
    [x n_ndref] = size(way(i).ndref);
    if way(i).parking == 0
        for j = 1:n_ndref
            node(id_map(way(i).ndref{j})).waynd = node(id_map(way(i).ndref{j})).waynd + 1;
        end
    end
end

for i = 1:way_count
    [x n_ndref] = size(way(i).ndref);
    if way(i).parking == 1
        for j = 1:n_ndref
            if node(id_map(way(i).ndref{j})).waynd > 0
                node(id_map(way(i).ndref{j})).parking = 1;
                pknd_count = pknd_count + 1;
                park_nodes(pknd_count) = id_map(way(i).ndref{j});
                way(i).parking = 0;
            end
        end
    end
end

fclose(file);
config_graph = 0;
save('data_umea.mat','node','way','id_map','park_nodes','config_graph')