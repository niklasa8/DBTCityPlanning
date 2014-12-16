

% Function
TimeToMin = @(t) mod(t,1)*100+floor(t)*60; %t=7.56-> 7 h 56 min omvandlar detta till antal minuter från 00:00

% Read filenames
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

% Get number of busstops
Names={};
IDs={};
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

tic
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
        
%         if isempty(table(i).waiting_time)
%             table(i).waiting_time = 0;
%         end
        
%         wait_time = round(table(i).waiting_time);
%         if wait_time-table(i).waiting_time < 0
%            table(i+1).waiting_time = abs(wait_time-table(i).waiting_time) + table(i+1).waiting_time;
%         elseif wait_time-table(i).waiting_time > 0
%            table(i+1).waiting_time = table(i).waiting_time - abs(wait_time-table(i).waiting_time);
%         end
%         table(i).waiting_timeround = wait_time;
%         
        
        % Add departure and arrivaltime for days: MT,F,L,S.
        if ~isempty(table(1).MT)
            % Handle roundoffs in waitingtime
            rounded_time = round(table(i).waiting_time_MT);
            table(i).waiting_time_MT = rounded_time;
            i_neg = find(rounded_time-table(i).waiting_time_MT < 0);    % Indices of elements rounded down 
            i_pos = find(rounded_time-table(i).waiting_time_MT > 0);    % Indices of elements rounded up
            
            % Add or withdraw roundoffs to waitingtime for next stop.
            table(i+1).waiting_time_MT(i_neg) = abs(rounded_time(i_neg) - table(i).waiting_time_MT(i_neg)) + table(i+1).waiting_time_MT(i_neg);
            table(i+1).waiting_time_MT(i_pos) = table(i).waiting_time_MT(i_pos) - abs(rounded_time(i_pos) - table(i).waiting_time_MT(i_pos));
            
            for m=1:table(i).MT-1
                arr_diff = TimeToMin(table(i+1).MT(m)) - TimeToMin(table(i).MT(m));
                % Handle when daychange occurs, ex arr2=00:02 and arr1=23:58 
                if arr_diff < 0
                    arr_diff = arr_diff + 1440;
                end
                % Handle if waitingtime is larger or equal to time between
                % two stops. MAX 1 MIN I VÄNTETID??
                if arr_diff <= table(i).waiting_time_MT(m)
                    diff = table(i).waiting_time_MT(m) - arr_diff;
                    table(i).waiting_time_MT(m) = max(0, table(i).waiting_time_MT(m)-diff);
                end
            end         
            
            % dep: Arrivaltime at stop i + waitingtime at stop i
            dep = TimeToMin(table(i).MT) + table(i).waiting_time_MT;
            % arr: Arrivaltime at stop j
            arr = TimeToMin(table(i+1).MT); 
            
            % Handle if departuretime is larger than arrivaltime: Ex
            % dep=23:58 and arr=00:02. Occurs only at daychange.            
            if dep > arr
                
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
                
                
                for k=int16(arr(j)):1440
                    % If current dep/arr time is less than new
                    if Arr{from,to}(1,k) <= arr(j)
                        Arr{from,to}(1,k) = arr(j);
                    end
                    if Dep{from,to}(1,k) <= dep(j)
                        Dep{from,to}(1,k) = dep(j);
                    end
                end                    
            end
        end
        
        if ~isempty(table(1).F)
            dep = TimeToMin(table(i).F) + floor(table(i).waiting_time);
            arr = TimeToMin(table(i+1).F);
            
            
           % Add each arrival- and departuretime
            for j=1:length(arr)
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
                for k=int16(arr(j)):1440
                    % If current dep/arr time is less than new
                    if Arr{from,to}(1,k) <= arr(j)
                        Arr{from,to}(1,k) = arr(j);
                    end
                    if Dep{from,to}(1,k) <= dep(j)
                        Dep{from,to}(1,k) = dep(j);
                    end
                end
            end
        end
        
        if ~isempty(table(1).L)
            dep = TimeToMin(table(i).L) + floor(table(i).waiting_time);
            arr = TimeToMin(table(i+1).L);
            
            % Add each arrival- and departuretime
            for j=1:length(arr)
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
                for k=int16(arr(j)):1440
                    % If current dep/arr time is less than new
                    if Arr{from,to}(3,k) <= arr(j)
                        Arr{from,to}(3,k) = arr(j);
                        Dep{from,to}(3,k) = dep(j);
                    end
                end
            end
        end
        
        if ~isempty(table(1).S)
            dep = TimeToMin(table(i).S) + floor(table(i).waiting_time);
            arr = TimeToMin(table(i+1).S);
            
  
            % Add each arrival- and departuretime
            for j=1:length(arr)
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
                for k=int16(arr(j)):1440
                    % If current dep/arr time is less than new
                    if Arr{from,to}(4,k) <= arr(j)
                        Arr{from,to}(4,k) = arr(j);
                        Dep{from,to}(4,k) = dep(j);
                    end
                end
            end
        end        
    end
    toc
end

save('ArrDep/Arrivals.mat','Arr')
save('ArrDep/Departures.mat','Dep')

