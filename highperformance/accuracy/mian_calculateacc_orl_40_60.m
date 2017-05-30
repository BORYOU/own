% need Accuracy.m rd.m
% for highperformance result on 11_5 

% database = 'Orl.mat';                basestr = 'ORLallbest';
% database = 'Orl_shelter_30_30.mat';  basestr = 'sORL30allbest';
% database = 'Orl_shelter_40_40.mat';  basestr = 'sORL40allbest';
% database = 'Orl_shelter_50_50.mat';  basestr = 'sORL50allbest';
% database = 'YaleB_c.mat'          ;  basestr = 'YaleBallbest' ;
database = '../highperformanceData/Orl_shelter_40_percent_60/Orl_shelter_40_percent_60.mat'  ;  
basestr = '../highperformanceData/Orl_shelter_40_percent_60/Orl_shelter_40_percent_60allbest' ;
basestr2 = 'Orl_shelter_40_percent_60allbest';
load(database);
%{
input variables: 
    final result: H, HG, HGd; 
    if not calculate H, HG, set them to 0;
default parameters:
    i = 1:1300
    k = 50 - 140; 160; 180; 200;
    gammaall = [1e-8, 2e-8, 3e-8, 4e-8, 5e-8, 6e-8, 7e-8, 8e-8, 9e-8,1e-7];
    all = [0.1,0.3,0.5,0.7,0.9,3,5,7,9,11];
    k1gamma1a1...10 k1gamma2a1..10 ... k13gamma10a10
%}

% calculate Accuracy

knum = 13;  %%%% Input  number of input k

fold = 3;
allnumlist = [1:1000,1101:1200,1301:1400,1501:1600];
%allnumlist = [1101:1200,1301:1400,1501:1600]; for big three k, knum set to 3
for index = 1:knum*100,
    index
    allnum = allnumlist(index);
    load([basestr,num2str(allnum),'.mat']);
    
    nn = rem(allnum,100);
    if nn == 1
        NA = Accuracy(fold,A,Y,H);
        AccuracyN_ASCG=NA.acc;
        AccuracyN_ASCGvar=NA.var;
        num = floor((index-1)/100) + 1;
        
        AccuracyN_ASCGallfinal(num) = AccuracyN_ASCG;
        AccuracyN_ASCGvarallfinal(num) = AccuracyN_ASCGvar;
    end
    
    hh = rem(allnum,10);
    if hh == 1
        GA = Accuracy(fold,A,Y,HG);
        AccuracyG_ASCG=GA.acc;
        AccuracyG_ASCGvar=GA.var;
        num = floor((index-1)/10) + 1;
        
        AccuracyG_ASCGallfinal(num) = AccuracyG_ASCG;
        AccuracyG_ASCGvarallfinal(num) = AccuracyG_ASCGvar;
    end
    
    GdA = Accuracy(fold,A,Y,HGd);
    AccuracyGd_ASCG=GdA.acc;
    AccuracyGd_ASCGvar=GdA.var;
    
    AccuracyGd_ASCGallfinal(index) = AccuracyGd_ASCG;
    AccuracyGd_ASCGvarallfinal(index) = AccuracyGd_ASCGvar;
end

% reshape result, one cow for one rank

AccuracyG_ASCGallfinal     = reshape(AccuracyG_ASCGallfinal    ,10 ,knum);
AccuracyG_ASCGvarallfinal  = reshape(AccuracyG_ASCGvarallfinal ,10 ,knum);
AccuracyGd_ASCGallfinal    = reshape(AccuracyGd_ASCGallfinal   ,100,knum);
AccuracyGd_ASCGvarallfinal = reshape(AccuracyGd_ASCGvarallfinal,100,knum);

% get max acc for each cow
AccuracyN_ASCG = AccuracyN_ASCGallfinal;
[AccuracyG_ASCG,Gi] = max(AccuracyG_ASCGallfinal);
[AccuracyGd_ASCG,Gdi] = max(AccuracyGd_ASCGallfinal);
% get var 
for i = 1:knum
    AccuracyN_ASCGvar(i) = AccuracyN_ASCGvarallfinal(i);
    AccuracyG_ASCGvar(i) = AccuracyG_ASCGvarallfinal(Gi(i),i);
    AccuracyGd_ASCGvar(i) = AccuracyGd_ASCGvarallfinal(Gdi(i),i);
end
% save file
save([basestr2,'final1to',num2str(knum),'.mat'],...
'AccuracyN_ASCGallfinal','AccuracyN_ASCGvarallfinal',...
'AccuracyG_ASCGallfinal','AccuracyG_ASCGvarallfinal', ...
'AccuracyGd_ASCGallfinal','AccuracyGd_ASCGvarallfinal',...
'AccuracyN_ASCG','AccuracyG_ASCG','AccuracyGd_ASCG',...
'AccuracyN_ASCGvar','AccuracyG_ASCGvar','AccuracyGd_ASCGvar');
 