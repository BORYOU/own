clear all;
load('../facedata/result/Orl_shelter_30_30doubleDiff_W.mat');
figure;
imagesc(W_diffxxyy_c(1:100,1:100));
colormap('gray')
set(gca,'position',[0 0 1 1],'units','normalized')
axis normal;
set(gcf, 'PaperPositionMode', 'auto');
% print(gcf, '-depsc2','similar_Orl_shelter_30_30doubleDiff_W.eps')

clear all;
load('../facedata/result/Orl_shelter_30_30TVDiff_W.mat');
figure;
imagesc(W_difftv_c(1:100,1:100));
colormap('gray')
set(gca,'position',[0 0 1 1],'units','normalized')
axis normal;
set(gcf, 'PaperPositionMode', 'auto');
% print(gcf, '-depsc2','similar_Orl_shelter_30_30TVDiff_W.mat.eps')

clear all;
load('../facedata/result/Orl_shelter_30_30Cos_arctan_W.mat');
figure;
imagesc(W_diffCos_cos(1:100,1:100));
colormap('gray')
set(gca,'position',[0 0 1 1],'units','normalized')
axis normal;
set(gcf, 'PaperPositionMode', 'auto');
% print(gcf, '-depsc2','Orl_shelter_30_30Cos_arctan_W.eps')


