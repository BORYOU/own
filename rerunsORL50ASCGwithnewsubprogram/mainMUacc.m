% clc; clear all

timelimit = 1500; maxiter =20000; tol = 1e-17;
gamma = 1e-8 ; a = 11; k=80;

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

for i = 4
    facedata = sf{i};
    wdata = sw{i};
    load([facedata,'.mat'],'A','Y');
    load(wdata);
    
    [M,N] = size(A);
    
    for j=1:5
        AccuracyGNMFD_MU3 = [];
        AccuracyGNMFD_PG3 = [];
        AccuracyGNMFD_AS3 = [];
        
        randn('state',j);
        %randn('state',2)
        Winit = abs(randn(M,k)); Hinit = abs(randn(k,N));
        W1 = W_hk_c; W2 = W_diff_c;
        W = W1 + a*W2;
        DCol = full(sum(W,2)); D = spdiags(DCol,0,N,N); La = D - W;
        DCol1 = full(sum(W1,2)); D1 = spdiags(DCol1,0,N,N); L = D1 - W1;
        
        % GNMFD
        %%%%%%  MU  %%%%%%%
        %           ======== GNMFD_MU ==========
        %%[~,HN,V_fval,T_execution,GMU,projgrad] = GNMF_multi_revisedgetH(A,Winit,Hinit,W,D,La,gamma,timelimit,maxiter);
        %%for num = 1:numel(GMU.H),
        %%    Gn = Accuracy(3,A,Y,GMU.H{num});
        %%    AccuracyGNMFD_MU3(num)=Gn.acc;
        %%    %         AccuracyGNMFD_MU3var3(num)=Gn.var;
        %%end
        %%
        %%[~,HG,GdPG] = GNMF_PGgetH(A,Winit,Hinit,La,gamma,tol,timelimit,maxiter);
        %%for num = 1:numel(GdPG.H),
        %%    GPG = Accuracy(3,A,Y,GdPG.H{num});
        %%    AccuracyGNMFD_PG3(num)=GPG.acc;
        %%    %         AccuracyGNMFD_PG3var3(num)=GPG.var;
        %%end
        
        [GdASCG] = gnmf_ASCG_proximal_simple_regu(A,Winit,Hinit,La,gamma,tol,timelimit,maxiter);
        for num = 1:numel(GdASCG.Hhis)
            GAS = Accuracy(3,A,Y,GdASCG.Hhis{num});
            AccuracyGNMFD_AS3(num)=GAS.acc;
            %            AccuracyGNMFD_AS3var3(num)=GAS.var;
        end
        save(['sORL50acc1215_',num2str(j),'.mat']);
    end
end

%figure
%plot(T_execution(10:10:end),AccuracyGNMFD_MU3);
%hold on
%plot(GdASCG.T_execution,AccuracyGNMFD_AS3,'r');

