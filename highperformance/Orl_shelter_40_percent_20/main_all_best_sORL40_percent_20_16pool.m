clc; clear all
load('Orl_shelter_40_percent_20.mat'); load('Orl_shelter_40_percent_20_p_5_sigma_3.873.mat');

parpool(16)

[M,N] = size(A); % M*N 为矩阵A的维数
W1 = W_hk_c; W2 = W_diff_c;

%初始化参数 defult
maxiter =200; tol = 1e-17; timelimit = 1000000;
fold = 3; %决定测试个体数量：总个体数/fold 向下取整
DCol = full(sum(W1,2)); D = spdiags(DCol,0,N,N); L = D - W1; %计算L

% k: 50 - 180;
% i1j1h1,i1j1h2,...,i1j1h10,i1j19h1,...,i1j19h10;i2j1h1,...i2j19h10,...,
% i13j19h10
allnumlist = [1:1000];  %,1101:1200,1301:1400,1501:1600];
parfor index = 1:1000,
%for index = 1:1000,
    allnum = allnumlist(index);
    
    gammaall = [1e-9, 2e-9, 3e-9, 4e-9, 5e-9, 6e-9, 7e-9, 8e-9, 9e-9,1e-8];
    all = [0.1,0.3,0.5,0.7,0.9,3,5,7,9,11];
    
    ii = floor((allnum-1)/100)+1;
    k = ii*10+40;
    subnum = rem(allnum,100);
    if subnum==0
        subnum=100;
    end
    jj = floor((subnum-1)/10)+1;
    gamma = gammaall(jj);
    hh = rem(allnum,10);
    if hh==0
        hh = 10;
    end
    a = all(hh);

    rng('default')
    %randn('state',1);
    Winit = abs(randn(M,k)); Hinit = abs(randn(k,N));
    HG = 0; H = 0;
    fvalH=0;
	fvalHG=0;
	fvalHGd=0;
    if rem(allnum,100) == 1,  % 1,101,...1201
        [H, fvalH] = nmf_ASCG_proximal_simple(A,Winit,Hinit,tol,maxiter);
    end
    
    if  hh == 1
        [HG, fvalHG] = GNMF_ASCG_new_proximal_revised(A,Winit,Hinit,L,gamma,tol,maxiter);
    end

    W = W1 + a*W2;  %组合权重矩阵
    DCol = full(sum(W,2)); D = spdiags(DCol,0,N,N); La = D - W;  %计算La
    [HGd, fvalHGd] = GNMF_ASCG_new_proximal_revised(A,Winit,Hinit,La,gamma,tol,maxiter);
    
    fval = [fvalH,fvalHG,fvalHGd];
	savepar(['Orl_shelter_40_percent_20allbest',num2str(allnum),'.mat'],H,HG,HGd,fval);
	
end

%finalresult()