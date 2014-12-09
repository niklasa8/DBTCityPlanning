%�ndringar i grafen g�rs genom att man sparar en strukt som heter config i 
%data_umea.mat, nedan finns exempel som visar syntax och hur man sparar
%filen i data_umea.mat

%Syntax f�r hur man l�gger till noder i grafen.
%add_node �r en structure array d�r antalet structar �r antalet noder som
%ska l�ggas till.
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

%Syntax f�r hur man l�gger till v�gar i grafen.
%add_way �r en structure array d�r antalet structar �r antalet v�gar som
%ska l�ggas till.
add_way(1).id = num2str(1+1000);
add_way(1).highway = 1;
add_way(1).maxspeed = 30; %Maxhastigheten p� v�gen
add_way(1).bicycle = 1; %Om man f�r  cykla p� v�gen
add_way(1).oneway = 0;
add_way(1).parking = 0;
add_way(1).cycleway = 0; %Om det �r en v�g endast f�r cykel och g�ng (inte bil)
add_way(1).footway = 0; %Om det �r en v�g endast f�r fotg�ngare.
add_way(1).ndref = {'286383990','295095215'}; %Globala OSM idt f�r
%alla noder som v�gen g�r genom.

%config.delete_edge tar bort kanter fr�n grafen. config.delete_edge �r en
%cellmatris d�r varje cell inneh�ller en array med tv� element. F�rsta
%elementet �r IDt f�r startnoden och andra elementet �r IDt f�r slutnoden 
%f�r kanten. Notera att detta tar bort KANTER och ovanf�r l�gger man 
%till V�GAR vilket inte �r samma sak. Nedan finner ni exempel p� hur 
%man tar bort kanter.

config.delete_edge = {[286383990;295095215]};

%config.car_speed_factor �r en faktor som anger hur mycket l�gre/h�gre
%hastighet bilarna har globalt. Nedan finner ni exempel p� hur man halverar max hastighet 
%p� alla v�gar och hur man s�tter cykelhastigheten till 7 km/h och g�ng hastigheten till 4 km/h (sn�storm?).

config.car_speed_factor = 0.5;
config.bicycle_speed = 7;
config.walk_speed = 4;

%config.speed_limit_edge �r en cellmatris som �ndrar 
%hastighetsbegr�nsningen p� kanter. Man skickar f�rst in en array som
%inneh�ller globala OSM idt f�r startnod och slutnod f�r kanten och
%elementet efter �r max hastigheten p� den kanten. Nedan finner ni ett
%exempel p� hur ni �ndrar max hastighet till 50 p� tv� kanter.

config.speed_limit_edge = {['286383990','295095215'],'50'};


%Om man gjort n�gra �ndringar ska config_graph = 1 annars 0. Om man s�tter
%config_graph = 1 m�ste alla variabler i config strukten definieras men de som inte anv�nds
%kan bara s�ttas till [] (NULL) f�rutom car_speed_factor, bicycle_speed och
%walk_speed som m�ste ha v�rden skillda fr�n [] om config_graph = 1;

config_graph = 0;

save('data_umea.mat','config','add_way','add_node','config_graph','-append')