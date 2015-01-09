function found_way_id = addWay_findWay(handles, input_data)

h = waitbar(0,'Finding way...');
    
possible_ways = []; %Sparar platsen i ways som intressanta vägar ligger på
possible_nodes = {};

len_input = length(input_data);

%Loopen nedan kollar längden på input datat, och filtrerar ut vilka vägar
%som har samma längd (onödigt att söka igenom vägar vi från början redan
%kan säga inte är aktuella)
for i=1:length(way)
    if len_input == length(way(i).ndref)
        possible_ways = [possible_ways, i];
    end
end
waitbar(0.25,h);
if length(possible_ways) >= 2
    %Nedan skriver ut nodeIDs som KAN ingå i vägen
    for i=1:len_input %söker igenom "arrayen"
        lon = input_data(i); %lon är på första 1 till N
        lat = input_data(i+len_input); %lat på andra (N+1) till 2N

        for j=1:intnd_count %Kollar igenom hela intnd, sparar undan positionen i intnd fï¿½r match
            if intnd(j).lon == lon && intnd(j).lat == lat;
                aaa = ismember(possible_nodes,intnd(j).id);
                if all(aaa == 0)
                    possible_nodes = [possible_nodes, intnd(j).id];
                end
            end
        end
    end
    %Nedan kollar i varje potentiell väg, om den innehåller de potentiella
    %noderna
    waitbar(0.5,h);
    %För varje potentiell väg (som stämmer överens med längden på den väg
    %vi klickat på i kartan)

    %Använder något jag kallar "fit" för att avgöra vilken väg (ways) som
    %passar bäst till de koordinater vi fått från plottade vägar i kartan
    %(ways OSM+intersection-nodes vs plottade intersection-nodes)
    %Den väg som får högst fit är alltså den som har flest intersection
    %nodes som matchar de noder i ways som även är intersection nodes.
    current_fit = 0;
    highest_fit = [0, 0];

    for i=possible_ways %För varje potentiell väg (har en längd vi förväntar oss)
        way_nodes = way(i).ndref;
        for j=possible_nodes %För varje potentiell nod
            %Forloopen nedan utför egentligen "if j in way_nodes"
            j=mat2str(cell2mat(j));
            for k=1:length(way_nodes) %Kollar om den potentiella noden finns i den potentiella vägen
                way_node = mat2str(way_nodes{k});
                %if j==way_node
                if strcmp(j,way_node)
                    current_fit = current_fit + 1; %ökar vi på fitten
                    break
                end
            end  
        end

        %Om vi hittar en väg med "högre fit" så sparar vi undan den
        if current_fit >= highest_fit(2) && current_fit <= len_input
            highest_fit = [i, current_fit];
        end
        current_fit = 0;
    end
    waitbar(0.75,h);
    %Raderna nedan summerar ut resultatet och returnar
    found_way = highest_fit(1);
    found_fit = highest_fit(2);

    waitbar(1,h);
    delete(h)

    found_way_id = found_way; %OBS ger pos. i ways EJ OSM ID

end
    



