% Function timeToMin 5.05 (h.min)->305 (min)
timeToMin = @(t) mod(t,1)*100+floor(t)*60;

datafiles={};
k=1;
BussData=dir();
for i=3:length(BussData)
    directory=[BussData(i).name '/'];
    A=dir([directory 'l*.mat']);
    for j=1:length(A)
        datafiles(k)={[directory A(j).name]};
        k=k+1;
    end
end

% Get number of busstops
Names={};
IDs={};
id2idx = containers.Map('KeyType','double','ValueType','int16');
%id2idx = containers.Map('KeyType','double','ValueType','double');
id2name = containers.Map('KeyType','double','ValueType','char');
idx2name = containers.Map('KeyType','double','ValueType','char');
stop_num=int16(1);
%stop_num=1;
for i=1:length(datafiles)
    data=load(datafiles{i});
    data=data.table;
    for j=1:length(data)
        name=char(data(j).name);
        id=str2double(data(j).id);
        
        if ~isKey(id2idx,id)
           id2name(id) = name;
           id2idx(id) = stop_num;
           idx2name(stop_num) = name;
           stop_num=stop_num+1;
        end
    end
end

n=length(id2idx);
arr=cell(n);
dpt=cell(n);

for i=1:length(datafiles) %For each .mat-file.
    datafiles{i}
    %Extract names and ids.
    load(datafiles{i});
    names={table.name};
    ids={table.id};
    for j=1:length(ids)
        ids{j}=str2double(ids{j});
    end
    %Extract and round off waiting times.
    wait={table.waiting_time};
    for j=1:length(wait)-1
        if isempty(wait{j})
            wait{j}=0;
        end
        if isempty(wait{j+1})
            wait{j+1}=0;
        end
        wait{j+1}=wait{j+1}+wait{j}-round(wait{j});
        wait{j}=int16(round(wait{j}));
        %wait{j}=round(wait{j});
    end
    for j=1:length(names)-1 %For each pair of stops.
        tic
        %Identify indices for the stops.
        from=id2idx(ids{j});
        to=id2idx(ids{j+1});
        %Extract arrival times.
        MT1=table(j).MT; F1=table(j).F; L1=table(j).L;
        S1=table(j).S; days1={MT1 F1 L1 S1};
        MT2=table(j+1).MT; F2=table(j+1).F; L2=table(j+1).L;
        S2=table(j+1).S; days2={MT2 F2 L2 S2};
        %Fill if empty field.
        
        if isempty(arr{from,to})
            
           arr{from,to} = zeros(4,1440,'int16');
           dpt{from,to} = zeros(4,1440,'int16');
           %arr{from,to} = zeros(4,1440);
           %dpt{from,to} = zeros(4,1440);
        end
        toc
        for k=1:4 %For each day.
            for l=1:length(days1{k}) %For each departure.
                %arr_time=timeToMin(days2{k}(l));
                %dpt_time=timeToMin(days1{k}(l))+wait{j};
                arr_time=int16(timeToMin(days2{k}(l)));
                dpt_time=int16(timeToMin(days1{k}(l))+wait{j});
                if arr_time-dpt_time<0
                    disp(arr_time-dpt_time);
                end
                for m=arr_time:int16(1440) %For each minute of the day.
                %for m=floor(arr_time):1440 %For each minute of the day.
                    %Check if this departure is better.
                    if arr{from,to}(k,m)<arr_time
                        arr{from,to}(k,m)=arr_time;
                        dpt{from,to}(k,m)=dpt_time;
                    end
                end
                
            end
            
        end
        
    end
    
end
