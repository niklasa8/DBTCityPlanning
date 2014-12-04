clear all
clc



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
busMapName = containers.Map('KeyType','double','ValueType','char');

num_stops = 0;
for i=1:length(datafiles)
    data=load(datafiles{i});
    data=data.table;
    for j=1:length(data)
        name=char(data(j).name);
        id=str2double(data(j).id);
        
        if ~isKey(busMap,id)
           busMapName(id) = name;
           busMap(id) = num_stops+1;
           num_stops = num_stops+1;
        end       
        
%         if ~ismember(id, IDs)
%             IDs=[IDs id];
%         end
%         
%         if ~ismember(name, Names);
%             Names=[Names name];
%         end
    end
end

n = max(size(busMap));  % Total number of busstops 

Arr = cell(n);  % Arrival times
Dep = cell(n);  % Departure times


for file=1:max(size(datafiles))
    load(char(datafiles(file)));   
    
    
    for i=1:max(size(table))-1
        % Index in arr/dep matrices
        from = busMap(str2double(table(i).id));
        to = busMap(str2double(table(i+1).id));
        
        % If arr/dep element empty, create day/minute matrix
        if isempty(Arr{from,to})
           Arr{from,to} = zeros(4,1440);
           Dep{from,to} = zeros(4,1440);
        end
        
        % Handle roundoffs in waitingtime
        if isempty(table(i).waiting_time)
            table(i).waiting_time = 0;
        end
        
        wait_time = round(table(i).waiting_time);
        if wait_time-table(i).waiting_time < 0
           table(i+1).waiting_time = abs(wait_time-table(i).waiting_time) + table(i+1).waiting_time
        elseif wait_time-table(i).waiting_time > 0
           table(i+1).waiting_time = table(i).waiting_time - abs(wait_time-table(i).waiting_time)
        end
        table(i).waiting_timeround = wait_time;
        
        
        % Add departure and arrivaltime for days.
        if ~isempty(table(1).MT)
            
            % dep: Arrivaltime at stop i + waitingtime at stop i
            dep = TimeToMin(table(i).MT) + round(table(i).waiting_time);
            % arr: Arrivaltime at stop j
            arr = TimeToMin(table(i+1).MT);                       
            
            % Add each arrival- and departuretime
            for j=1:length(arr)
                % Shift time from 00:00-24:00 to 04:00-04:00
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
                
                for k=j:1440-1
                    % If current dep/arr time is less than new
                    if Arr{from,to}(1,int8(arr(k))) < arr(j)
                        Arr{from,to}(1,int8(arr(k))) = arr(j);
                    end
                    if Dep{from,to}(1,int8(dep(k))) < dep(j)
                        Dep{from,to}(1,int8(dep(k))) = dep(j);
                    end
                end                    
%                 Arr{from,to}(1,arr(j):end) = arr(j);
%                 Dep{from,to}(1,dep(j):end) = dep(j);
            end
        end
        
        if ~isempty(table(1).F)
            dep = TimeToMin(table(i).F) + round(table(i).waiting_time);
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
                for k=j:1440
                    % If current dep/arr time is less than new
                    if Arr{from,to}(2,int8(arr(k))) < arr(j)
                        Arr{from,to}(2,int8(arr(k))) = arr(j);
                    end
                    if Dep{from,to}(2,int8(dep(k))) < dep(j)
                        Dep{from,to}(2,int8(dep(k))) = dep(j);
                    end
                end
%                 Arr{from,to}(2,arr(j):end) = arr(j);
%                 Dep{from,to}(2,dep(j):end) = dep(j);
            end
        end
        
        if ~isempty(table(1).L)
            dep = TimeToMin(table(i).L) + round(table(i).waiting_time);
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
                for k=j:1440
                    % If current dep/arr time is less than new
                    if Arr{from,to}(3,int8(arr(k))) < arr(j)
                        Arr{from,to}(3,int8(arr(k))) = arr(j);
                    end
                    if Dep{from,to}(3,int8(dep(k))) < dep(j)
                        Dep{from,to}(3,int8(dep(k))) = dep(j);
                    end
                end
%                 Arr{from,to}(3,arr(j):end) = arr(j);
%                 Dep{from,to}(3,dep(j):end) = dep(j);
            end
        end
        
        if ~isempty(table(1).S)
            dep = TimeToMin(table(i).S) + round(table(i).waiting_time);
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
                for k=j:1440
                    % If current dep/arr time is less than new
                    if Arr{from,to}(4,int8(arr(k))) < arr(j)
                        Arr{from,to}(4,int8(arr(k))) = arr(j);
                    end
                    if Dep{from,to}(4,int8(dep(k))) < dep(j)
                        Dep{from,to}(4,int8(dep(k))) = dep(j);
                    end
                end
%                 Arr{from,to}(4,arr(j):end) = arr(j);
%                 Dep{from,to}(4,dep(j):end) = dep(j);
            end
        end
        
    end
end
