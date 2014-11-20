clear all 
clc

disp('Genererar bussdata....')
%% XML-filer

xmlFile(1)={'XML/Ultra_1_140929_150426.xml'};
xmlFile(2)={'XML/Ultra_2_140929_150426.xml'};
xmlFile(3)={'XML/Ultra_3_140929_150426.xml'};
xmlFile(4)={'XML/Ultra_4_140929_150426.xml'};
xmlFile(5)={'XML/Ultra_5_140929_150426.xml'};
xmlFile(6)={'XML/Ultra_6_140929_150426.xml'};
xmlFile(7)={'XML/Ultra_7_140929_150426.xml'};
xmlFile(8)={'XML/Ultra_8_140929_150426.xml'};
xmlFile(9)={'XML/Ultra_9_140929_150426.xml'};
xmlFile(10)={'XML/Ultra_72_140929_150426.xml'};
xmlFile(11)={'XML/Ultra_73_140929_150426.xml'};
xmlFile(11)={'XML/Ultra_75_140929_150426.xml'};
xmlFile(11)={'XML/Ultra_76_140929_150426.xml'};
xmlFile(11)={'XML/Ultra_78_140929_150426.xml'};
xmlFile(11)={'XML/Ultra_80_140929_150426.xml'};
xmlFile(11)={'XML/Ultra_81_140929_150426.xml'};

%% Text-filer

% Linje 1
textFile(1) = {'Fotnoter/1/l1_d1_.txt'};
textFile(2) = {'Fotnoter/1/l1_d1_d.txt'};
textFile(3) = {'Fotnoter/1/l1_d1_g.txt'};
textFile(4) = {'Fotnoter/1/l1_d1_gc.txt'};
textFile(5) = {'Fotnoter/1/l1_d1_gk.txt'};
textFile(6) = {'Fotnoter/1/l1_d1_k.txt'};
textFile(7) = {'Fotnoter/1/l1_d1_kl.txt'};
textFile(8) = {'Fotnoter/1/l1_d1_mk.txt'};
textFile(9) = {'Fotnoter/1/l1_d1_n.txt'};

textFile(10) = {'Fotnoter/1/l1_d2_.txt'};
textFile(10) = {'Fotnoter/1/l1_d2_k.txt'};
textFile(10) = {'Fotnoter/1/l1_d2_mn.txt'};

for i=1:max(size(textFile))
    dataName = textFile{i}(10:end-4);
    [table,fotnoter] = BussData2_test(textFile(i),xmlFile(1));
    save(strcat('BussData/',dataName,'.mat'),'table')
%     save(strcat('BussData/',dataName,'_Fotnoter.mat'),'fotnoter')
end
[table,fotnoter] = BussData2_test(textFile(3),xmlFile(1));


disp('...Färdig')