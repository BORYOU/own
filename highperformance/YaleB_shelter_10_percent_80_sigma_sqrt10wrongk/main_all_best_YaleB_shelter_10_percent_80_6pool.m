clc; clear all
load('YaleB_c_shelter_10_percent_80.mat'); load('YaleB_c_shelter_10_percent_80_p_5_sigma_3.1623.mat');

parpool(6)

[M,N] = size(A); % M*N 为矩阵A的维数
W1 = W_hk_c; W2 = W_diff_c;

%初始化参数 defult
maxiter =200; tol = 1e-17; timelimit = 1000000;
fold = 3; %决定测试个体数量：总个体数/fold 向下取整
DCol = full(sum(W1,2)); D = spdiags(DCol,0,N,N); L = D - W1; %计算L

% k: 50 - 180;
% i1j1h1,i1j1h2,...,i1j1h10,i1j19h1,...,i1j19h10;i2j1h1,...i2j19h10,...,
% i13j19h10
allnumlist = [1:1000,2701:2800,4701:4800,6701:6800];
parfor index = 701:1300,
%for index = 1:1000,
    allnum = allnumlist(index);
    if exist(['YaleB_shelter_10_percent_80allbest',num2str(allnum),'.mat'])
        continue
    end
    gammaall = [1e-8, 2e-8, 3e-8, 4e-8, 5e-8, 6e-8, 7e-8, 8e-8, 9e-8,1e-7];
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
	savepar(['YaleB_shelter_10_percent_80allbest',num2str(allnum),'.mat'],H,HG,HGd,fval);
	
end

%finalresult()