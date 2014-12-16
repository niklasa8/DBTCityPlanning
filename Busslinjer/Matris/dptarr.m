%Function timeToMin 5.05 (h.min)->305 (min)
timeToMin = @(t) mod(t,1)*100+floor(t)*60;

datafiles={};
k=1;
BussData=dir();
for h=3:length(BussData)
    directory=[BussData(h).name '/'];
    A=dir([directory 'l*.mat']);
    for j=1:length(A)
        datafiles(k)={[directory A(j).name]};
        k=k+1;
    end
end

%Get number of busstops
Names={};
IDs={};
id2idx = containers.Map('KeyType','double','ValueType','int32');
id2name = containers.Map('KeyType','double','ValueType','char');
idx2name = containers.Map('KeyType','int32','ValueType','char');
idx2id = containers.Map('KeyType','int32','ValueType','double');
name2idx = container.Map('KeyType','char','ValueType','int32');
name2id = containers.Map('KeyType','char','ValueType','double');
stop_num=int32(1);
for h=1:length(datafiles)
    data=load(datafiles{h});
    data=data.table;
    for j=1:length(data)
        name=char(data(j).name);
        id=str2double(data(j).id);
        
        if ~isKey(id2idx,id)
           id2name(id) = name;
           id2idx(id) = stop_num;           
           idx2name(stop_num) = name;
           idx2id(stop_num) = id;           
           name2idx(name) = stop_num;
           name2id(name) = id;
           
           stop_num=stop_num+1;
        end
    end
end

n=length(id2idx);
arr=cell(n);
dpt=cell(n);
Error={};
err_count=0;
tic
for h=1:length(datafiles) %For each .mat-file.
    disp(datafiles{h});
    
    %Extract names and ids.
    load(datafiles{h});
    %test
    
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
        wait{j}=int32(round(wait{j}));
    end
    
    for j=1:length(names)-1 %For each pair of stops.
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
           arr{from,to} = zeros(4,1440,'int32');
           dpt{from,to} = zeros(4,1440,'int32');
        end
        for k=1:4 %For each day.
            for l=1:length(days1{k}) %For each departure.
                
                dpt_time=int32(timeToMin(days1{k}(l)));
                %dpt_time=int32(timeToMin(days1{k}(l))+wait{j});
                dpt_time=mod(dpt_time-239,1440);
                arr_time=int32(timeToMin(days2{k}(l)));
                arr_time=mod(arr_time-239,1440);
                
                if arr_time-dpt_time<0
                    %disp(arr_time-dpt_time);
                    a={j, j+1, ids{j}, ids{j+1},...
                        idx2name(from), idx2name(to),...
                        datafiles{h}, dpt_time, arr_time, k}
                    Error=[Error; a];
                    err_count=err_count+1                   
                end
                for m=arr_time:int16(1440) %For each minute of the day.
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

save('hashtables.mat','id2idx', 'id2name', 'idx2name', 'idx2id',...
    'name2idx', 'name2id');
save('dpt.mat','dpt');
save('arr.mat','arr');
