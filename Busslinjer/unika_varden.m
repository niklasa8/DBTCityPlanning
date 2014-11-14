textfiles={'Linje1.txt','Linje2.txt','Linje3.txt','Linje4.txt',...
    'Linje5.txt','Linje6.txt','Linje7.txt','Linje8.txt',...
    'Linje9.txt','Linje72.txt','Linje73.txt','Linje75.txt',...
    'Linje76.txt','Linje78.txt','Linje80.txt','Linje81.txt'};

Names={};
IDs={};
file_history=[];
clc
for i=1:length(textfiles)
    file_id=fopen(char(textfiles(i)), 'r', 'n', 'UTF-8');
    while ~feof(file_id) %Read until end of file.
        %Read next line
        A=fgetl(file_id);
        %Ignore blank lines
        while isempty(A)
            A=fgetl(file_id);
        end
        %Split line at tab. The data is stored in a cell array.
        A=strsplit(A, '\t');
        
        %Check duplicity
        [ID_present, ID_index]=ismember(A(2), IDs);
        [Name_present, Name_index]=ismember(A(1), Names);
        if ~ID_present && ~Name_present
            Names=[Names A(1)];
            IDs=[IDs A(2)];
            file_history=[file_history i];
        elseif ID_present && ~Name_present
            disp(' ');
            disp('ID match and name difference: ');
            disp(IDs(ID_index));
            disp(textfiles(i));
            disp(A(1));
            disp(textfiles(file_history(ID_index)));
            disp(Names(ID_index));
        elseif ~ID_present && Name_present && ...
                ~strcmp(A{1},'Universitetssjukhuset') && ...
                ~strcmp(A{1},'Nygatan') && ...
                ~strcmp(A{1},'Varvsgatan') && ...
                ~strcmp(A{1},'Järnvägstorget') && ...
                ~strcmp(A{1},'Obbolavägen')
                
            disp(' ');
            disp('Name match and ID difference: ');
            disp(Names(Name_index));
            disp(textfiles(i));
            disp(A(2));
            disp(textfiles(file_history(Name_index)));
            disp(IDs(Name_index));
        end
    end
    fclose(file_id);
end

[B, I]=sort(Names);
sorted_data=[Names(I); IDs(I)]';

fid1=fopen('sorted_data_for_reading.txt','wt');
fid2=fopen('sorted_data_tabbed.txt', 'wt');
[rows,cols]=size(sorted_data);
for i=1:rows
      fprintf(fid1,'%-30s',sorted_data{i,1});
      fprintf(fid1,'%s\n',sorted_data{i,end});
      
      fprintf(fid2,'%s\t',sorted_data{i,1});
      fprintf(fid2,'%s\n',sorted_data{i,2});
end
fclose(fid1);
fclose(fid2);