clear all
textFile(1)={'l72_d1_a.txt'};
xmlFile(1)={'Ultra_72_140929_150426.xml'};
index=find(char(textFile)=='_');
f=char(textFile)
f(index(2)+1:end-4)
%Loopa över alla senare
file_idTXT = fopen(char(textFile(1)));
file_idXML = fopen(char(xmlFile(1)));
stopnr=1;
while ~feof(file_idTXT)    
    B = fgets(file_idTXT);
    c=strsplit(char(B),'\t');
    stop(stopnr).name=c(1);
    stop(stopnr).id=c(2);
    stopnr=stopnr+1;
        
end
while ~feof(file_idXML)
    A=fgets(file_idXML);
    if(strfind(A,'<Cols>'))
        
         while isempty(strfind(A,'</Cols>')) %Läser in alla busshållplatser som linjen stannar vid.

            if strcmp(A(9:10),'<C')
                col_pos = str2double(A(19))
                A = fgets(file_idXML);
                end_index = strfind(A,'<');
                bus_stop=A(31:end_index(2)-1)
                
                for i=1:stopnr-1
                    if(strcmp(stop(i).name,bus_stop))
                        stop(i).pos=col_pos;
                    end
                end
            end
            A=fgets(file_idXML);
         end
    end
    
end