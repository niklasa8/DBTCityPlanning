function n=check_footnote_txt_files()
textfiles={};
k=1;
BussData=dir('../Fotnoter');
for i=3:length(BussData)
    directory=['../Fotnoter/' BussData(i).name '/'];
    A=dir([directory 'l*.txt']);
    for j=1:length(A)
        textfiles(k)={[directory A(j).name]};
        k=k+1;
    end
end

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
            Names=[Names A(1)];
            IDs=[IDs A(2)];
            file_history=[file_history i];
            
            disp(' ');
            disp('ID match and name difference: ');
            disp(IDs(ID_index));
            disp(textfiles(i));
            disp(A(1));
            disp(textfiles(file_history(ID_index)));
            disp(Names(ID_index));
        elseif ~ID_present && Name_present            
            Names=[Names A(1)];
            IDs=[IDs A(2)];
            file_history=[file_history i];
            
            if  ~strcmp(A{1},'Universitetssjukhuset') && ...
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
    end
    fclose(file_id);
end

[~, I]=sort(Names);
sorted_data=[Names(I); IDs(I)]';

fid1=fopen('sorted_data_for_reading_footnote.txt','wt');
fid2=fopen('sorted_data_tabbed_footnote.txt', 'wt');
fid3=fopen('sorted_data_semicolon_footnote.txt', 'wt');
[rows,cols]=size(sorted_data);
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