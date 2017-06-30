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
    diffCos = zeros((len_row-1)*(len_colunm-1),N);
    for j = 1:N
        for i = 1:len_row-1
            for l = 1:len_colunm-1
                t = i+(l-1)*(len_row-1);
                diffx_row = i+(l-1)*len_row;
                diffy_row = t;
                diffCos(t,j) = atan(diffXA(diffx_row,j)/diffYA(diffy_row,j)^2);
            end
        end
    end

    normsCos = max(1e-15,sqrt(sum(diffCos.^2,1)))';
    DCos = diffCos*diag(normsCos.^-1);% 归一�?
    
    options.NeighborMode = 'KNN';
    options.k = 5;
    options.WeightMode = 'HeatKernel';
    options.t = sqrt(10);
    W_diffCos_HT_c = full(constructW(DCos',options));
    
    W_diffCos_cos = zeros(N,N);
    for i = 1:N
        for j = 1:N
            s = 0;
            for t = 1:(len_colunm-1)*(len_row-1)
                s = s + cos(DCos(t,i)-DCos(t,j));
            end
            W_diffCos_cos(i,j) = s;
        end
    end
    
    load(['../generateW/p_5_sigma_3.1623/',data,'_p_5_sigma_3.1623.mat'],'W_hk_c');
    save(outfileName,'DCos','W_hk_c','W_diffCos_HT_c','W_diffCos_cos')
end