clear all
clc

datafiles={};
k=1;
BussData=dir('BussData')
% bs_map = containers.Map('KeyType','char','ValueType','int32');

num_stops = 180;
A = cell(num_stops);

TimeToMin=@(t)mod(t,1)*100+floor(t)*60; %t=7.56-> 7 h 56 min omvandlar detta till antal minuter från 00:00



for i=3:max(size(BussData))
    directory=['BussData/' BussData(i).name '/'];
    A=dir([directory 'l*.mat']);
    for j=1:max(size(A))
        datafiles(k,1)={[directory A(j).name]};
        k=k+1;       
    end
end

for file=1%max(size(datafiles))
    load(char(datafiles(file)));

   
    
    for i=1:max(size(table))-1
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
        
        % Kontrollera vilka dagar som har avgångstider
        if ~isempty(table(1).MT)
%             TimeToMin(table(i+1).MT) - TimeToMin(table(i).MT) + round(table(i).waiting_time

        end
        if isempty(table(1).F)
        end
        if isempty(table(1).L)
        end
        if isempty(table(1).S)
            
        end
        
    end
end
