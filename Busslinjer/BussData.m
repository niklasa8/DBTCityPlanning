function [table, fnotes] = BussData(textFile,xmlFile)

index=find(char(textFile)=='_');
f = char(textFile);

% Läs in riktning och fotnot
dir = str2num(f(index(1)+2:index(2)-1));
fileFnote = upper(f(index(2)+1:end-4));
noteMap = containers.Map('KeyType','char','ValueType','int8'); % array med alla fotnotskombinationer i xmlfil

% Loopa över alla senare
file_idTXT = fopen(char(textFile),'r','n','UTF-8');

% Läs in busshållplatser från fil
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

% Läs xml-fil
xDoc = xmlread(char(xmlFile));
dirList = xDoc.getElementsByTagName('Direction');
direction = dirList.item(dir-1);
colList = direction.item(3).getChildNodes;
dayTypes = direction.item(5).getChildNodes;

% Hantera busshållplatser
for k=1:2:colList.getLength-1
    pos = colList.item(k).getAttribute('pos');    
    name = colList.item(k).item(1).getTextContent;
    % Lagra pos-nr från xmlfil för hållplatsen
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
    timeNoteList = row.getElementsByTagName('TimeFootnoteId');
    timeFootnote = '';

    
    % Om det finns en tripfootnote
    if tripNoteList.getLength > 0
        for i=0:tripNoteList.getLength-1
            % Ignorera fotnot F
            if ~strcmp(char(tripNoteList.item(i).getTextContent),'F')
                tripFootnote = strcat(tripFootnote, char(tripNoteList.item(i).getTextContent));
            end            
        end
    end
    
    % Om det finns timefootnotes spara dem
    if timeNoteList.getLength > 0
        for i=0:timeNoteList.getLength-1            
            if isempty(strfind(timeFootnote, char(timeNoteList.item(i).getTextContent))) && ...
                    isempty(strfind(tripFootnote, char(timeNoteList.item(i).getTextContent)))
                timeFootnote = strcat(timeFootnote, char(timeNoteList.item(i).getTextContent));
            end
        end            
    end
        
    footNote = strcat(timeFootnote,tripFootnote);  
    
    if ~isKey(noteMap,footNote)
        noteMap(footNote) = 1;
    else
        noteMap(footNote) = noteMap(footNote)+1;
    end
 
    corr_fnote = false;
    if length(footNote) == length(fileFnote)
        corr_fnote = true;
        for i=1:length(fileFnote)                
           if isempty(strfind(footNote, fileFnote(i)))
               corr_fnote = false;
           end
        end
        % Om fotnot i xmlfil stämmer med fotnot från textfil
        if corr_fnote
            % För varje time-element
            for j=1:2:times.getLength-1
                timepos = str2num(times.item(j).getAttribute('pos'));
                depArrTime = char(times.item(j).item(1).getTextContent);
                if ~strcmp(depArrTime,'x')
                    for i=1:stopnr-1
                        if stop(i).pos == timepos
                            % konvertera departure/arrival-time till double
                            nums = strsplit(depArrTime,':');
                            depArrTime = str2double(nums(1)) + str2double(nums(2))/100; 
                            % lägg till tid i tidtabell för hållplats
                            if strcmp(dayName,'måndag-fredag')
                                stop(i).MT = [stop(i).MT,depArrTime];                               
                            end
                            if strcmp(dayName,'fredag')
                                stop(i).F = [stop(i).F,depArrTime];
                            end
                            if strcmp(dayName,'lördag')
                                stop(i).L = [stop(i).L,depArrTime];    
                            end
                            if strcmp(dayName,'söndag')
                                stop(i).S = [stop(i).S,depArrTime];
                            end
                        end
                    end 
                end
            end
        end
    end               
    
    
end

% Sätt ihop måndag-fredag med de speciella tiderna för fredag
for i=1:stopnr-1    
    if length(stop(i).MT) > 0
        MT = stop(i).MT;
        F = stop(i).F;
        F_merge = sort(cat(2,MT,F));
        stop(i).F = F_merge;
    end
end

% Skapa cellarray av för alla fotnoter i xmlfil
fnotes = keys(noteMap)';
fnotes(:,2) = values(noteMap);
table = stop;

