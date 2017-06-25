clc; clear all
dataall = {
     %'Orl_shelter_40_percent_20';
     %'Orl_shelter_40_percent_40';
     %'Orl_shelter_40_percent_60';
     %'Orl_shelter_40_percent_80';
     'Orl';
     'Orl_shelter_30_30';
     'Orl_shelter_40_40';
     'Orl_shelter_50_50';
    %'Orl_shelter_20_percent_20';
    'YaleB_c';
    'YaleB_c_shelter_10_10';
    %'YaleB_c_shelter_10_percent_20';
    %'YaleB_c_shelter_10_percent_60';
};
for dataindex = 1:length(dataall)
data = dataall{dataindex};
fprintf('%s\n',data);

load(fullfile('..','generateW',[data,'.mat'])); 

k = 100; a = 9;

maxiter =200; tol = 1e-17; timelimit = 1000000;
fold = 3; 

[M,N] = size(A); % M*N Îª¾ØÕóAµÄÎ¬Êý
rng('default')
%randn('state',1);
Winit = abs(randn(M,k)); Hinit = abs(randn(k,N));
Wfilename = [data,'_p_5_sigma_3.1623.mat'];
dirName = ['p_5_sigma_3.1623'];
load(fullfile('..','generateW',dirName, Wfilename));
W1 = W_hk_c; W2 = W_diff_c;
DCol = full(sum(W1,2)); D = spdiags(DCol,0,N,N); L = D - W1; 
W = W1 + a*W2;
DCol = full(sum(W,2)); D = spdiags(DCol,0,N,N); La = D - W; 

lambdaall = [1e-14,1e-12,1e-10,1e-9,1e-8,1e-7,1e-6,1e-4,1e-2,1,10];

firstNormall = zeros(length(lambdaall));
traceNormall = zeros(length(lambdaall));

outDirName = [data, '_Gd_lambda_',num2str(lambdaall(1)),'_',num2str(lambdaall(end))];

if exist(outDirName,'dir') ~= 7
    mkdir(outDirName)
end

tic
for i = 1:length(lambdaall)

        lambda = lambdaall(i)
        
        outFileName = fullfile(outDirName,[data,'_lambda_',num2str(lambda),'.mat']);
        if exist(outFileName)
            load(outFileName ,'Gd');
            firstNormall(i) = Gd.firstNorm(end);
            traceNormall(i) = Gd.traceNorm(end);
            continue
        end
        
        %HG = GNMF_ASCG_new_proximal_revised(A,Winit,Hinit,L,lambda,tol,maxiter);
    
        [HGd, WGd, Gd] = GNMF_ASCG_new_proximal_revised(A,Winit,Hinit,La,lambda,tol,maxiter);
    
        %HGA = Accuracy(3,A,Y,HG);
        %AccuracyG_ASCG=HGA.acc;
        HGdA = Accuracy(3,A,Y,HGd);
        AccuracyGd_ASCG=HGdA.acc;
        
        save(outFileName ,'HGd','WGd','Gd','HGdA');
        firstNormall(i) = Gd.firstNorm(end);
        traceNormall(i) = Gd.traceNorm(end);
end
    save(fullfile(outDirName,[data,'all.mat']),'firstNormall','traceNormall');
end

% save(fullfile(outDirName,[data,'all.mat']),'firstNormall','traceNormall');
toc