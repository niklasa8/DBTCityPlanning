%Ändringar i grafen görs genom att man sparar en strukt som heter config i 
%data_umea.mat, nedan finns exempel som visar syntax och hur man sparar
%filen i data_umea.mat

%Syntax för hur man lägger till noder i grafen.
%add_node är en structure array där antalet structar är antalet noder som
%ska läggas till.
add_node(1).waynd = 0;
add_node(1).traffic_signals = 0;
add_node(1).traffic_calming = 0;
add_node(1).name = 0;
add_node(1).parking = 0;
add_node(1).intnd = 0;
add_node(1).bus_stop = 0;
add_node(1).id = num2str(1+1000);
add_node(1).lat = 63.8465;
add_node(1).lon = 20.3778;

%Syntax för hur man lägger till vägar i grafen.
%add_way är en structure array där antalet structar är antalet vägar som
%ska läggas till.
add_way(1).id = num2str(1+1000);
add_way(1).highway = 1;
add_way(1).maxspeed = 30; %Maxhastigheten på vägen
add_way(1).bicycle = 1; %Om man får  cykla på vägen
add_way(1).oneway = 0;
add_way(1).parking = 0;
add_way(1).cycleway = 0; %Om det är en väg endast för cykel och gång (inte bil)
add_way(1).footway = 0; %Om det är en väg endast för fotgängare.
add_way(1).ndref = {'286383990','295095215'}; %Globala OSM idt för
%alla noder som vägen går genom.

%config.delete_edge tar bort kanter från grafen. config.delete_edge är en
%cellmatris där varje cell innehåller en array med två element. Första
%elementet är IDt för startnoden och andra elementet är IDt för slutnoden 
%för kanten. Notera att detta tar bort KANTER och ovanför lägger man 
%till VÄGAR vilket inte är samma sak. Nedan finner ni exempel på hur 
%man tar bort kanter.

config.delete_edge = {[286383990;295095215]};

%config.car_speed_factor är en faktor som anger hur mycket lägre/högre
%hastighet bilarna har globalt. Nedan finner ni exempel på hur man halverar max hastighet 
%på alla vägar och hur man sätter cykelhastigheten till 7 km/h och gång hastigheten till 4 km/h (snöstorm?).

config.car_speed_factor = 0.5;
config.bicycle_speed = 7;
config.walk_speed = 4;

%config.speed_limit_edge är en cellmatris som ändrar 
%hastighetsbegränsningen på kanter. Man skickar först in en array som
%innehåller globala OSM idt för startnod och slutnod för kanten och
%elementet efter är max hastigheten på den kanten. Nedan finner ni ett
%exempel på hur ni ändrar max hastighet till 50 på två kanter.

config.speed_limit_edge = {['286383990','295095215'],'50'};

%Om man gjort några ändringar ska config_graph = 1 annars 0. Om man sätter
%config_graph = 1 måste alla variabler i config strukten definieras men de som inte används
%kan bara sättas till [] (NULL) förutom car_speed_factor, bicycle_speed och
%walk_speed som måste ha värden skillda från [] om config_graph = 1;

config_graph = 1;

save('data_umea.mat','config','add_way','add_node','config_graph','-append')