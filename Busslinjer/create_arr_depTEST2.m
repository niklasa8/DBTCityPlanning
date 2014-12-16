
% Function
TimeToMin = @(t) mod(t,1)*100+floor(t)*60; %t=7.56-> 7 h 56 min omvandlar detta till antal minuter från 00:00

% Read filenames of all datafiles
datafiles = {};
k = 1;
BussData = dir('BussData')
for i=3:max(size(BussData))
    directory=['BussData/' BussData(i).name '/'];
    A=dir([directory 'l*.mat']);
    for j=1:max(size(A))
        datafiles(k,1)={[directory A(j).name]};
        k=k+1;       
    end
end

% Mappings of: nodeid->index, index->name, index->nodeid
busMap = containers.Map('KeyType','double','ValueType','int32');
busMapName = containers.Map('KeyType','int32','ValueType','char');
busMapInt = containers.Map('KeyType','int32','ValueType','double');

num_stops = 0;
for i=1:length(datafiles)
    data=load(datafiles{i});
    data=data.table;
    for j=1:length(data)
        name=char(data(j).name);
        id=str2double(data(j).id);
        
        if ~isKey(busMap,id)
           busMapInt(num_stops+1) = id;
           busMapName(num_stops+1) = name;
           busMap(id) = num_stops+1;
           num_stops = num_stops+1;
        end       
    end
end

n = max(size(busMap));  % Total number of busstops 

Arr = cell(n);  % Arrival times
Dep = cell(n);  % Departure times   

for file=1:max(size(datafiles))
    disp(file);
    load(char(datafiles(file)));   
    disp(char(datafiles(file)));
    
    for i=1:max(size(table))-1
        % Index in arr/dep matrices
        from = busMap(str2double(table(i).id));
        to = busMap(str2double(table(i+1).id));

        % If arr/dep element empty, create day/minute matrix
        if isempty(Arr{from,to})
           Arr{from,to} = zeros(4,1440);
           Dep{from,to} = zeros(4,1440);
        end  

        % Add departure and arrivaltime for days: MT,F,L,S.
        if ~isempty(table(1).MT)
            day = 1; % Mon-Thur
            for m=1:length(table(i).MT)
                arr_diff = TimeToMin(table(i+1).MT(m)) - TimeToMin(table(i).MT(m));
                % Handle when daychange occurs, ex arr2=00:02 and arr1=23:58 
                if arr_diff < 0
                    arr_diff = arr_diff + 1440;
                end
                % If arrivaltimes between stop i,i+1 are larger than 1, set 
                % waiting time to 1.
                if arr_diff >= 1.5
                    table(i).waiting_time_MT(m) = 1;
                else 
                    table(i).waiting_time_MT(m) = 0;
                end
            end         

            % dep: Arrivaltime at stop i + waitingtime at stop i
            dep = TimeToMin(table(i).MT) + table(i).waiting_time_MT;
            % arr: Arrivaltime at stop j
            arr = TimeToMin(table(i+1).MT); 

            if dep > arr
                i
                dep-arr                
                disp('Departure time STÖRRE än Arrival time!!!')
            end

            % Add each arrival- and departuretime
            for j=1:length(arr)
                % Shift time from 00:00-24:00 to 04:01-04:00
                if dep(j)>=0 & dep(j)<=240
                    dep(j) = dep(j) + 1200;
                else
                    dep(j) = dep(j) - 240;
                end           
                if arr(j) >= 0 & arr(j) <= 240
                    arr(j) = arr(j) + 1200;
                else
                    arr(j) = arr(j) - 240;
                end


                % If current dep time is less than new
%                 for k=int16(dep(j)):1440
%                     if Dep{from,to}(day,k) <= dep(j)
%                         Dep{from,to}(day,k) = dep(j);
%                     end
%                 end 
                % If current dep time is less than new
                for k=int16(arr(j)):1440
                    if Arr{from,to}(day,k) <= arr(j)
                        Dep{from,to}(day,k) = dep(j);
                        Arr{from,to}(day,k) = arr(j);
                    end
                end                    
            end
        end

        if ~isempty(table(1).F)
            day = 2; % Friday          
            for m=1:length(table(i).F)
                arr_diff = TimeToMin(table(i+1).F(m)) - TimeToMin(table(i).F(m));
                % Handle when daychange occurs, ex arr2=00:02 and arr1=23:58 
                if arr_diff < 0
                    arr_diff = arr_diff + 1440;
                end
                % If arrivaltimes between stop i,i+1 are larger than 1, set 
                % waiting time to 1.
                if arr_diff >= 1.5
                    table(i).waiting_time_F(m) = 1;
                else 
                    table(i).waiting_time_F(m) = 0;
                end
            end         

            % dep: Arrivaltime at stop i + waitingtime at stop i
            dep = TimeToMin(table(i).F) + table(i).waiting_time_F;
            % arr: Arrivaltime at stop j
            arr = TimeToMin(table(i+1).F); 

            if dep > arr
                i
                dep-arr                
                disp('Departure time STÖRRE än Arrival time!!!')
            end

            % Add each arrival- and departuretime
            for j=1:length(arr)
                % Shift time from 00:00-24:00 to 04:01-04:00
                if dep(j)>=0 & dep(j)<=240
                    dep(j) = dep(j) + 1200;
                else
                    dep(j) = dep(j) - 240;
                end           
                if arr(j) >= 0 & arr(j) <= 240
                    arr(j) = arr(j) + 1200;
                else
                    arr(j) = arr(j) - 240;
                end


                % If current dep time is less than new
%                 for k=int16(dep(j)):1440
%                     if Dep{from,to}(day,k) <= dep(j)
%                         Dep{from,to}(day,k) = dep(j);
%                     end
%                 end 
                % If current dep time is less than new
                for k=int16(arr(j)):1440
                    if Arr{from,to}(day,k) <= arr(j)
                        Arr{from,to}(day,k) = arr(j);
                        Dep{from,to}(day,k) = dep(j);
                    end
                end               
            end
        end

        if ~isempty(table(1).L)
            day = 3; % Saturday          
            for m=1:length(table(i).L)
                arr_diff = TimeToMin(table(i+1).L(m)) - TimeToMin(table(i).L(m));
                % Handle when daychange occurs, ex arr2=00:02 and arr1=23:58 
                if arr_diff < 0
                    arr_diff = arr_diff + 1440;
                end
                % If arrivaltimes between stop i,i+1 are larger than 1, set 
                % waiting time to 1.
                if arr_diff >= 1.5
                    table(i).waiting_time_L(m) = 1;
                else 
                    table(i).waiting_time_L(m) = 0;
                end
            end         

            % dep: Arrivaltime at stop i + waitingtime at stop i
            dep = TimeToMin(table(i).L) + table(i).waiting_time_L;
            % arr: Arrivaltime at stop j
            arr = TimeToMin(table(i+1).L); 

            if dep > arr
                i
                dep-arr                
                disp('Departure time STÖRRE än Arrival time!!!')
            end

            % Add each arrival- and departuretime
            for j=1:length(arr)
                % Shift time from 00:00-24:00 to 04:01-04:00
                if dep(j)>=0 & dep(j)<=240
                    dep(j) = dep(j) + 1200;
                else
                    dep(j) = dep(j) - 240;
                end           
                if arr(j) >= 0 & arr(j) <= 240
                    arr(j) = arr(j) + 1200;
                else
                    arr(j) = arr(j) - 240;
                end                

                % If current dep time is less than new
                for k=int16(dep(j)):1440
                    if Dep{from,to}(day,k) <= dep(j)
                        Dep{from,to}(day,k) = dep(j);
                    end
                end 
                % If current dep time is less than new
                for k=int16(arr(j)):1440
                    if Arr{from,to}(day,k) <= arr(j)
                        Arr{from,to}(day,k) = arr(j);
                        Dep{from,to}(day,k) = dep(j);
                    end
                end 

            end
        end

        if ~isempty(table(1).S)
            day = 4; % Sunday          
            for m=1:length(table(i).S)
                arr_diff = TimeToMin(table(i+1).S(m)) - TimeToMin(table(i).S(m));
                % Handle when daychange occurs, ex arr2=00:02 and arr1=23:58 
                if arr_diff < 0
                    arr_diff = arr_diff + 1440;
                end
                % If arrivaltimes between stop i,i+1 are larger than 1, set 
                % waiting time to 1.
                if arr_diff >= 1.5
                    table(i).waiting_time_S(m) = 1;
                else 
                    table(i).waiting_time_S(m) = 0;
                end
            end         

            % dep: Arrivaltime at stop i + waitingtime at stop i
            dep = TimeToMin(table(i).S) + table(i).waiting_time_S;
            % arr: Arrivaltime at stop j
            arr = TimeToMin(table(i+1).S); 

            if dep > arr
                i
                dep-arr                
                disp('Departure time STÖRRE än Arrival time!!!')
            end

            % Add each arrival- and departuretime
            for j=1:length(arr)
                % Shift time from 00:00-24:00 to 04:01-04:00
                if dep(j)>=0 & dep(j)<=240
                    dep(j) = dep(j) + 1200;
                else
                    dep(j) = dep(j) - 240;
                end           
                if arr(j) >= 0 & arr(j) <= 240
                    arr(j) = arr(j) + 1200;
                else
                    arr(j) = arr(j) - 240;
                end

                % If current dep time is less than new
%                 for k=int16(dep(j)):1440
%                     if Dep{from,to}(day,k) <= dep(j)
%                         Dep{from,to}(day,k) = dep(j);
%                     end
%                 end 
                % If current dep time is less than new
                for k=int16(arr(j)):1440
                    if Arr{from,to}(day,k) <= arr(j)
                        Arr{from,to}(day,k) = arr(j);
                        Dep{from,to}(day,k) = dep(j);
                    end
                end

            end
        end

    end
end

% Save data to files
save('ArrDep/Arrivals.mat','Arr')
save('ArrDep/Departures.mat','Dep')
    