clear all

textFile(1)={'l72_d1_a.txt'};
xmlFile(1)={'Ultra_72_140929_150426.xml'};

index=find(char(textFile)=='_');
f = char(textFile);

% Läs in riktning och fotnot
dir = str2num(f(index(1)+2:index(2)-1))
footnote = upper(f(index(2)+1:end-4))

% Loopa över alla senare
file_idTXT = fopen(char(textFile(1)),'r','n','UTF-8');
file_idXML = fopen(char(xmlFile(1)),'r','n','UTF-8');

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
k=1;%index för monThr
while (~feof(file_idXML)) & (isempty(strfind(A,'</Direction>')))
    A = fgets(file_idXML);
    
    % Placera filpekaren enligt riktning(direction:1,2)
    if corr_dir==0 && dir == 2
        while isempty(strfind(A,'</Direction>'))
            A = fgets(file_idXML);
        end
        corr_dir = 1
        A = fgets(file_idXML);
    end
    
    if ~(isempty(strfind(A,'<Cols>')))
        
         while isempty(strfind(A,'</Cols>')) %Läser in alla busshållplatser som linjen stannar vid.

            if strcmp(A(9:10),'<C')
                col_pos = str2double(A(19));
                A = fgets(file_idXML);
                end_index = strfind(A,'<');
                bus_stop=A(31:end_index(2)-1);
                
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
   % while~isempty(strfind(A,'</DayTypes>'))
    %    A=fgets(file_idXML)
                   
            if ~(isempty(strfind(A, '<DayType>')))
                A=fgets(file_idXML);
                end_index = findstr(A,'<');
                day_name = A(20:end_index(2)-1); %Sparar vilka dagar denna resa gäller
                %A=fgets(file_idXML);
                if ~isempty(strfind(day_name,'måndag-fredag'))
                    A=fgets(file_idXML);
                    while isempty(strfind(A,'</Rows>')) %Läser in avgångstider för resan.
                        
                      if ~isempty(strfind(A,'<Time pos="'))
                            row_pos = 2double(A(19));
                            A=fgets(file_idXML);
                            end_index = findstr(A,'<');
                            dept_time_str = A(39:end_index(2)-1)
                            monThr(row_pos+1).dep=dept_time_str;
                            A=fgets(file_idXML);
                            if ~isempty(strfind(A,'<TimeFootnoteId>'))
                                A
                            end   
                            k=k+1;
                      end
                      
                        
                      if ~isempty(strfind(A,strcat('<Time pos="',num2str(stop(1).pos))))
                        A=fgets(file_idXML);
                        end_index = findstr(A,'<');
                        dept_time_str = A(39:end_index(2)-1)
                        monThr(k).dep=dept_time_str;
                        k=k+1;
                      end
                      %else if 
                      A=fgets(file_idXML);
                    end
                end
                if ~isempty(strfind(day_name,'fredag'))
                    %fortsätt
                end
            end
                
    A=fgets(file_idXML);
end