clc; clear all
dataall = {
    'Orl';
    'Orl_shelter_30_30';
    'Orl_shelter_40_40';
    'Orl_shelter_50_50';
    'YaleB_c';
    'YaleB_c_shelter_10_10';
};

for dataindex = 1:length(dataall)
    data = dataall{dataindex};
    fprintf('%s\n',data);
    
    load(fullfile('..','generateW',[data,'.mat'])); 
    
    k = 100;
    maxiter =2000; tol = 1e-17; timelimit = 1000000;
    fold = 3; 
    
    [M,N] = size(A); % M*N 为矩阵A的维�?
    % rng('default')
    randn('state',1);
    Winit = abs(randn(M,k)); Hinit = abs(randn(k,N));
    Wfilename = [data,'_p_5_sigma_3.1623.mat'];
    dirName = ['p_5_sigma_3.1623'];
    load(fullfile('..','generateW',dirName, Wfilename));
    W1 = W_hk_c; W2 = W_diff_c;
    
    for lambda = 1e-8
    for a = 9
    W = W1 + a*W2;
    
    %           ======== NMF_MU ==========
    [WN,HN] = GNMF_multi_revised(A,Winit,Hinit,W,0,maxiter);
    
    %           ======== GNMF_MU ==========
    [WG,HG] = GNMF_multi_revised(A,Winit,Hinit,W1,lambda,maxiter);

    %           ======== GNMFD_MU ==========
    [WGd,HGd] = GNMF_multi_revised(A,Winit,Hinit,W,lambda,maxiter);
    
%     outputfilename = [facedata,'speed.mat'];
%     save(outputfilename)
    end
    end
end
