%Function timeToMin 5.05 (h.min)->305 (min)
timeToMin = @(t) mod(t,1)*100+floor(t)*60;

datafiles={};
k=1;
BussData=dir();
for h=3:length(BussData)
    directory=[BussData(h).name '/'];
    A=dir([directory 'l*.mat']);
    for j=1:length(A)
        datafiles(k)={[directory A(j).name]};
        k=k+1;
    end
end
datafiles



for i=1:length(datafiles)
    load(datafiles{i});

    for j=1:length(table)-1
        
        MT1=table(j).MT; F1=table(j).F; L1=table(j).L;
        S1=table(j).S; days1={MT1 F1 L1 S1};
        MT2=table(j+1).MT; F2=table(j+1).F; L2=table(j+1).L;
        S2=table(j+1).S; days2={MT2 F2 L2 S2};
    
        for k=1:4
            t1=days1{k}; t1=timeToMin(t1); t1=mod(t1-239,1440);
            t2=days2{k}; t2=timeToMin(t2); t2=mod(t2-239,1440);
            
            if find(t2-t1<0)
                disp('Error');
                datafiles{i}, j, k
            end
        end
    end
end

        