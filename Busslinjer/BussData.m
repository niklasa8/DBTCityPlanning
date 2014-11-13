clear all

textFile(1)={'l72_d1_a.txt'};
xmlFile(1)={'Ultra_72_140929_150426.xml'};

index=find(char(textFile)=='_');
f = char(textFile);

% Läs in riktning och fotnot
dir = str2num(f(index(1)+2:index(2)-1))
footnote = f(index(2)+1:end-4)

% Loopa över alla senare
file_idTXT = fopen(char(textFile(1)));
file_idXML = fopen(char(xmlFile(1)));

% Läs in busshållplatser från fil
stopnr=1;
while ~feof(file_idTXT)    
    B = fgets(file_idTXT);
    c=strsplit(char(B),'\t');
    stop(stopnr).name=c(1);
    stop(stopnr).id=c(2);
    stopnr=stopnr+1;        
end

A = '';
corr_dir = 0;

% Läs in data från xmlfil
while (~feof(file_idXML)) & (isempty(strfind(A,'</Direction>')))
    A = fgets(file_idXML);
    
    % Placera filpekaren enligt riktning(direction:1,2)
    if corr_dir==0 && dir == 2
        while isempty(strfind(A,'</Direction>'))
            A = fgets(file_idXML)
        end
        corr_dir = 1;
        A = fgets(file_idXML);
    end
    
    if ~(isempty(strfind(A,'<Cols>')))
        
         while isempty(strfind(A,'</Cols>')) %Läser in alla busshållplatser som linjen stannar vid.

            if strcmp(A(9:10),'<C')
                col_pos = str2double(A(19))
                A = fgets(file_idXML);
                end_index = strfind(A,'<');
                bus_stop=A(31:end_index(2)-1)
                
                % Lagra pos-nr från xmlfil för hållplatsen
                for i=1:stopnr-1
                    if(strcmp(stop(i).name,bus_stop))
                        stop(i).pos=col_pos;
                    end
                end       
            end
            
            A=fgets(file_idXML);
         end
    end
    
    if ~(isempty(strfind(A, '<DayTypes>')))
        if ~(isempty(strfind(A, '<DayType>')))
            
            if ~(isempty(strfind(A, '<DayName>')))
                
            end

            
        end
    end
end