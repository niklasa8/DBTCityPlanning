function table = BussData2(textFile,xmlFile)

index=find(char(textFile)=='_');
f = char(textFile);

% L�s in riktning och fotnot
dir = str2num(f(index(1)+2:index(2)-1))
fileFnote = upper(f(index(2)+1:end-4))

% Loopa �ver alla senare
file_idTXT = fopen(char(textFile),'r','n','UTF-8');

% L�s in bussh�llplatser fr�n fil
stopnr=1;
while ~feof(file_idTXT)    
    B = fgets(file_idTXT);
    c=strsplit(char(B),'\t');
    stop(stopnr).name=c(1);
    stop(stopnr).id=c(2);
    stop(stopnr).MT = [];
    stop(stopnr).F = [];
    stop(stopnr).L = [];
    stop(stopnr).S = [];
    stopnr=stopnr+1;        
end

% L�s xml-fil
xDoc = xmlread(char(xmlFile));
dirList = xDoc.getElementsByTagName('Direction');
direction = dirList.item(dir-1);
colList = direction.item(3).getChildNodes;
dayTypes = direction.item(5).getChildNodes;

% Hantera bussh�llplatser
for k=1:2:colList.getLength-1
    pos = colList.item(k).getAttribute('pos')    
    name = colList.item(k).item(1).getTextContent
    % Lagra pos-nr fr�n xmlfil f�r h�llplatsen
    for i=1:stopnr-1
        if(strcmp(stop(i).name,name))
            stop(i).pos = str2num(char(pos));
        end
    end  
end

% Hantera busstider
for k=1:2:dayTypes.getLength-1
    dayName = char(dayTypes.item(k).item(1).getTextContent);
    row = dayTypes.item(k).item(3).item(1);
    times = row.item(7);
    tripNoteList = row.getElementsByTagName('TripFootnoteId');
    tripFootnote = '';
    
    % Om det finns en tripfootnote
    if tripNoteList.getLength > 0
        for i=0:tripNoteList.getLength-1           
            tripFootnote = strcat(tripFootnote, char(tripNoteList.item(i).getTextContent));
        end
    end
    
    % F�r varje time-element
    for j=1:2:times.getLength-1
        timepos = str2num(times.item(j).getAttribute('pos'));
        timeNoteList = times.item(j).getElementsByTagName('TimeFootnoteId');
        depArrTime = char(times.item(j).item(1).getTextContent);              
        timeFootnote = '';
        
        % Om det finns en timefootnote
        if timeNoteList.getLength > 0
            for i=0:timeNoteList.getLength-1           
                timeFootnote = strcat(timeFootnote, char(timeNoteList.item(i).getTextContent));
            end            
        end
               
        % L�gg till avg�ng om fotnoter �r identiska
        footNote = strcat(timeFootnote,tripFootnote);
        corr_fnote = false;
        if (length(footNote) == length(fileFnote)) && ~strcmp(depArrTime,'x')
            corr_fnote = true;
            for i=1:length(fileFnote)                
               if isempty(strfind(footNote, fileFnote(i)))
                   corr_fnote = false;
               end
            end
            
            if corr_fnote
                for i=1:stopnr-1
                    if stop(i).pos == timepos
                        % konvertera departure/arrival-time till double
                        nums = strsplit(depArrTime,':');
                        depArrTime = str2double(nums(1)) + str2double(nums(2))/100; 
                        % l�gg till tid i tidtabell f�r h�llplats
                        if strcmp(dayName,'m�ndag-fredag')
                        	stop(i).MT = [stop(i).MT,depArrTime];                               
                        end
                        if strcmp(dayName,'fredag')
                            stop(i).F = [stop(i).F,depArrTime];
                        end
                        if strcmp(dayName,'l�rdag')
                            stop(i).L = [stop(i).L,depArrTime];    
                        end
                        if strcmp(dayName,'s�ndag')
                            stop(i).S = [stop(i).S,depArrTime];
                        end

                    end
                end                      
            end
        end                   
    end 
    
end

% S�tt ihop m�ndag-fredag med de speciella tiderna f�r fredag
for i=1:stopnr-1    
    if length(stop(i).MT) > 0
        MT = stop(i).MT;
        F = stop(i).F;
        F_merge = sort(cat(2,MT,F));
        stop(i).F = F_merge;
    end
end

table = stop;

