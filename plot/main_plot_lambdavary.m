clear all; clc;
lambdaVaryPath = '../main_lambda';

dataall = {
    'Orl';
    'Orl_shelter_30_30';
    'Orl_shelter_40_40';
    'Orl_shelter_50_50';
    'YaleB_c';
    'YaleB_c_shelter_10_10';
};
lambdaallStr = {'$\lambda=$1e-14','$\lambda=$1e-12','$\lambda=$1e-10','$\lambda=$1e-8','$\lambda=$1e-6','$\lambda=$1e-4','$\lambda=$1e-2','$\lambda=$1','$\lambda=$10'};
lambdaall = [1e-14,1e-12,1e-10,1e-8,1e-6,1e-4,1e-2,1,10];
for dataindex = 1:length(dataall)
data = dataall{dataindex};
fprintf('%s\n',data);

outDirName = fullfile(lambdaVaryPath,[data, '_Gd_lambda_1e-014_10']);
load(fullfile(outDirName,[data,'all.mat']),'firstNormall','traceNormall');  % ԭʼ�������⣬��������Ϊ9*9��С����������Ϊ��һ�У�����Ϊ0
fprintf('%e %e \n', max(firstNormall(:,1)), min(firstNormall(:,1)));
fprintf('%e %e \n', max(traceNormall(:,1)), min(traceNormall(:,1)));
% set(gca,'Xscale','log')
% set(gca,'Yscale','log')
if strcmp(data, 'Orl')
    xi = 1e-4:1e-6:43e-4; %��ֵ��xi
    xmin = 0;  % ������
    xmax = 4.32e-3;  % ������
    ymin = -0.5e6;  % ������
    ymax = 2.2e6;  % ������
    textmin = 2;  % ���������ݵ���ʼ��
    textmax = 6;  % ���������ݵ������
    textx = [0,1e-4,1e-4,0,0,-5e-4];  % ���������ݵ�xƫ��
    texty = [0,0,0,1e5,1e5,1e5];  % ���������ݵ�yƫ��
end
% values = spcrv([[firstNormall(1,1) firstNormall(:,1)'
% firstNormall(1,end)];[traceNormall(1,1) traceNormall(:,1)'
% traceNormall(1,end)]],3,1000);  % �������  �޷������ݵ�
% L = plot(values(1,:),values(2,:),'-k');
close all;
figure;
values = interp1(firstNormall(:,1),traceNormall(:,1),xi,'pchip');  %spline cubic % ʹ�ò�ֵ��������
L = plot(xi,values,'-k');  % ʹ�ò�ֵ���������
hold on
P = plot(firstNormall(:,1), traceNormall(:,1), 'ko'); % �����ϱ�����ݵ�
xlabel('Residual norm $\|X-UV\|^2$','fontsize',10,'interpreter','latex');
ylabel('Regularization $trace(HLH^T)$','fontsize',10,'interpreter','latex');
axis([xmin,xmax,ymin,ymax]);
set(L,'LineWidth',1.5); % MarkerFaceColor, MarketEdgeColor
set(P,'MarkerSize',7);

for i = textmin:textmax
    text(firstNormall(i,1) + textx(i), traceNormall(i,1) + texty(i), lambdaallStr{i},'interpreter','latex');
end
pause(5)
end