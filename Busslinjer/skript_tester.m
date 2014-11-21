clear 
clc

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

% Linje 2
textFile(13) = {'Fotnoter/2/l2_d1_.txt'};
textFile(14) = {'Fotnoter/2/l2_d1_d.txt'};
textFile(15) = {'Fotnoter/2/l2_d1_e.txt'};
textFile(16) = {'Fotnoter/2/l2_d1_g.txt'};

textFile(17) = {'Fotnoter/2/l2_d2_.txt'};
textFile(18) = {'Fotnoter/2/l2_d2_a.txt'};
textFile(19) = {'Fotnoter/2/l2_d2_c.txt'};
textFile(20) = {'Fotnoter/2/l2_d2_h.txt'};



[table,fotnoter] = BussData(textFile(13),xmlFile(2));
