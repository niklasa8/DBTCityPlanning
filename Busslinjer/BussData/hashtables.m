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
name2idx = containers.Map('KeyType','char','ValueType','int32');
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

save('hashtables.mat','id2idx', 'id2name', 'idx2name', 'idx2id',...
    'name2idx', 'name2id');