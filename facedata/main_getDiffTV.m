clc
clear all

%%% 获取x，y方向的二阶差分，即对x方向做两次差分和对y方向做两次差�?
%%% 保存数据�?

dataall = {
    'Orl';
    'Orl_shelter_30_30';
    'Orl_shelter_40_40';
    'Orl_shelter_50_50';
    'YaleB_c';
    'YaleB_c_shelter_10_10';
    };
% data = dataall{1};
for dataindex = 1:length(dataall)
    data = dataall{dataindex};
    load(['../generateW/',data,'.mat'],'A');
    outfileName = [data,'TVDiff_W.mat'];
    
    if strcmp(data(1), 'O')
        len_row = 112;
        len_colunm = 92;
    elseif strcmp(data(1), 'Y')
        len_row = 32;
        len_colunm = 32;
    end
    N = size(A,2);
    [diffXA, diffYA] = getDiffXY(A, len_row, len_colunm);
    diffTV = zeros((len_row-1)*(len_colunm-1),N);
    for j = 1:N
        for i = 1:len_row-1
            for l = 1:len_colunm-1
                t = i+(l-1)*(len_row-1);
                diffx_row = i+(l-1)*len_row;
                diffy_row = t;
                diffTV(t,j) = sqrt(diffXA(diffx_row,j)^2+diffYA(diffy_row,j)^2);
            end
        end
    end

    normsTV = max(1e-15,sqrt(sum(diffTV.^2,1)))';
    DTV = diffTV*diag(normsTV.^-1);% 归一�?
    
    options.NeighborMode = 'KNN';
    options.k = 5;
    options.WeightMode = 'HeatKernel';
    options.t = sqrt(10);
    W_difftv_c = full(constructW(DTV',options));
%     load(['../generateW/p_5_sigma_3.1623/',data,'_p_5_sigma_3.1623.mat'],'W_hk_c');
%     save(outfileName,'DTV','W_hk_c','W_difftv_c')
    save(outfileName,'DTV','W_difftv_c')
end