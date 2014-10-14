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
times = struct('departure',{},'arrival',{});

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

                if ~isKey(bs_map,B(31:end_index(2)-1)) || isempty(bs_map)
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

                for j = 2:n_stops
                    from = bs_ref(i,dir_nr,bs_id(j-1));
                    to = bs_ref(i,dir_nr,bs_id(j));
                    times(from,to).departure = [times(from,to).departure dept_time(j-1)];
                    times(from,to).arrival = [times(from,to).arrival dept_time(j)];
                end
            end
            B = fgets(file_id);
        end
        B = fgets(file_id);
    end
    fclose(file_id);
end %for