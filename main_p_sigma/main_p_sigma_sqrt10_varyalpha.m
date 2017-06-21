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
alphaall = [0.1,0.3,0.5,0.7,0.9,3,5,7,9,11];

if data(1) == 'O'
k = 100; gamma = 1e-8;
elseif data(1) == 'Y'
k = 130; gamma = 6e-8;
end

maxiter =200; tol = 1e-17; timelimit = 1000000;
fold = 3; 

[M,N] = size(A); % M*N Îª¾ØÕóAµÄÎ¬Êý
% rng('default')
randn('state',1);
Winit = abs(randn(M,k)); Hinit = abs(randn(k,N));

if data(1) == 'O'
pall = 2:7; sigma = sqrt(10);
elseif data(1) == 'Y'
pall = 3:3:30; sigma = sqrt(10);
end

HGAallvaryalpha = zeros(length(pall),length(alphaall));
HGdAallvaryalpha = zeros(length(pall),length(alphaall));

outDirName = [data, '_p_',num2str(pall(1)),'_',num2str(pall(end)),'_sigma_sqrt10_alphabest'];

if exist(outDirName,'dir') ~= 7
    mkdir(outDirName)
end

tic
for i = 1:length(pall)
    for j = 1:length(alphaall)

        p = pall(i)
        a = alphaall(j)
        
        dirName = ['p_',num2str(p),'_sigma_',num2str(sigma)];
        Wfilename = [data,'_p_',num2str(p),'_sigma_',num2str(sigma),'.mat'];
        outFileName = fullfile(outDirName,[data,'_p_',num2str(p),'_alpha_',num2str(a),'_acc.mat']);
        if exist(outFileName,'file')
            load(outFileName ,'HGA','HGdA');
            HGAallvaryalpha(i,j) = HGA.acc;
            HGdAallvaryalpha(i,j) = HGdA.acc;
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
        
        save(outFileName ,'HGA','HGdA');
        HGAallvaryalpha(i,j) = AccuracyG_ASCG;
        HGdAallvaryalpha(i,j) = AccuracyGd_ASCG;
    end
end
HGAall = max(HGAallvaryalpha,[],2);
HGdAall = max(HGdAallvaryalpha,[],2);
save(fullfile(outDirName,[data,'all.mat']),'HGAall','HGdAall','HGAallvaryalpha','HGdAallvaryalpha');
end
toc