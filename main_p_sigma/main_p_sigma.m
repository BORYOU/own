clc; clear all

load(fullfile('..','generateW','Orl_shelter_30_30.mat')); 
data = 'Orl_shelter_30_30';

k = 100; gamma = 1e-8; a = 9;

[M,N] = size(A); % M*N Îª¾ØÕóAµÄÎ¬Êý
% rng('default')
randn('state',1);
Winit = abs(randn(M,k)); Hinit = abs(randn(k,N));

maxiter =200; tol = 1e-17; timelimit = 1000000;
fold = 3; 

% outDirName = 'Orl_shelter_30_30_p_2_10_sigma_2_5_10_15_20';
% outDirName = 'Orl_shelter_40_40_p_2_10_sigma_2_10';
outDirName = 'Orl_shelter_50_50_p_2_10_sigma_2_10';

if exist(outDirName,'dir') ~= 7
    mkdir(outDirName)
end

HGAall = zeros(9,5);
HGdAall = zeros(9,5);

pall = 2:10;
% sigmaall = [sqrt(2),sqrt(5),sqrt(10),sqrt(15),sqrt(20)];
sigmaall = [sqrt(2),sqrt(10)];
    
tic
for i = 1:5
    for j = 1:2

        p = pall(i)
        sigma = sigmaall(j)
        
        dirName = ['p_',num2str(p),'_sigma_',num2str(sigma)];
        Wfilename = [data,'_p_',num2str(p),'_sigma_',num2str(sigma),'.mat'];
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
%         save(fullfile(outDirName,['Orl_shelter_30_30','_p_',num2str(p),'_sigma_',num2str(sigma),'_acc.mat']),'HGA','HGdA');
        save(fullfile(outDirName,['Orl_shelter_40_40','_p_',num2str(p),'_sigma_',num2str(sigma),'_acc.mat']),'HGA','HGdA');
        HGAall(i,j) = AccuracyG_ASCG;
        HGdAall(i,j) = AccuracyGd_ASCG;
    end
end

save(fullfile(outDirName,'Orl_shelter_40_40all.mat'),'HGAall','HGdAall');
toc