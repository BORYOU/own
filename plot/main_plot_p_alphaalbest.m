clear all; clc;
pPath = '../main_p_sigma/finalvaryalphaallbest';

outfiledir = 'fig';
outfilebasestr = '%s_pvaryalphaallbest.eps';

dataall = {
%     'Orl';
%     'Orl_shelter_30_30';
%     'Orl_shelter_40_40';
%     'Orl_shelter_50_50';
    'YaleB_c';
    'YaleB_c_shelter_10_10';
    };

for dataindex = 1:length(dataall)
    data = dataall{dataindex};
    fprintf('%s\n',data);
    
    switch data
        case 'Orl'
            pall = 2:7;
            ymin = 70;  % 坐标轴
            ymax = 100;  % 坐标轴
            xmin = 2;
            xmax = 7;
        case 'Orl_shelter_30_30'
            pall = 2:7;
            ymin = 60;  % 坐标轴
            ymax = 90;  % 坐标轴
            xmin = 2;
            xmax = 7;
        case 'Orl_shelter_40_40'
            pall = 2:7;
            ymin = 60;  % 坐标轴
            ymax = 90;  % 坐标轴
            xmin = 2;
            xmax = 7;
        case 'Orl_shelter_50_50'
            pall = 2:7;
            ymin = 60;  % 坐标轴
            ymax = 90;  % 坐标轴
            xmin = 2;
            xmax = 7;
        case 'YaleB_c'
            pall = 3:3:30;
            xmin = 3;
            xmax = 30;
            ymin = 70;  % 坐标轴
            ymax = 100;  % 坐标轴
        case 'YaleB_c_shelter_10_10'
            pall = 3:3:30;
            xmin = 3;
            xmax = 30;
            ymin = 60;  % 坐标轴
            ymax = 90;  % 坐标轴
    end
    
    load(fullfile(pPath,[data,'all.mat']),'HGAall','HGdAall');
    
    %     close all;
    figure;
    hold on
    gnmfp = plot(pall, HGAall); % 曲线上标出数据点
    gnmfdp = plot(pall, HGdAall);
    
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
    if strcmp(data(1),'Y')
       set(gca,'xtick',3:3:30); 
    end
    
    hLegend = legend(           ...
        [gnmfp, gnmfdp]      , ...
        'GNMF'                  , ...
        'GNMFO'                 , ...
        'location', 'SouthEast' );

%     break;
    outfilename = sprintf(outfilebasestr, data);
    fprintf('outfile: %s\n',fullfile(outfiledir,outfilename));
    set(gcf, 'PaperPositionMode', 'auto');
    print(gcf, '-depsc2', fullfile(outfiledir,outfilename));
    
end
