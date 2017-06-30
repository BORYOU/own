clear all; clc;
lambdaVaryPath = '../main_lambda';
outfiledir = 'fig';
outfilebasestr = '%s_gamma_curve.eps';

dataall = {
    'Orl';
    'Orl_shelter_30_30';
    'Orl_shelter_40_40';
    'Orl_shelter_50_50';
    'YaleB_c';
    'YaleB_c_shelter_10_10';
    };
lambdaallStr = {'$\gamma=$1e-14','$\gamma=$1e-12','$\gamma=$1e-10','$\gamma=$1e-9','$\gamma=$1e-8','$\gamma=$1e-7','$\gamma=$1e-6','$\gamma=$1e-4','$\gamma=$1e-2','$\gamma=$1','$\gamma=$10'};
lambdaall = [1e-14,1e-12,1e-10,1e-8,1e-6,1e-4,1e-2,1,10];
for dataindex = 1:length(dataall)
    data = dataall{dataindex};
    fprintf('%s\n',data);
    outDirName = fullfile(lambdaVaryPath,[data, '_Gd_lambda_1e-014_10']);
    load(fullfile(outDirName,[data,'all.mat']),'firstNormall','traceNormall');  % ԭʼ�������⣬��������Ϊ9*9��С����������Ϊ��һ�У�����Ϊ0
    fprintf('%e %e \n', max(firstNormall(:,1)), min(firstNormall(:,1)));
    fprintf('%e %e \n', max(traceNormall(:,1)), min(traceNormall(:,1)));
    
    
    switch data
        case 'Orl'
            %     if strcmp(data, 'Orl')
%             xi = 1e-4:1e-6:45e-4; %��ֵ��xi
            xmin = 0.2e-3;  % ������
            xmax = 4.5e-3;  % ������
            ymin = -0.5e6;  % ������
            ymax = 2.4e6;  % ������
            textmin = 1;  % ���������ݵ���ʼ��
            textmax = 11;  % ���������ݵ������
            textx = [1e-4,1e-4,1e-4,0,0,0,0,-5e-4,-4.7e-4,-4.3e-4,-4e-4];  % ���������ݵ�xƫ��
            texty = [1e5,0,0,1.5e5,1e5,1e5,1e5,1e5,2e5,3e5,4e5];  % ���������ݵ�yƫ��
        case 'Orl_shelter_30_30'
%             xi = 1.006817e-02:1e-4:1.776432e-03; %��ֵ��xi
            xmin = 0.5e-3;  % ������
            xmax = 11e-3;  % ������
            ymin = -0.5e6;  % ������
            ymax = 2.4e6;  % ������
            textmin = 1;  % ���������ݵ���ʼ��
            textmax = 11;  % ���������ݵ������
            textx = [2e-4,2e-4,2e-4,1e-4,-2e-4,0,0,-5e-4,-4.7e-4,-4.3e-4,-4e-4];  % ���������ݵ�xƫ��
            texty = [1e5,0,0,1e5,-1.5e5,1.5e5,1.5e5,1.5e5,2.5e5,3.5e5,4.5e5];  % ���������ݵ�yƫ��
        case 'Orl_shelter_40_40'
%             xi = 1e-4:1e-6:43e-4; %��ֵ��xi
            xmin = 0.5e-3;  % ������
            xmax = 17e-3;  % ������
            ymin = -0.5e6;  % ������
            ymax = 25e5;  % ������
            textmin = 1;  % ���������ݵ���ʼ��
            textmax = 11;  % ���������ݵ������
            textx = [4e-4,4e-4,4e-4,4e-4,-6e-4,-1e-4,0,-5e-4,-3e-4,-2.5e-4,-2e-4];  % ���������ݵ�xƫ��
            texty = [5e4,0,0,1e5,-1.8e5,1.3e5,1.5e5,1.5e5,1.5e5,2.5e5,3.5e5];  % ���������ݵ�yƫ��
        case 'Orl_shelter_50_50'
%             xi = 1.776432e-03:1e-4:1.006817e-02; %��ֵ��xi
            xmin = 0e-3;  % ������
            xmax = 23e-3;  % ������
            ymin = -0.5e6;  % ������
            ymax = 2.7e6;  % ������
            textmin = 1;  % ���������ݵ���ʼ��
            textmax = 11;  % ���������ݵ������
            textx = [4.5e-4,4.5e-4,4.5e-4,2e-4,-5e-4,-1e-3,0,-1e-3,-1e-3,-0.7e-3,-0.3e-3];  % ���������ݵ�xƫ��
            texty = [8e4,0,0,1e5,-1.3e5,1.5e5,1.5e5,1.5e5,1.5e5,2.7e5,3.9e5];  % ���������ݵ�yƫ��
        case 'YaleB_c'
%             xi = 1e-4:1e-6:43e-4; %��ֵ��xi
            xmin = 0;  % ������
            xmax = 2.8;  % ������
            ymin = -0.5e6;  % ������
            ymax = 9.5e6;  % ������
            textmin = 1;  % ���������ݵ���ʼ��
            textmax = 11;  % ���������ݵ������
            textx = [1e-1,1e-1,1e-1,1e-1,1e-1,1e-1,0,-1e-3,-0.1,-0.1,-0.03];  % ���������ݵ�xƫ��
            texty = [3e5,-1e5,0,1.5e5,2.5e5,7e5,4.5e5,4.5e5,4.5e5,8.5e5,12.5e5];  % ���������ݵ�yƫ��
        case 'YaleB_c_shelter_10_10'
%             xi = 1e-4:1e-6:43e-4; %��ֵ��xi
            xmin = 0;  % ������
            xmax = 3.3;  % ������
            ymin = -0.5e6;  % ������
            ymax = 10e6;  % ������
            textmin = 1;  % ���������ݵ���ʼ��
            textmax = 11;  % ���������ݵ������
            textx = [1e-1,1e-1,1e-1,1e-1,1e-1,1e-1,1e-1,-1e-3,-0.3,-0.2,-0.15];  % ���������ݵ�xƫ��
            texty = [3e5,-1e5,0,1.5e5,1.5e5,5e5,4.5e5,4.5e5,4.5e5,8.5e5,12.5e5];  % ���������ݵ�yƫ��
    end
    
    % values = spcrv([[firstNormall(1,1) firstNormall(:,1)'
    % firstNormall(1,end)];[traceNormall(1,1) traceNormall(:,1)'
    % traceNormall(1,end)]],3,1000);  % �������  �޷������ݵ�
    % L = plot(values(1,:),values(2,:),'-k');
    close all;
    figure;
%     values = interp1(firstNormall(:,1),traceNormall(:,1),xi,'pchip');  %spline cubic % ʹ�ò�ֵ��������
%     L = plot(xi,values,'-k');  % ʹ�ò�ֵ���������
    hold on
    P = plot(firstNormall(:,1), traceNormall(:,1), '-ko'); % �����ϱ�����ݵ�
    xlabel('$\|X-UV\|_F^2$','fontsize',10,'interpreter','latex');
    ylabel('$\rm{tr}(V(L+\alpha L_D) V^T)$','fontsize',10,'interpreter','latex');
    axis([xmin,xmax,ymin,ymax]);
    set(P,'LineWidth',1.5); % MarkerFaceColor, MarketEdgeColor
    set(P,'MarkerSize',7);
    for i = textmin:textmax
        text(firstNormall(i,1) + textx(i), traceNormall(i,1) + texty(i), lambdaallStr{i},'interpreter','latex');
    end
%     set(gca,'Xscale','log')
%     set(gca,'Yscale','log')
%     break
    outfilename = sprintf(outfilebasestr, data);
    fprintf('outfile: %s\n',fullfile(outfiledir,outfilename));
    set(gcf, 'PaperPositionMode', 'auto');
    print(gcf, '-depsc2', fullfile(outfiledir,outfilename));
    
end