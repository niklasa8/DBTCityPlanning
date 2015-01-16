function found_way_id = addWay_findWay(handles, input_data)

h = waitbar(0,'Finding way...');
    
possible_ways = []; %Sparar platsen i ways som intressanta v�gar ligger p�
possible_nodes = {};

len_input = length(input_data);

%Loopen nedan kollar l�ngden p� input datat, och filtrerar ut vilka v�gar
%som har samma l�ngd (on�digt att s�ka igenom v�gar vi fr�n b�rjan redan
%kan s�ga inte �r aktuella)
for i=1:length(way)
    if len_input == length(way(i).ndref)
        possible_ways = [possible_ways, i];
    end
end
waitbar(0.25,h);
if length(possible_ways) >= 2
    %Nedan skriver ut nodeIDs som KAN ing� i v�gen
    for i=1:len_input %s�ker igenom "arrayen"
        lon = input_data(i); %lon �r p� f�rsta 1 till N
        lat = input_data(i+len_input); %lat p� andra (N+1) till 2N

        for j=1:intnd_count %Kollar igenom hela intnd, sparar undan positionen i intnd f�r match
            if intnd(j).lon == lon && intnd(j).lat == lat;
                aaa = ismember(possible_nodes,intnd(j).id);
                if all(aaa == 0)
                    possible_nodes = [possible_nodes, intnd(j).id];
                end
            end
        end
    end
    %Nedan kollar i varje potentiell v�g, om den inneh�ller de potentiella
    %noderna
    waitbar(0.5,h);
    %F�r varje potentiell v�g (som st�mmer �verens med l�ngden p� den v�g
    %vi klickat p� i kartan)

    %Anv�nder n�got jag kallar "fit" f�r att avg�ra vilken v�g (ways) som
    %passar b�st till de koordinater vi f�tt fr�n plottade v�gar i kartan
    %(ways OSM+intersection-nodes vs plottade intersection-nodes)
    %Den v�g som f�r h�gst fit �r allts� den som har flest intersection
    %nodes som matchar de noder i ways som �ven �r intersection nodes.
    current_fit = 0;
    highest_fit = [0, 0];

    for i=possible_ways %F�r varje potentiell v�g (har en l�ngd vi f�rv�ntar oss)
        way_nodes = way(i).ndref;
        for j=possible_nodes %F�r varje potentiell nod
            %Forloopen nedan utf�r egentligen "if j in way_nodes"
            j=mat2str(cell2mat(j));
            for k=1:length(way_nodes) %Kollar om den potentiella noden finns i den potentiella v�gen
                way_node = mat2str(way_nodes{k});
                %if j==way_node
                if strcmp(j,way_node)
                    current_fit = current_fit + 1; %�kar vi p� fitten
                    break
                end
            end  
        end

        %Om vi hittar en v�g med "h�gre fit" s� sparar vi undan den
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
    



