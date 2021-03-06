function outfilename = GetW_caideng(database, nearP, sigma)
% calculate similar matrix by caideng's constructW.mat
% for database and its difference matrix, outfile: data_p_nearP_sigma_sigma.mat
% database:
%           'O1': 'Orl_shelter_20_percent_20.mat'
%           'Y1': 'YaleB_shelter_10_percent_20.mat'
% nearP: p nearst neighbors of KNN
% sigma: The parameter needed under 'HeatKernel'

    if strcmp(database,'O1')
        data = 'Orl_shelter_20_percent_20';
    elseif strcmp(database,'O2')
        data = 'Orl_shelter_30_30';
    elseif strcmp(database,'O3')
        data = 'Orl_shelter_40_40';
    elseif strcmp(database,'O4')
        data = 'Orl_shelter_50_50';
    elseif strcmp(database,'O5')
        data = 'Orl_shelter_30_percent_20';
	elseif strcmp(database,'O6')
        data = 'Orl_shelter_40_percent_20';
	elseif strcmp(database,'O7')
        data = 'Orl_shelter_40_percent_60';
    elseif strcmp(database,'O8')
        data = 'Orl_shelter_40_percent_40';
    elseif strcmp(database,'O9')
        data = 'Orl_shelter_40_percent_80';
    elseif strcmp(database,'OA')
        data = 'Orl';
    elseif strcmp(database,'Y1')
        data = 'YaleB_c';
    elseif strcmp(database,'Y2')
        data = 'YaleB_c_shelter_10_percent_20';
    elseif strcmp(database,'Y3')
        data = 'YaleB_c_shelter_10_percent_60';
    elseif strcmp(database,'Y4')
        data = 'YaleB_c_shelter_10_10';
    elseif strcmp(database,'Y5')
        data = 'YaleB_c_shelter_10_percent_40';
    elseif strcmp(database,'Y6')
        data = 'YaleB_c_shelter_10_percent_80';
    elseif strcmp(database,'N1')
        data = 'NewR25';
    elseif strcmp(database,'L')
        data = 'LFW_64';
    elseif strcmp(database,'l')
        data = 'LFW_32';
    end
    
    if strcmp(data(1),'O')
        len_row = 112;
        len_colunm = 92;
    elseif strcmp(data(1),'Y')
        len_row = 32;
        len_colunm = 32;
    elseif strcmp(data,'LFW_64')
        len_row = 64;
        len_colunm = 64;
    elseif strcmp(data,'LFW_32')
        len_row = 32;
        len_colunm = 32;
    end
    
    load([data, '.mat'])
    [M,N] = size(A);

    %=================原始图像构造权重矩阵=================
    options = [];
    options.NeighborMode = 'KNN';
    options.WeightMode = 'HeatKernel';
    options.k = nearP;
    options.t = sigma;
    A = A';
    W_hk_c = full(constructW(A,options));
    
    %=================图像一阶差分构造权重矩阵=================
    A = A';    
    [L1,L2] = l1l2(len_row,len_colunm);%一阶差分矩阵
    At = zeros(M,N);
    for i=1:N
        pic = reshape(A(:,i),len_row,len_colunm);
        At(:,i) = reshape(pic',M,1);
    end
    Diff = [L1;L2]*At;
    norms = max(1e-15,sqrt(sum(Diff.^2,1)))';
    D = Diff*diag(norms.^-1);% 归一化Diff矩阵
    D = D';  % caideng  输入
    W_diff_c = full(constructW(D,options));
    
    dirName = ['p_',num2str(nearP),'_sigma_',num2str(sigma)];
    if exist(dirName,'dir') ~= 7
        mkdir(dirName)
    end
    outfilename = [data,'_p_',num2str(nearP),'_sigma_',num2str(sigma),'.mat'];
    save(fullfile(dirName, outfilename),'W_hk_c','W_diff_c');