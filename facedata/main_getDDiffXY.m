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
    outfileName = [data,'doubleDiff_W.mat'];
    
    if strcmp(data(1), 'O')
        len_row = 112;
        len_colunm = 92;
    elseif strcmp(data(1), 'Y')
        len_row = 32;
        len_colunm = 32;
    end
    
    len_row_diffx = len_row;
    len_colunm_diffx = len_colunm-1;
    len_row_diffy = len_row-1;
    len_colunm_diffy = len_colunm;
    
    [diffXA, diffYA] = getDiffXY(A, len_row, len_colunm);
    [DdiffXX, ~] = getDiffXY(diffXA, len_row_diffx, len_colunm_diffx);
    [~, DdiffYY] = getDiffXY(diffYA, len_row_diffy, len_colunm_diffy);
    DXXYY = [DdiffXX; DdiffYY];
    normsXXYY = max(1e-15,sqrt(sum(DXXYY.^2,1)))';
    DXXYY = DXXYY*diag(normsXXYY.^-1);% 归一�?
    
    options.NeighborMode = 'KNN';
    options.k = 5;
    options.WeightMode = 'HeatKernel';
    options.t = sqrt(10);
    W_diffxxyy_c = full(constructW(DXXYY',options));
    load(['../generateW/p_5_sigma_3.1623/',data,'_p_5_sigma_3.1623.mat'],'W_hk_c');
    save(outfileName,'DXXYY','W_hk_c','W_diffxxyy_c')
end