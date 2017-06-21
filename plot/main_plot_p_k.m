clear all; clc;
psigmaPath = '../main_p_sigma';

outfiledir = 'fig';
outfilebasestr = '%s_pvary.eps';

dataall = {
%     'Orl';
%     'Orl_shelter_30_30';
%     'Orl_shelter_40_40';
%     'Orl_shelter_50_50';
    'YaleB_c';
    'YaleB_c_shelter_10_10';
    };

pall = 2:10;

for dataindex = 1:length(dataall)
    data = dataall{dataindex};
    fprintf('%s\n',data);
    
    switch data
        case 'Orl'
            sigmaall = [sqrt(10)];
            coll = 1;
            ymin = 70;  % 坐标轴
            ymax = 100;  % 坐标轴
            xmin = 2;
            xmax = 7;
        case 'Orl_shelter_30_30'
            sigmaall = [sqrt(2),sqrt(5),sqrt(10),sqrt(15),sqrt(20)];
            coll = 3;
            ymin = 60;  % 坐标轴
            ymax = 90;  % 坐标轴
            xmin = 2;
            xmax = 7;
        case 'Orl_shelter_40_40'
            sigmaall = [sqrt(2),sqrt(10)];
            coll = 2;
            ymin = 60;  % 坐标轴
            ymax = 85;  % 坐标轴
            xmin = 2;
            xmax = 7;
        case 'Orl_shelter_50_50'
            sigmaall = [sqrt(2),sqrt(10)];
            coll = 2;
            ymin = 55;  % 坐标轴
            ymax = 80;  % 坐标轴
            xmin = 2;
            xmax = 7;
        case 'YaleB_c'
            pall = 3:3:30;
            sigmaall = [sqrt(10)];
            coll = 1;
%             coll = 3;
            ymin = 70;  % 坐标轴
            ymax = 100;  % 坐标轴
        case 'YaleB_c_shelter_10_10'
            pall = 3:3:30;
            sigmaall = [sqrt(10)];
            coll = 1;
            xmin = pall(start);
            xmax = pall(start);
%             coll = 3;
            ymin = 60;  % 坐标轴
            ymax = 90;  % 坐标轴
    end
    
    fileDirName = fullfile(psigmaPath, [data, '_p_',num2str(pall(1)),'_',num2str(pall(end)),'_sigma_',num2str(sigmaall(1)),'_',num2str(sigmaall(end))]);
    load(fullfile(fileDirName,[data,'all.mat']),'HGAall','HGdAall');
    
%     close all;
    figure;
    hold on
    gnmfp = plot(pall, HGAall(:,coll)); % 曲线上标出数据点
    gnmfdp = plot(pall, HGdAall(:,coll));
    
    set(gnmfp                     , ...
      'Color'           , 'r'    , ...
      'LineWidth'       , 1.5    , ...
      'Marker'          , 'o'    , ...
      'MarkerSize'      , 6      , ...
      'MarkerEdgeColor' , 'r'    , ...
      'MarkerFaceColor' , 'r'    );
    
    set(gnmfdp               , ...
        'Color'           , 'b'    , ...
        'LineWidth'       , 1.5    , ...
        'Marker'          , '^'    , ...
        'MarkerSize'      , 5      , ...
        'MarkerEdgeColor' , 'b'    , ...
        'MarkerFaceColor' , 'b'    );
    
    xlabel('$p$','fontsize',10,'interpreter','latex');
    ylabel('Accuracy(%)','fontsize',10);
%     ylim([ymin,ymax]);
    axis([xmin,xmax,ymin,ymax])
    
    hLegend = legend(           ...
        [gnmfp, gnmfdp]      , ...
        'GNMF'                  , ...
        'GNMFO'                 , ...
        'location', 'SouthEast' );
    
    break
    outfilename = sprintf(outfilebasestr, data);
    fprintf('outfile: %s\n',fullfile(outfiledir,outfilename));
    set(gcf, 'PaperPositionMode', 'auto');
%     print(gcf, '-depsc2', fullfile(outfiledir,outfilename));
    
end
