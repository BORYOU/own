clc
clear all

% load('YaleB_c.mat','A','Y');
%  load('Orl.mat'); %载入数据：A：原始数据矩阵，10304*400；Y：分类下标，400*1，一个人有十张脸部图片,图片的尺寸为 112*92

% [M,N] = size(A); % M*N 为矩阵A的维数
% A_new = A; % 给一部分（80%）照片加随机遮挡规格为 30*40
% for i=1:400
%    if mod(i,10) < 3
%        continue;
%    end
%    a = A(:,i);
%    face = reshape(a,112,92);
%    lm = round(80*rand)+1;
%    ln = round(50*rand)+1;
%    face(lm:lm+29,ln:ln+39) = 0;
%    a = reshape(face,10304,1);
%    A_new(:,i) = a/sum(a);
% end
% for i=1:2414
% %    if mod(i,10) < 3
% %        continue;
% %    end
%    a = A(:,i);
%    face = reshape(a,32,32);
%    lm = round(15*rand)+1;
%    ln = round(15*rand)+1;
%    face(lm:lm+14,ln:ln+14) = 0;
% %    imagesc(face);colormap(gray);
%    a = reshape(face,1024,1);
%    A_new(:,i) = a/sum(a);
% end
% 
% save('YaleB_c_shelter','A','Y');
% A = A_new;
% save('Orl_shelter','A','Y');
% load('Orl_shelter','A','Y');
% load('Orl_shelter_30_30.mat','A','Y');
% load('Orl_shelter_40_40.mat','A','Y');
% load('Orl_shelter_50_50.mat','A','Y');
% load('YaleB.mat','A','Y');
load('YaleB_c.mat','A','Y');
% load('YaleB_c_shelter_10_10.mat','A','Y');
%load('Orlinit','A','Y');
%  load('Orlinit_shelter','A','Y');
% load('YaleB_c_shelter.mat','A','Y');
[M,N] = size(A); % M*N 为矩阵A的维数
%% 计算权重矩阵 W_hk (Heat Kernel Weight)
      
      options = [];
      options.NeighborMode = 'KNN';
%       options.k = 4;
      options.k = 5;
      options.WeightMode = 'HeatKernel';
      options.t = sqrt(10);
      A = A';
      W_hk_c = full(constructW(A,options));

%=================利用图像的一阶差分构造权重矩阵=================
A = A';
% YaleB
len_row = 32;
len_colunm = 32;
% len_row = 112; 
% len_colunm = 92;

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

% save('W_cai','W_hk_c','W_diff_c');

% save('W_cai_ORL.mat','W_hk_c','W_diff_c');
% save('W_cai_sOrl30.mat','W_hk_c','W_diff_c');
% save('W_cai_sOrl40.mat','W_hk_c','W_diff_c');
% save('W_cai_sOrl50.mat','W_hk_c','W_diff_c');
save('W_cai_YaleB_c.mat','W_hk_c','W_diff_c');
% save('W_sYaleB10_c.mat','W_hk_c','W_diff_c');
% save('W_sYaleB_c','W_hk_c','W_diff_c');