clear all

textFile(1)={'Fotnoter/72/l72_d1_a.txt'};
xmlFile(1)={'XML/Ultra_72_140929_150426.xml'};

index=find(char(textFile)=='_');
f = char(textFile);

% Läs in riktning och fotnot
dir = str2num(f(index(1)+2:index(2)-1))
footnote = upper(f(index(2)+1:end-4))

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
colList = direction.item(2);
head = direction.item
for k=0 : colList.getLength-1
    pos = colList.item(k).getAttribute('pos');
    char(pos)
end
% head.getTextContent
