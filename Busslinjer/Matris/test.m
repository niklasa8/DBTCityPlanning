f={};
k=1;
BussData=dir('BussData');
for i=3:length(BussData)
    directory=['BussData/' BussData(i).name '/'];
    A=dir([directory 'l*.mat']);
    for j=1:length(A)
        f(k)={[directory A(j).name]};
        k=k+1;
    end
end

arr=cell(200,200);
dep=cell(200,200);