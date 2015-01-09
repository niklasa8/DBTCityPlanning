function create_spawn_paths(graph_data,data_umea,CGM_sparse)

%load('graph_data.mat','CGM_sparse')%,'intnd_count','intnd_map')
%load('data_umea.mat','park_nodes','id_map')
id_map = data_umea.id_map;

res_spawn_locs = [id_map('156639763'),
id_map('301125520'),
id_map('301120962'),
id_map('297715333'),
id_map('257128'),
id_map('182857776'),
id_map('257145'),
id_map('301119315'),
id_map('1350436701'),
id_map('1934254697'),
id_map('131920338'),
id_map('158679906'),
id_map('2377412892'),
id_map('124076652'),
id_map('124076659'),
id_map('151224901'),
id_map('128186005'),
id_map('129943634'),
id_map('235710277'),
id_map('414725623'),
id_map('129944238'),
id_map('229822631'),
id_map('153151020'),
id_map('286147298'),
id_map('181505003'),
id_map('181595499'),
id_map('838090461'),
id_map('1257199290'),
id_map('140179074'),
id_map('140177021'),
id_map('153184728'),
id_map('1062497339'),
id_map('206231406'),
id_map('248608919'),
id_map('151228407'),
id_map('248608919'),
id_map('777175225'),
id_map('143628779'),
id_map('2354169221'),
id_map('247782246'),
id_map('247782414'),
id_map('247781833'),
id_map('247787958'),
id_map('23717661'),
id_map('286384640'),
id_map('244197388'),
id_map('286071648'),
id_map('318078766'),
id_map('1286195130'),
id_map('1286195041'),
id_map('1357160308'),
id_map('1357160526'),
id_map('253389872'),
id_map('301742881'),
id_map('301743526'),
id_map('295216772'),
id_map('295213809'),
id_map('258354234'),
id_map('166983065'),
id_map('302115298'),
id_map('1560439639')];

%id_map('389426402'),
highway_influx_locs = [id_map('989297271'),
id_map('327263704'),
id_map('312517484')];

highway_outlet_locs = [id_map('989297392'),
id_map('327263694'),
id_map('312517484')];


n_res_spawn_locs = max(size(res_spawn_locs));
n_city_spawn_locs = max(size(data_umea.park_nodes));
n_influx_spawn_locs = max(size(highway_influx_locs));
n_res_dest_locs = n_res_spawn_locs;
n_city_dest_locs = n_city_spawn_locs;
n_influx_dest_locs = n_influx_spawn_locs;

rand_locs = 1:graph_data.intnd_count;
rand_locs(graph_data.intnd_map(data_umea.park_nodes)) = [];
rand_sample = randsample(rand_locs,400);
spawn_locs = [graph_data.intnd_map(res_spawn_locs)' graph_data.intnd_map(data_umea.park_nodes)' graph_data.intnd_map(highway_influx_locs)' rand_sample];
dest_locs = [graph_data.intnd_map(res_spawn_locs)' graph_data.intnd_map(data_umea.park_nodes)' graph_data.intnd_map(highway_outlet_locs)' rand_sample];
n_spawnNds = 400 + n_city_spawn_locs + n_res_spawn_locs + n_influx_spawn_locs;

for j = spawn_locs
    
    [~,spawn_loc_paths{j}] = graphshortestpath(CGM_sparse,j);

end

save('graph_data.mat','spawn_locs','dest_locs','res_spawn_locs','spawn_loc_paths','n_res_spawn_locs','n_city_spawn_locs','n_res_dest_locs','n_city_dest_locs','n_influx_spawn_locs','n_influx_dest_locs','-append')
end