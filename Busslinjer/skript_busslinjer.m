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
xmlFile(12)={'XML/Ultra_75_140929_150426.xml'};
xmlFile(13)={'XML/Ultra_76_140929_150426.xml'};
xmlFile(14)={'XML/Ultra_78_140929_150426.xml'};
xmlFile(15)={'XML/Ultra_80_140929_150426.xml'};
xmlFile(16)={'XML/Ultra_81_140929_150426.xml'};

%% Text-filer
num_notes = zeros(1,16);

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
textFile(11) = {'Fotnoter/1/l1_d2_k.txt'};
textFile(12) = {'Fotnoter/1/l1_d2_mn.txt'};
num_notes(1) = 12;

% Linje 2
textFile(13) = {'Fotnoter/2/l2_d1_.txt'};
textFile(14) = {'Fotnoter/2/l2_d1_d.txt'};
textFile(15) = {'Fotnoter/2/l2_d1_e.txt'};
textFile(16) = {'Fotnoter/2/l2_d1_g.txt'};

textFile(17) = {'Fotnoter/2/l2_d2_.txt'};
textFile(18) = {'Fotnoter/2/l2_d2_a.txt'};
textFile(19) = {'Fotnoter/2/l2_d2_c.txt'};
textFile(20) = {'Fotnoter/2/l2_d2_h.txt'};
num_notes(2) = 8;

% Linje 3
textFile(21) = {'Fotnoter/3/l3_d1_.txt'};
textFile(22) = {'Fotnoter/3/l3_d2_.txt'};
num_notes(3) = 2;

% Linje 4
textFile(23) = {'Fotnoter/4/l4_d1_.txt'};
textFile(24) = {'Fotnoter/4/l4_d2_.txt'};
num_notes(4) = 2;

% Linje 5
textFile(25) = {'Fotnoter/5/l5_d1_.txt'};
textFile(26) = {'Fotnoter/5/l5_d1_c.txt'};
textFile(27) = {'Fotnoter/5/l5_d1_e.txt'};
textFile(28) = {'Fotnoter/5/l5_d1_ce.txt'};
textFile(29) = {'Fotnoter/5/l5_d1_k.txt'};
textFile(30) = {'Fotnoter/5/l5_d1_kc.txt'};
textFile(31) = {'Fotnoter/5/l5_d1_v.txt'};
num_notes(5) = 7;

% Linje 6
textFile(32) = {'Fotnoter/6/l6_d1_.txt'};
textFile(33) = {'Fotnoter/6/l6_d2_.txt'};

%% Spara data i mat filer

for i=23:24%max(size(textFile))
    dataName = textFile{i}(10:end-4);
    path = strcat('BussData/',dataName,'.mat');
    [table,fotnoter] = BussData(textFile(i),xmlFile(1));
    save(path,'table')
%     save(strcat('BussData/',dataName,'_Fotnoter.mat'),'fotnoter')
end

disp('...Färdig')