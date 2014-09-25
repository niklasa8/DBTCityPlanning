%Script som läser in data från en exporterad Open street map fil och sparar 
%relevant data. Det är OSMs overpass API som används.

clear all
file = fopen('Umea'); %Öpnna OSM filen
node_count = 0;
way_count = 0;
A = fgets(file); %Läs in första raden
map_created = 0;

while ischar(A) %Förstsätt läsa in rader tills allt har lästs in.
    if norm(size(A)) < 7
        A = fgets(file) %Om raden som lästs in är mindre än 7 tecken lång innehåller den inget som är av intresse.
        continue;
    end
    if strcmp(A(4:7),'node') %Om raden som lästs in hör till en nod skall informationen om nodens ID och koordinater sparas.
        node_count = node_count + 1;
        node(node_count).waynd = 0;
        id_index = findstr(A,'"');
        node(node_count).id = A((id_index(1)+1):(id_index(2)-1));
        lat_index = findstr(A,'lat="');
        node(node_count).lat = A((lat_index+5):(lat_index+14));
        lon_index = findstr(A,'lon="');
        node(node_count).lon = A((lon_index+5):(lon_index+14));
    end
    
    if strcmp(A(4:6),'way') %Om raden som lästs in är en kant skall information om kanten sparas.
        
        if map_created == 0 %När 'way' lästs in första gången är alla noder inlästa och då skapas en map (?) för noderna. id_map returnerar nodens nummer i grafen, och inparametern till id_map är nodens globala OSM ID.
            id_map = containers.Map({node.id},1:node_count);
            map_created = 1; %Mappen skall inte skapas igen om den redan är skapad.
        end
        
        way_count = way_count + 1;
        id_index = findstr(A,'"');
        way(way_count).id = A((id_index(1)+1):(id_index(2)-1)); %Läs in vägens ID och spara.
        ndref_count = 0; %Antalet node referenser, mao hur många noder som är kopplade till kanten.
        %noderef_id = [];
        way(way_count).keep = 0; %Parameter som anger om kanten skall sparas efter att all information om kanten lästs in. T.ex. skall kanten inte sparas om den hör till en byggnad eller tågräls.
        way(way_count).maxspeed = 30;
        way(way_count).bicycle = 1;
        way(way_count).oneway = 0;
        
        A = fgets(file);
        
        while (strcmp(A(4:7),'/way')==0)
            
            ndref_count = ndref_count + 1;
            id_index = findstr(A,'"');
            way(way_count).ndref{ndref_count} = A((id_index(1)+1):(id_index(2)-1)); %Läser in och sprar vilka noder som hör till kanten.
            %noderef_id(ndref_count) = id_map(way(way_count).ndref{ndref_count});
            %node(noderef_id(ndref_count)).waynd = node(noderef_id(ndref_count)).waynd + 1; %Räknar upp antalet kanten som noden refererar till.
            
            A = fgets(file);
            
            if strcmp(A(4:7),'/way') && way(way_count).keep == 0 %Om raden som lästs in innehåller '/way' betyder detta att alla taggar är inlästa och då skall kanten tas bort om den inte innehåller information som behövs.
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
                %(strcmp(k,'building')) || (strcmp(k,'landuse')) || (strcmp(k,'barrier')) ||  ||  strcmp(k,'amenity') || strcmp(k,'leisure') || strcmp(k,'waterway') || strcmp(k,'boundary') || strcmp(k,'natural') || strcmp(k,'aerialway') || strcmp(k,'power')
                
                if (strcmp(k,'highway')) %Endast kanter som är vägar skall sparas.
                    way(way_count).keep = 1;
                end
                
                if (strcmp(k,'highway')*strcmp(v,'track')) || (strcmp(k,'highway')*strcmp(v,'path')) || (strcmp(k,'highway')*strcmp(v,'footway')) || (strcmp(k,'highway')*strcmp(v,'pedestrian')) || (strcmp(k,'highway')*strcmp(v,'platform')) %Kanter där man inte kan köra bil och/eller cykel skall inte sparas.
                    way(way_count).keep = 0;
                end
                
                A = fgets(file);
                
                if strcmp(A(4:7),'/way') && way(way_count).keep == 0 %Om raden som lästs in innehåller '/way' betyder detta att alla taggar är inlästa och då skall kanten tas bort om den inte innehåller information som behövs.
                    way(way_count) = [];
                    way_count = way_count - 1;
                end
            end
        end
    end
    
    A = fgets(file);
end

% i = 0;
% while i<node_count %Tar bort alla noder som inte refererar till en sparad kant.
%     i = i + 1;
%     i/node_count
%     if node(i).waynd == 0
%         node(i) = [];
%         i = i - 1;
%         node_count = node_count - 1;
%     end
% end


for i = 1:way_count
    [x n_ndref] = size(way(i).ndref)
    i/way_count
    for j = 1:n_ndref
        node(id_map(way(i).ndref{j})).waynd = node(id_map(way(i).ndref{j})).waynd + 1;
    end
end

%id_map = containers.Map({node.id},1:node_count); %Gör om mappingen efter att noder har tagits bort.
fclose(file);
save('data_umea.mat','node','way','id_map')