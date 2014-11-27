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
    
% Linje 3
textFile(21) = {'Fotnoter/3/l3_d1_.txt'};
textFile(22) = {'Fotnoter/3/l3_d2_.txt'};

% Linje 4
textFile(23) = {'Fotnoter/4/l4_d1_.txt'};
textFile(24) = {'Fotnoter/4/l4_d2_.txt'};

% Linje 5
textFile(25) = {'Fotnoter/5/l5_d1_.txt'};
textFile(26) = {'Fotnoter/5/l5_d1_g.txt'};
textFile(27) = {'Fotnoter/5/l5_d1_c.txt'};
textFile(28) = {'Fotnoter/5/l5_d1_e.txt'};
textFile(29) = {'Fotnoter/5/l5_d1_eg.txt'};
textFile(30) = {'Fotnoter/5/l5_d1_ce.txt'};
textFile(31) = {'Fotnoter/5/l5_d1_k.txt'};
textFile(32) = {'Fotnoter/5/l5_d1_kc.txt'};
textFile(33) = {'Fotnoter/5/l5_d1_v.txt'};
textFile(34) = {'Fotnoter/5/l5_d2_.txt'};
textFile(35) = {'Fotnoter/5/l5_d2_a.txt'};
textFile(36) = {'Fotnoter/5/l5_d2_av.txt'};
textFile(37) = {'Fotnoter/5/l5_d2_kb.txt'};
textFile(38) = {'Fotnoter/5/l5_d2_v.txt'};

% Linje 6
textFile(39) = {'Fotnoter/6/l6_d1_.txt'};
textFile(40) = {'Fotnoter/6/l6_d2_.txt'};

% Linje 7
textFile(41) = {'Fotnoter/7/l7_d1_.txt'};
textFile(42) = {'Fotnoter/7/l7_d1_a.txt'};
textFile(43) = {'Fotnoter/7/l7_d1_b.txt'};
textFile(44) = {'Fotnoter/7/l7_d2_.txt'};
textFile(45) = {'Fotnoter/7/l7_d2_v.txt'};

% Linje 8
textFile(46) = {'Fotnoter/8/l8_d1_.txt'};
textFile(47) = {'Fotnoter/8/l8_d1_k.txt'};
textFile(48) = {'Fotnoter/8/l8_d1_u.txt'};
textFile(49) = {'Fotnoter/8/l8_d2_.txt'};
textFile(50) = {'Fotnoter/8/l8_d2_k.txt'};

% Linje 9
textFile(51) = {'Fotnoter/9/l9_d1_.txt'};
textFile(52) = {'Fotnoter/9/l9_d1_k.txt'};
textFile(53) = {'Fotnoter/9/l9_d1_kc.txt'};
textFile(54) = {'Fotnoter/9/l9_d1_v.txt'};
textFile(55) = {'Fotnoter/9/l9_d2_.txt'};
textFile(56) = {'Fotnoter/9/l9_d2_e.txt'};
textFile(57) = {'Fotnoter/9/l9_d2_a.txt'};
textFile(58) = {'Fotnoter/9/l9_d2_b.txt'};
textFile(59) = {'Fotnoter/9/l9_d2_k.txt'};

% Linje 72
textFile(60) = {'Fotnoter/72/l72_d1_a.txt'};
textFile(61) = {'Fotnoter/72/l72_d2_cd.txt'};

% Linje 73
textFile(62) = {'Fotnoter/73/l73_d1_a.txt'};

% Linje 75
textFile(63) = {'Fotnoter/75/l75_d1_.txt'};
textFile(64) = {'Fotnoter/75/l75_d2_.txt'};

% Linje 76
textFile(65) = {'Fotnoter/76/l76_d1_.txt'};

% Linje 78
textFile(66) = {'Fotnoter/78/l78_d1_z.txt'};
textFile(67) = {'Fotnoter/78/l78_d1_e.txt'};
textFile(68) = {'Fotnoter/78/l78_d1_g.txt'};
textFile(69) = {'Fotnoter/78/l78_d2_.txt'};
textFile(70) = {'Fotnoter/78/l78_d2_b.txt'};
textFile(71) = {'Fotnoter/78/l78_d2_c.txt'};

% Linje 80
textFile(72) = {'Fotnoter/80/l80_d1_a.txt'};
textFile(73) = {'Fotnoter/80/l80_d1_az.txt'};
textFile(74) = {'Fotnoter/80/l80_d2_a.txt'};
textFile(75) = {'Fotnoter/80/l80_d2_az.txt'};

% Linje 81
textFile(76) = {'Fotnoter/81/l81_d1_.txt'};
textFile(77) = {'Fotnoter/81/l81_d1_ac.txt'};
textFile(78) = {'Fotnoter/81/l81_d1_b.txt'};
textFile(79) = {'Fotnoter/81/l81_d2_.txt'};
textFile(80) = {'Fotnoter/81/l81_d2_e.txt'};


[table,fotnoter] = BussData(textFile(20),xmlFile(2));
