clc; clear all
load('../generateW/LFW_64.mat'); load('../generateW/p_5_sigma_3.1623/LFW_64_p_5_sigma_3.1623.mat');


[M,N] = size(A); % M*N 为矩阵A的维数
W1 = W_hk_c; W2 = W_diff_c;

%初始化参数 defult
maxiter =200; tol = 1e-17; timelimit = 1000000;
fold = 5; %决定测试个体数量：总个体数/fold 向下取整
DCol = full(sum(W1,2)); D = spdiags(DCol,0,N,N); L = D - W1; %计算L

    k = 600;
    gamma = 1e-8;
    a = 9;

%     rng('default')
    randn('state',1);
    Winit = abs(randn(M,k)); Hinit = abs(randn(k,N));

%     [H, W, fvalH] = nmf_ASCG_proximal_simple(A,Winit,Hinit,tol,maxiter);
    
    [HG, WG, G] = GNMF_ASCG_new_proximal_revised(A,Winit,Hinit,L,gamma,tol,maxiter);

    W = W1 + a*W2;  %组合权重矩阵
    DCol = full(sum(W,2)); D = spdiags(DCol,0,N,N); La = D - W;  %计算La
    [HGd, WGd, Gd] = GNMF_ASCG_new_proximal_revised(A,Winit,Hinit,La,gamma,tol,maxiter);
    

%     NA = Accuracy(fold,A,Y,H);
%     AccuracyN_ASCG=NA.acc;
%     AccuracyN_ASCGvar=NA.var;

    GA = Accuracy(fold,A,Y,HG);
    AccuracyG_ASCG=GA.acc;
    AccuracyG_ASCGvar=GA.var;
        
    GdA = Accuracy(fold,A,Y,HGd);
    AccuracyGd_ASCG=GdA.acc;
    AccuracyGd_ASCGvar=GdA.var;