%Script som läser in data från en exporterad Open street map fil och sparar 
%relevant data. Det är OSMs overpass API som används.

clear all
file = fopen('Umea3'); %Öpnna OSM filen
node_count = 0;
way_count = 0;
n_footways = 0;
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
        node(node_count).parking = [];
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
      
            % Läs in busshållplatsnoder från textfil och tagga nod som bushållplats.
            file_id=fopen('sorted_data_tabbed.txt', 'r', 'n', 'UTF-8');
            Bu=fgetl(file_id);
            while ~feof(file_id)
                Bu=fgetl(file_id);
                Bu=strsplit(Bu, '\t');
                node(id_map(char(Bu(end)))).bus_stop = 1;
            end
            fclose(file_id);
            
            park_nodes = [id_map('1775408093'),id_map('263187598'),...
                id_map('1775408070'),id_map('1297207752'),...
                id_map('318078744'),id_map('305950651'),...
                id_map('260642814'),id_map('295216769'),...
                id_map('181289601'),id_map('1350644029'),...
                id_map('263186106'),id_map('3098329272'),...
                id_map('286071667'),id_map('1638870005'),...
                id_map('1401945196'),id_map('344683555'),...
                id_map('247782748'),id_map('286595924'),...
                id_map('1638870005'),id_map('1401945196'),...
                id_map('344683555'),id_map('247782748'),...
                id_map('286595924'),id_map('287777665'),...
                id_map('2408111036'),id_map('269009712'),...
                id_map('624184604'),id_map('286378645'),...
                id_map('262875477'),id_map('1283370137'),...
                id_map('3098329274'),id_map('1025732368'),...
            id_map('305941849'),...
            id_map('3098329537'),...
            id_map('1568235704'),...
            id_map('151216586'),...
            id_map('262218353'),...
            id_map('1301275265'),...
            id_map('297623713'),...
            id_map('297623761'),...
            id_map('2561598512'),...
            id_map('1058150029'),...
            id_map('1058150209'),...
            id_map('1058150606'),...
            id_map('2378410241'),...
            id_map('1021025238'),...
            id_map('1021025212'),...
            id_map('3098334657'),...
            id_map('1021025142'),...
            id_map('1117598050'),...
            id_map('286166079'),...
            id_map('1021025215'),...
            id_map('283315384'),...
            id_map('262217683'),...
            id_map('2377367964'),...
            id_map('1095001958')];
            
            node(id_map('1775408093')).parking = [400 6 0];
            node(id_map('263187598')).parking = [30 7 0];
            node(id_map('1775408070')).parking = [54 6 0];
            node(id_map('1297207752')).parking = [345 10 0];
            node(id_map('318078744')).parking = [23 6 0];
            node(id_map('305950651')).parking = [50 10 0];
            node(id_map('260642814')).parking = [800 7 0];
            node(id_map('295216769')).parking = [394 6 0];
            node(id_map('181289601')).parking = [29 18 0];
            node(id_map('1350644029')).parking = [374 18 0];
            node(id_map('263186106')).parking = [272 18 0];
            node(id_map('3098329272')).parking = [131 19 0];
            node(id_map('286071667')).parking = [96 7 0];
            node(id_map('286123614')).parking = [25 7 0];
            node(id_map('1638870005')).parking = [35 7 0];
            node(id_map('1401945196')).parking = [58 20 0];
            node(id_map('344683555')).parking = [86 18 0];
            node(id_map('247782748')).parking = [19 7 0];
            node(id_map('286595924')).parking = [525 18 0];
            node(id_map('287777665')).parking = [16 18 0];
            node(id_map('2408111036')).parking = [28 18 0];
            node(id_map('269009712')).parking = [10 15 0];
            node(id_map('624184604')).parking = [19 7 0];
            node(id_map('286378645')).parking = [38 7 0];
            node(id_map('262875477')).parking = [13 7 0];
            node(id_map('1283370137')).parking = [200 6 0];
            node(id_map('3098329274')).parking = [300 20 0];
            node(id_map('1025732368')).parking = [33 20 0];
            node(id_map('305941849')).parking = [105 20 0];
            node(id_map('3098329537')).parking = [17 20 0];
            node(id_map('1568235704')).parking = [129 12 0];
            node(id_map('151216586')).parking = [113 21 0];
            node(id_map('262218353')).parking = [128 21 0];
            node(id_map('1301275265')).parking = [26 8 0];
            node(id_map('297623713')).parking = [125 12 0];
            node(id_map('297623761')).parking = [1000 12 0];
            node(id_map('2561598512')).parking = [61 20 0];
            node(id_map('1025732207')).parking = [72 20 0];
            
            node(id_map('1058150029')).parking = [70 8 0];
            node(id_map('1058150209')).parking = [183 8 0];
            node(id_map('1058150606')).parking = [178 8 0];
            node(id_map('2378410241')).parking = [235 8 0];
            node(id_map('1021025238')).parking = [86 8 0];
            node(id_map('1021025212')).parking = [52 8 0];
            node(id_map('3098334657')).parking = [95 8 0];
            node(id_map('1021025142')).parking = [71 8 0];
            node(id_map('1117598050')).parking = [24 8 0];
            node(id_map('286166079')).parking = [88 8 0];
            node(id_map('1021025215')).parking = [131 8 0];
            node(id_map('128173965')).parking = [176 10 0];
            node(id_map('262217683')).parking = [168 8 0];
            node(id_map('2377367964')).parking = [420 10 0];
            node(id_map('1095001958')).parking = [54 6 0];
            
        end
        
        way_count = way_count + 1;
        id_index = findstr(A,'"');
        way(way_count).id = A((id_index(1)+1):(id_index(2)-1)); %Läs in vägens ID och spara.
        ndref_count = 0; %Antalet node referenser, mao hur många noder som är kopplade till kanten.
        way(way_count).highway = 0; %Parameter som anger om kanten skall sparas efter att all information om kanten lästs in. T.ex. skall kanten inte sparas om den hör till en byggnad eller tågräls.
        way(way_count).maxspeed = 30;
        way(way_count).bicycle = 1;
        way(way_count).oneway = 0;
        way(way_count).cycleway = 0;
        way(way_count).bus_only = 0;
        
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
                
                if (strcmp(k,'highway')) %Endast kanter som är vägar skall sparas.
                    way(way_count).highway = 1;
                end
                
                if (strcmp(k,'highway')*strcmp(v,'track')) || (strcmp(k,'highway')*strcmp(v,'path')) || (strcmp(k,'highway')*strcmp(v,'footway')) || (strcmp(k,'highway')*strcmp(v,'pedestrian')) || (strcmp(k,'highway')*strcmp(v,'platform')) %Kanter där man inte kan köra bil och/eller cykel skall inte sparas.
                    n_footways = n_footways + 1;
                    way(way_count).highway = 0;
                    foot_way(n_footways) = way(way_count);
                end
                
                if (strcmp(k,'highway')*strcmp(v,'cycleway'))
                    way(way_count).cycleway = 1;
                end
                
                A = fgets(file);
                
                if strcmp(A(4:7),'/way') && way(way_count).highway == 0 %Om raden som lästs in innehåller '/way' betyder detta att alla taggar är inlästa och då skall kanten tas bort om den inte innehåller information som behövs.
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
    for j = 1:n_ndref
        node(id_map(way(i).ndref{j})).waynd = node(id_map(way(i).ndref{j})).waynd + 1;
    end
end

fclose(file);
config_graph = 0;
save('data_umea.mat','node','way','foot_way','id_map','config_graph','park_nodes')