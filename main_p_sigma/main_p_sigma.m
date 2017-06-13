clc; clear all
dataall = {
     %'Orl_shelter_40_percent_20';
     %'Orl_shelter_40_percent_40';
     %'Orl_shelter_40_percent_60';
     %'Orl_shelter_40_percent_80';
%     'Orl_shelter_40_40';
    %'Orl_shelter_50_50';
    %'Orl_shelter_20_percent_20';
    'YaleB_c';
    'YaleB_c_shelter_10_10';
    %'YaleB_c_shelter_10_percent_20';
    %'YaleB_c_shelter_10_percent_60';
};
for dataindex = 1:length(dataall)
data = dataall{dataindex};
fprintf('%s\n',data);

load(fullfile('..','generateW',[data,'.mat'])); 

if data(1) == 'O'
k = 100; gamma = 1e-8; a = 9;
elseif data(1) == 'Y'
k = 130; gamma = 6e-8; a = 7;
end

maxiter =200; tol = 1e-17; timelimit = 1000000;
fold = 3; 

[M,N] = size(A); % M*N Îª¾ØÕóAµÄÎ¬Êý
% rng('default')
randn('state',1);
Winit = abs(randn(M,k)); Hinit = abs(randn(k,N));

if data(1) == 'O'
pall = 2:10; sigmaall = [sqrt(10)];%[sqrt(2),sqrt(10)];
elseif data(1) == 'Y'
%pall = 2:10; sigmaall = [sqrt(2),sqrt(5),sqrt(10),sqrt(15),sqrt(20)];
pall = 3:3:30; sigmaall = [sqrt(10)];
end
% sigmaall = [sqrt(2),sqrt(5),sqrt(10),sqrt(15),sqrt(20)];

HGAall = zeros(length(pall),length(sigmaall));
HGdAall = zeros(length(pall),length(sigmaall));
% outDirName = 'Orl_shelter_30_30_p_2_10_sigma_2_5_10_15_20';
% outDirName = 'Orl_shelter_40_40_p_2_10_sigma_2_10';
outDirName = [data, '_p_',num2str(pall(1)),'_',num2str(pall(end)),'_sigma_',num2str(sigmaall(1)),'_',num2str(sigmaall(end))];

if exist(outDirName,'dir') ~= 7
    mkdir(outDirName)
end

tic
for i = 1:length(pall)
    for j = 1:length(sigmaall)

        p = pall(i)
        sigma = sigmaall(j)
        
        dirName = ['p_',num2str(p),'_sigma_',num2str(sigma)];
        Wfilename = [data,'_p_',num2str(p),'_sigma_',num2str(sigma),'.mat'];
        outFileName = fullfile(outDirName,[data,'_p_',num2str(p),'_sigma_',num2str(sigma),'_acc.mat']);
        if exist(outFileName)
            continue
        end
        load(fullfile('..','generateW',dirName, Wfilename));
        W1 = W_hk_c; W2 = W_diff_c;
        DCol = full(sum(W1,2)); D = spdiags(DCol,0,N,N); L = D - W1; 
        
        HG = GNMF_ASCG_new_proximal_revised(A,Winit,Hinit,L,gamma,tol,maxiter);
    
        W = W1 + a*W2;
        DCol = full(sum(W,2)); D = spdiags(DCol,0,N,N); La = D - W;  
        
        HGd = GNMF_ASCG_new_proximal_revised(A,Winit,Hinit,La,gamma,tol,maxiter);
    
        HGA = Accuracy(3,A,Y,HG);
        AccuracyG_ASCG=HGA.acc;
        HGdA = Accuracy(3,A,Y,HGd);
        AccuracyGd_ASCG=HGdA.acc;
%        save(fullfile(outDirName,['Orl_shelter_30_30','_p_',num2str(p),'_sigma_',num2str(sigma),'_acc.mat']),'HGA','HGdA');
        
        save(outFileName ,'HGA','HGdA');
        HGAall(i,j) = AccuracyG_ASCG;
        HGdAall(i,j) = AccuracyGd_ASCG;
    end
end

save(fullfile(outDirName,[data,'all.mat']),'HGAall','HGdAall');
end
toc