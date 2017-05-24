function outfilename = GetW_caideng(database, nearP, sigma)
% calculate similar matrix by caideng's constructW.mat
% for database and its difference matrix, outfile: data_p_nearP_sigma_sigma.mat
% database:
%           'O1': 'Orl_shelter_20_percent_20.mat'
%           'Y1': 'YaleB_shelter_10_percent_20.mat'
% nearP: p nearst neighbors of KNN
% sigma: The parameter needed under 'HeatKernel'

    if database == 'O1'
        data = 'Orl_shelter_20_percent_20';
        len_row = 112;
        len_colunm = 92;
    elseif database == 'Y1'
        data = 'YaleB_shelter_10_percent_20';
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
    
    outfilename = [data,'_p_',num2str(nearP),'_sigma_',num2str(sigma),'.mat'];
    save(outfilename,'W_hk_c','W_diff_c');