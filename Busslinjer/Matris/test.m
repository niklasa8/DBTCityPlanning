% Function timeToMin 5.05 (h.min)->305 (min)
timeToMin = @(t) mod(t,1)*100+floor(t)*60;

datafiles={};
k=1;
BussData=dir('../BussData');
for i=3:length(BussData)
    directory=['../BussData/' BussData(i).name '/'];
    A=dir([directory 'l*.mat']);
    for j=1:length(A)
        datafiles(k)={[directory A(j).name]};
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
    end
end

n=length(busMap);
arr=cell(n);
dpt=cell(n);
for i=1:length(datafiles)
    load(datafiles{i});
    names={table.name};
    ids={table.id};
    
    for j=1:length(names)
    end
end
