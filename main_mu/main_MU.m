clc; clear all

load(fullfile('..','generateW','Orl_shelter_30_30.mat')); 
load(fullfile('..','generateW','W_cai_sOrl30.mat')); 

gamma = 1e-8; a = 9;

[M,N] = size(A); % M*N Îª¾ØÕóAµÄÎ¬Êý
rng('default')
%randn('state',1);

maxiter =2000; tol = 1e-17; timelimit = 1000000;
fold = 3; 

HGdMUAall = zeros(1,10);
HGdMUAvarall = zeros(1,10);

HGdnormMUAall = zeros(1,10);
HGdnormMUAvarall = zeros(1,10);

W1 = W_hk_c; W2 = W_diff_c;
%DCol = full(sum(W1,2)); D = spdiags(DCol,0,N,N); L = D - W1;
S = W1 + a*W2;
%DCol = full(sum(S,2)); D = spdiags(DCol,0,N,N); La = D - S;  
kall = 50:10:140;
tic
for i = 1:10
    k = kall(i)
    
    Winit = abs(randn(M,k)); Hinit = abs(randn(k,N));
    
    [WHdMU,HGdMU,Wnorm,Hnorm] = GNMF_multi_revised(A,Winit,Hinit,S,gamma,maxiter);
    
    HGdMUA = Accuracy(3,A,Y,HGdMU);
    HGdMUAall(i) = HGdMUA.acc
    HGdMUAvarall(i) = HGdMUA.var;
    
    HGdnormMUA = Accuracy(3,A,Y,HGdMU);
    HGdnormMUAall(i) = HGdnormMUA.acc
    HGdnormMUAvarall(i) = HGdnormMUA.var;
end

save('GNMFO_MU_sOrl30_k_50_140_gamma_1e8_a_9.mat','HGdMUAall','HGdMUAvarall','HGdnormMUAall','HGdnormMUAvarall','gamma','a','kall');
toc

%%% compare with the old result which use ascg
load('sORL30allbestfinal.mat','AccuracyGd_ASCGallfinal');
ascgResult = AccuracyGd_ASCGallfinal(109,1:10);
figure
hold on
plot(ascgResult,'b');
plot(HGdMUAall,'r');
plot(HGdnormMUAall,'g');
