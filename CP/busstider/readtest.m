function [Names, IDs, xDoc] = readtest(name, name2)
%Arrays to store values in.
format long
IDs=[];
Names=[];
file_id=fopen(name, 'r', 'n', 'UTF-8'); %Open file.
while ~feof(file_id) %Read until end of file.
    %Read line and split it at tab. The data is stored in a cell array.
    A=strsplit(fgetl(file_id),'\t');
    %Store the values in seperate arrays. Names is a cell array and IDs is
    %a numeric array.
    Names=[Names A(1)];
    IDs=[IDs str2num(A{2})];
end
fclose(file_id);

%file_id=fopen(name2, 'r+', 'n', 'UTF-8');
xDoc=xmlread('Ultra_73_140929_150426.xml');

cols_list=xDoc.getElementsByTagName('Cols');
start_stop=zeros(2,1);
for i=1:1%För båda riktningarna.
    i
    cols=cols_list.item(i-1);
    len=cols.getLength;
    
    for j=1:2:len-3 %För alla intervaller i XML-filen.
        %Identifiera intervallet i XML-filen.
        j
        col1=cols.item(j);
        col2=cols.item(j+2);
        stop_name1=col1.item(1).item(0).getData;
        stop_name2=col2.item(1).item(0).getData;
        
        %Identifiera intervallet i våra textfiler.
        for k=1:length(IDs)
            if strcmp(char(Names(k)),char(stop_name1))
                start_stop(1)=k
                Names(k)
            end
            if strcmp(char(Names(k)),char(stop_name2))
                start_stop(2)=k
                Names(k)
            end
        end
        for k=start_stop(1):start_stop(2)
            disp(Names(k))
        end
        
%        for k=start_stop(1)+1:start_stop(2)-1
    end
end