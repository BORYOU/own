clc; clear all

timelimit = 500; maxiter =20000; tol = 1e-17;
gamma = 1e-8 ; a = 3; k=50;

sf = cell(8,1);
sf{1} = 'Orl'; sf{2} = 'Orl_shelter_30_30';
sf{3} = 'Orl_shelter_40_40'; sf{4} = 'Orl_shelter_50_50';
sf{5} = 'YaleB_c'; sf{6} = 'YaleB_c_shelter_10_10';
sf{7} = 'YaleB_c_shelter'; sf{8} = 'YaleB_c_shelter_20_20';

sw = cell(8,1);
sw{1} = 'W_cai_ORL.mat'; sw{2} = 'W_cai_sOrl30.mat';
sw{3} = 'W_cai_sOrl40.mat'; sw{4} = 'W_cai_sOrl50.mat';
sw{5} = 'W_cai_YaleB_c.mat'; sw{6} = 'W_sYaleB10_c.mat';
sw{7} = 'W_sYaleB_c.mat'; sw{8} = 'W_sYaleB20_c.mat';

for i = 1:8
    facedata = sf{i};
    wdata = sw{i};
    load([facedata,'.mat'],'A','Y');
    load(wdata);
    
    [M,N] = size(A);
    NMF_MUf   = {};
    NMF_PGf   = {};
    NMF_ASf   = {};
    GNMF_MUf  = {};
    GNMF_PGf  = {};
    GNMF_ASf  = {};
    GNMFD_MUf = {};
    GNMFD_PGf = {};
    GNMFD_ASf = {};
    NMF_MUt   = {};
    NMF_PGt   = {};
    NMF_ASt   = {};
    GNMF_MUt  = {};
    GNMF_PGt  = {};
    GNMF_ASt  = {};
    GNMFD_MUt = {};
    GNMFD_PGt = {};
    GNMFD_ASt = {};
    
    for j=1:5
        randn('state',j);
        %randn('state',2)
        Winit = abs(randn(M,k)); Hinit = abs(randn(k,N));
        W1 = W_hk_c; W2 = W_diff_c;
        W = W1 + a*W2;  
        DCola = full(sum(W,2)); Da = spdiags(DCola,0,N,N); La = Da - W;
        DCol = full(sum(W1,2)); D = spdiags(DCol,0,N,N); L = D - W1;
        
        
        nClass = length(unique(Y));
        options = [];
        options.WeightMode = 'HeatKernel';
        options.maxIter = 20000;
        options.alpha = 0;
        options.nRepeat = 1; 
        options.timetol = 600;
        
        % NMF
        %%%%%%  MU  %%%%%%%
        %           ======== NMF_MU ==========
        [W,H,V_fval,T_execution,iter] = GNMF_multi_revised(A,Winit,Hinit,Theta,D,L,lambda,tol,timelimit,maxiter)
        [~,~, ~, ~,Nfval,NT_execution] = GNMF(A,nClass,W,options,Winit,Hinit');
        
        %%%%%%  PG  %%%%%%%
        %           ======== NMF_PG ==========
        fprintf('NMFPG\n');
        [~,~,NPG] = nmf(A,Winit,Hinit,tol,timelimit,maxiter);
        % fval T_execution
        %%%%%%   ASCG   %%%%%%%%
        %          ======== NMF_ASCG ==========
        fprintf('NMFASCG\n');
        [~,~,NASCG] = nmf_ASCG_proximal_simple(A,Winit,Hinit,tol,timelimit,maxiter);
        
        % GNMF
        options.alpha = 1e-8;
        %%%%%%  MU  %%%%%%%
        %           ======== GNMF_MU ==========
        [~,~, ~, ~,Gfval,GT_execution] = GNMF(A,nClass,W1,options,Winit,Hinit');
        
        %%%%%%  PG  %%%%%%%
        %           ======== GNMF_PG ==========
        fprintf('GNMFPG\n');
        [~,~,GPG] = GNMF_PG(A,Winit,Hinit,L,gamma,tol,timelimit,maxiter);
        % fval T_execution
        %%%%%%   ASCG   %%%%%%%%
        %          ======== GNMF_AS ==========
        fprintf('GNMFASCG\n');
        [~,~,GASCG] = GNMF_ASCG_new_proximal_revised(A,Winit,Hinit,tol,timelimit,maxiter,gamma,L);
    
        % GNMFD
        %%%%%%  MU  %%%%%%%
        %           ======== GNMFD_MU ==========
        [~,~, ~, ~,Gdfval,GdT_execution] = GNMF(A,nClass,W,options,Winit,Hinit');
        
        %%%%%%  PG  %%%%%%%
        %           ======== GNMFD_PG ==========
        fprintf('GNMFdPG\n');
        [~,~,GdPG] = GNMF_PG(A,Winit,Hinit,La,gamma,tol,timelimit,maxiter);
        % fval T_execution
        %%%%%%   ASCG   %%%%%%%%
        %          ======== GNMFD_PG ==========
        fprintf('GNMFdASCG\n');
        [~,~,GdASCG] = GNMF_ASCG_new_proximal_revised(A,Winit,Hinit,tol,timelimit,maxiter,gamma,La);
        
        NMF_MUf{j}   = Nfval              ;     
        NMF_PGf{j}   = NPG.fval           ;
        NMF_ASf{j}   = NASCG.fval         ;
        GNMF_MUf{j}  = Gfval              ;
        GNMF_PGf{j}  = GPG.fval           ;
        GNMF_ASf{j}  = GASCG.fval         ;
        GNMFD_MUf{j} = Gdfval             ;
        GNMFD_PGf{j} = GdPG.fval          ;
        GNMFD_ASf{j} = GdASCG.fval        ;
        NMF_MUt{j}   = NT_execution       ;
        NMF_PGt{j}   = NPG.T_execution    ;
        NMF_ASt{j}   = NASCG.T_execution  ;
        GNMF_MUt{j}  = GT_execution       ;
        GNMF_PGt{j}  = GPG.T_execution    ;
        GNMF_ASt{j}  = GASCG.T_execution  ;
        GNMFD_MUt{j} = GdT_execution      ;
        GNMFD_PGt{j} = GdPG.T_execution   ;
        GNMFD_ASt{j} = GdASCG.T_execution ;
    end

[TimeNMF_MU,FvalNMF_MU] = averagespeed(NMF_MUf,NMF_MUt,500);
[GTimeNMF_MU,GFvalNMF_MU] = averagespeed(GNMF_MUf,GNMF_MUt,500);
[GdTimeNMF_MU,GdFvalNMF_MU] = averagespeed(GNMFD_MUf,GNMFD_MUt,500);
[TimeNMF_PG,FvalNMF_PG] = averagespeed(NMF_PGf,NMF_PGt,500);
[GTimeNMF_PG,GFvalNMF_PG] = averagespeed(GNMF_PGf,GNMF_PGt,500);
[GdTimeNMF_PG,GdFvalNMF_PG] = averagespeed(GNMFD_PGf,GNMFD_PGt,500);
[TimeNMF_AS,FvalNMF_AS] = averagespeed(NMF_ASf,NMF_ASt,500);
[GTimeNMF_AS,GFvalNMF_AS] = averagespeed(GNMF_ASf,GNMF_ASt,500);
[GdTimeNMF_AS,GdFvalNMF_AS] = averagespeed(GNMFD_ASf,GNMFD_ASt,500);
outputfilename = [facedata,'speed.mat'];
save(outputfilename)

end
