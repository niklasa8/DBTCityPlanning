function n=check_footnote_mat_files()
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
datafiles

Names={};
IDs={};
file_history=[];
clc
for i=1:length(datafiles)
    data=load(datafiles{i});
    data=data.table;
    for j=1:length(data)
        name=data(j).name;
        id=data(j).id;
        
        %Check duplicity
        [ID_present, ID_index]=ismember(id, IDs);
        [Name_present, Name_index]=ismember(name, Names);
        if ~ID_present && ~Name_present
            Names=[Names name];
            IDs=[IDs id];
            file_history=[file_history i];
        elseif ID_present && ~Name_present
            disp(' ');
            disp('ID match and name difference: ');
            disp(IDs(ID_index));
            disp(datafiles(i));
            disp(name);
            disp(datafiles(file_history(ID_index)));
            disp(Names(ID_index));
        elseif ~ID_present && Name_present && ...
                ~strcmp(name(1),'Universitetssjukhuset') && ...
                ~strcmp(name(1),'Nygatan') && ...
                ~strcmp(name(1),'Varvsgatan') && ...
                ~strcmp(name(1),'Järnvägstorget') && ...
                ~strcmp(name(1),'Obbolavägen')
                
            disp(' ');
            disp('Name match and ID difference: ');
            disp(Names(Name_index));
            disp(datafiles(i));
            disp(id);
            disp(datafiles(file_history(Name_index)));
            disp(IDs{Name_index});
        end
    end
end

%Sortera all data i bokstavsordning
[B, I]=sort(Names);
sorted_data=[Names(I); IDs(I)]';

%Skriv data till filer
fid1=fopen('sorted_data_for_reading2.txt','wt');
fid2=fopen('sorted_data_tabbed2.txt', 'wt');
fid3=fopen('sorted_data_semicolon2.txt', 'wt');
[rows,~]=size(sorted_data);
for i=1:rows
      fprintf(fid1,'%-30s',sorted_data{i,1});
      fprintf(fid1,'%s\n',sorted_data{i,end});
      
      fprintf(fid2,'%s\t',sorted_data{i,1});
      fprintf(fid2,'%s\n',sorted_data{i,2});
      
      fprintf(fid3,'%s;',sorted_data{i,1});
      fprintf(fid3,'%s\n',sorted_data{i,2});
end
fclose(fid1);
fclose(fid2);
fclose(fid3);
n=rows;
end