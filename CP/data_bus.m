load('graph_data.mat','id_map')
ultra_file(1) = {'Ultra_1_140929_150426.xml'};
ultra_file(2) = {'Ultra_2_140929_150426.xml'};
ultra_file(3) = {'Ultra_3_140929_150426.xml'};
ultra_file(4) = {'Ultra_4_140929_150426.xml'};
ultra_file(5) = {'Ultra_5_140929_150426.xml'};
ultra_file(6) = {'Ultra_6_140929_150426.xml'};
ultra_file(7) = {'Ultra_7_140929_150426.xml'};
ultra_file(8) = {'Ultra_8_140929_150426.xml'};
ultra_file(9) = {'Ultra_9_140929_150426.xml'};
ultra_file(10) = {'Ultra_72_140929_150426.xml'};
ultra_file(11) = {'Ultra_73_140929_150426.xml'};
ultra_file(12) = {'Ultra_75_140929_150426.xml'};
ultra_file(13) = {'Ultra_76_140929_150426.xml'};
ultra_file(14) = {'Ultra_78_140929_150426.xml'};
ultra_file(15) = {'Ultra_80_140929_150426.xml'};
ultra_file(16) = {'Ultra_81_140929_150426.xml'};

bs_count = 0;
stop = 0;
dir_nr = 0;
bs_map = containers.Map('KeyType','char','ValueType','int32');
arrival_ = zeros(27,27,1440);
departure_ = zeros(27,27,1440);


for i = 1:16
    file_id = fopen(char(ultra_file(i)));
    B = fgets(file_id);
    
    while isempty(strfind(B,'</Directions>'))
        
        dir_nr = dir_nr + 1;
    
        while isempty(strfind(B,'</Cols>'))

            if strcmp(B(9:10),'<C')
                col_pos = str2double(B(19))+1;
                B = fgets(file_id);
                end_index = strfind(B,'<');
                
                name = B(31:end_index(2)-1);

                if ~isKey(bs_map,B(31:end_index(2)-1))
                    bs_count = bs_count + 1;
                    B(31:end_index-1);
                    bus_stop(bs_count).name = B(31:end_index(2)-1);
                    bs_ref(i,dir_nr,col_pos) = bs_count;
                    bs_map(bus_stop(bs_count).name) = bs_count;
                else
                    bs_ref(i,dir_nr,col_pos) = bs_map(B(31:end_index(2)-1));
                end
                
            else
                B = fgets(file_id);
            end %if B(9:10)
        end %while
        
        times(bs_count,bs_count).departure = 0;
        times(bs_count,bs_count).arrival = 0;


        while isempty(findstr(B,'</Direction>'))

            if ~isempty(findstr(B,'<DayName>'))
                end_index = findstr(B,'<');
                day_name = B(20:end_index(2)-1);
                B = fgets(file_id);
                dept_time = 0;
                n_stops = 0;
                bs_id = 0;

                while isempty(findstr(B,'</Rows>'))

                    if ~isempty(findstr(B,'<Time pos='))
                        n_stops = n_stops + 1;
                        bs_id(n_stops) = str2double(B(28)) + 1;
                        B = fgets(file_id);

                        if isempty(findstr(B,'x'))
                            end_index = findstr(B,'<');
                            dept_time_str = B(39:end_index(2)-1);
                            dept_time(n_stops) = str2double(dept_time_str(1:2))*60 + str2double(dept_time_str(4:5)) + 1;
                        else
                            bs_id(n_stops) = [];
                            n_stops = n_stops - 1;
                        end
                    end
                    B = fgets(file_id);
                end

                k = 1;
                for j = 2:n_stops
                    from = bs_ref(i,dir_nr,bs_id(j-1));
                    to = bs_ref(i,dir_nr,bs_id(j));
                    departure_(from,to,dept_time(j):end) = dept_time(j-1);
                    arrival_(from,to,dept_time(j):end) = dept_time(j);
                    k = dept_time(j);
                end
                
            end
            B = fgets(file_id);
        end
        B = fgets(file_id);
    end
    fclose(file_id);
end %for

bus_stop(1).id = id_map('613495002');
bus_stop(2).id = id_map('1917895812');
bus_stop(3).id = id_map('301142256');
bus_stop(4).id = id_map('282252233');
bus_stop(5).id = id_map('2076294631');
bus_stop(6).id = id_map('283324062');
bus_stop(7).id = id_map('301742816');
bus_stop(8).id = id_map('334746087');
bus_stop(9).id = id_map('2075347365');
bus_stop(10).id = id_map('182858864');
bus_stop(11).id = id_map('613494992');
bus_stop(12).id = id_map('260642516');
bus_stop(13).id = id_map('25478281');
bus_stop(14).id = id_map('291140580');
bus_stop(15).id = id_map('153193859');
bus_stop(16).id = id_map('2087751643');
bus_stop(17).id = id_map('1614952475');
bus_stop(18).id = id_map('153189435');
bus_stop(19).id = id_map('1231595034');
bus_stop(20).id = id_map('1286288144');
bus_stop(21).id = id_map('1542779917');
bus_stop(22).id = id_map('2561598361');
bus_stop(23).id = id_map('274741674');
bus_stop(24).id = id_map('1946746474');
bus_stop(25).id = id_map('2043054425');
bus_stop(26).id = id_map('1983283008');
bus_stop(27).id = id_map('158587486');
bus_stop_nodes = intnd_map([bus_stop.id]);
save('data_umea.mat','departure_','arrival_','bus_stop','n_stops','bus_stop_nodes','-append')