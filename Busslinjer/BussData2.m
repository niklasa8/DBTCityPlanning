clear all

textFile(1)={'Fotnoter/72/l72_d1_a.txt'};
xmlFile(1)={'XML/Ultra_1_140929_150426.xml'};

index=find(char(textFile)=='_');
f = char(textFile);

% Läs in riktning och fotnot
dir = str2num(f(index(1)+2:index(2)-1))
fileFnote = upper(f(index(2)+1:end-4))

% Loopa över alla senare
file_idTXT = fopen(char(textFile(1)),'r','n','UTF-8');

% Läs in busshållplatser från fil
stopnr=1;
while ~feof(file_idTXT)    
    B = fgets(file_idTXT);
    c=strsplit(char(B),'\t');
    stop(stopnr).name=c(1);
    stop(stopnr).id=c(2);
    stopnr=stopnr+1;        
end

% Läs xml-fil
xDoc = xmlread(char(xmlFile(1)));
dirList = xDoc.getElementsByTagName('Direction');
direction = dirList.item(dir-1);
colList = direction.item(3).getChildNodes;
dayTypes = direction.item(5).getChildNodes;

% Hantera busshållplatser
for k=1:2:colList.getLength-1
    pos = colList.item(k).getAttribute('pos')    
    name = colList.item(k).item(1).getTextContent
    % Lagra pos-nr från xmlfil för hållplatsen
    for i=1:stopnr-1
        if(strcmp(stop(i).name,name))
            stop(i).pos = str2num(char(pos));
        end
    end  
end

% Hantera busstider
for k=1:2:dayTypes.getLength-1
    dayName = dayTypes.item(k).item(1).getTextContent;
    row = dayTypes.item(k).item(3).item(1);
    times = row.item(7);
    tripNoteList = row.getElementsByTagName('TripFootnoteId');
    tripFootnote = '';
%     for i=0:tfnote.getLength-1
%         tfnote.item(i).getTextContent
%     end
    
    
    % Om det finns en tripfootnote
    if tripNoteList.getLength > 0
        for i=0:tripNoteList.getLength-1           
            tripFootnote = strcat(tripFootnote, char(tripNoteList.item(i).getTextContent));
        end
    end
    
    % För varje time-element
    for j=1:2:times.getLength-1
        timepos = times.item(j).getAttribute('pos');
        timeNoteList = times.item(j).getElementsByTagName('TimeFootnoteId');
        depArrTime = times.item(j).item(1).getTextContent;
        timeFootnote = '';
        
        % Om det finns en timefootnote
        if timeNoteList.getLength > 0
            timeFootnote = char(times.item(j).item(3).getTextContent);
        end
        
        % Lägg till avgång om fotnoter stämmer
        if ~isempty(strfind(fileFnote,timeFootnote)) && ...
            ~isempty(strfind(fileFnote,tripFootnote))
            disp('MATCH')
            for i=1:stopnr-1
                if stop(i).pos == timepos
%                     stop(i).times = 
                end
            end
        end
        
    end
    
    
end


