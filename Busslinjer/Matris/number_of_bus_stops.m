function n=number_of_bus_stops(bus_data_directory)
datafiles={};
k=1;
BussData=dir(bus_data_directory);
for i=3:length(BussData)
    directory=['../BussData/' BussData(i).name '/'];
    A=dir([directory 'l*.mat']);
    for j=1:length(A)
        datafiles(k)={[directory A(j).name]};
        k=k+1;
    end
end
datafiles

Names={};
IDs={};
for i=1:length(datafiles)
    data=load(datafiles{i});
    data=data.table;
    for j=1:length(data)
        name=data(j).name;
        id=data(j).id;
        
        if ~ismember(id, IDs)
            IDs=[IDs id];
        end
        
        if ~ismember(name, Names);
            Names=[Names name];
        end
    end
end

n=length(IDs);
n=length(Names);
end