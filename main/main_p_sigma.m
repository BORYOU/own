clc; clear all

load('Orl_shelter_30_30.mat'); 
data = 'Orl_shelter_30_30';

[M,N] = size(A); % M*N Îª¾ØÕóAµÄÎ¬Êý
rng('default')
%randn('state',1);
Winit = abs(randn(M,k)); Hinit = abs(randn(k,N));

maxiter =200; tol = 1e-17; timelimit = 1000000;
fold = 3; 

k = 100;
gamma = 1e-8;
a = 9;

outDirName = 'Orl_shelter_30_30_p_2_10_sigma_2_5_10_15_20';
if exist(outDirName,'dir') ~= 7
    mkdir(outDirName)
end

HGAall = zeros(9,5);
HGdAall = zeros(9,5);

pall = 2:10;
sigmaall = [sqrt(2),sqrt(5),sqrt(10),sqrt(15),sqrt(20)]
for i = 1:9
    for j = 1:5
        p = pall(i);
        sigma = sigmaall(j);
        
        dirName = ['p_',num2str(p),'_sigma_',num2str(sigma)];
        Wfilename = [data,'_p_',num2str(p),'_sigma_',num2str(sigma),'.mat'];
        load(fullfile('..','generateW',dirName, Wfilename));
        W1 = W_hk_c; W2 = W_diff_c;
        DCol = full(sum(W1,2)); D = spdiags(DCol,0,N,N); L = D - W1; 
        
        HG = GNMF_ASCG_new_proximal_revised(A,Winit,Hinit,L,gamma,tol,maxiter);
    
        W = W1 + a*W2;
        DCol = full(sum(W,2)); D = spdiags(DCol,0,N,N); La = D - W;  
        
        HGd = GNMF_ASCG_new_proximal_revised(A,Winit,Hinit,La,gamma,tol,maxiter);
    
        HGA = Accuracy(fold,A,Y,HG);
        AccuracyG_ASCG=HGA.acc;
        HGdA = Accuracy(fold,A,Y,HGd);
        AccuracyGd_ASCG=HGdA.acc;
        save(fullfile(outDirName,['Orl_shelter_30_30','p_',num2str(p),'_sigma_',num2str(sigma),'_acc.mat']),'HGA','HGdA');
        
        HGAall(i,j) = HGA;
        HGdAall(i,j) = HGdA;
    end
end

save(fullfile(outDirName,'Orl_shelter_30_30all.mat'),'HGAall','HGdAall');