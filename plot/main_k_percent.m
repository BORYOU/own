clear all; clc; close all;

datadir = '../highperformance/accuracy';
datafilebasestr = 'Orl_shelter_40_percent_%d_sigma_sqrt10allbestfinal1to13.mat';
outfiledir = 'fig';
outfilebasestr = 'sOrl40_%d_kallbest.eps';
if ~exist(outfiledir,'dir')
    mkdir(outfiledir);
end

kall = [50:10:140, 160, 180];

for percent = 20:20:80
    filename = sprintf(datafilebasestr, percent);
    fprintf('file: %s\n',filename);
    load(fullfile(datadir,filename),'AccuracyN_ASCG','AccuracyG_ASCG','AccuracyGd_ASCG');
    switch percent
        case 20
            ymin=70;
            ymax=100;
        case 40
            ymin=70;
            ymax=100;
        case 60
            ymin=70;
            ymax=100;
        case 80
            ymin=60;
            ymax=95;
    end
%     close all;
    figure;
    hold on;
    nmf = line(kall,AccuracyN_ASCG(1:12));
    gnmf = line(kall,AccuracyG_ASCG(1:12));
    gnmfd = line(kall,AccuracyGd_ASCG(1:12));
    ylim([ymin,ymax])
    set(nmf                     , ...
        'Color'           , 'r'    , ...
        'LineWidth'       , 1.5    , ...
        'Marker'          , '^'    , ...
        'MarkerSize'      , 6      , ...
        'MarkerEdgeColor' , 'r'    , ...
        'MarkerFaceColor' , 'r'    );
    set(gnmf                     , ...
        'Color'           , 'g'    , ...
        'LineWidth'       , 1.5    , ...
        'Marker'          , 'o'    , ...
        'MarkerSize'      , 6      , ...
        'MarkerEdgeColor' , 'g'    , ...
        'MarkerFaceColor' , 'g'    );
    
    set(gnmfd                    , ...
        'Color'           , 'b'    , ...
        'LineWidth'       , 1.5    , ...
        'Marker'          , 's'    , ...
        'MarkerSize'      , 6      , ...
        'MarkerEdgeColor' , 'b'    , ...
        'MarkerFaceColor' , 'b'    );
    
    set(gca,'XTick',kall)  
    set(gca,'XTickLabel',{'50','60','70','80','90','100','110','120','130','140','160','180'})
    
    hXLabel = xlabel('number of bases $r$','interpreter','latex');
    hYLabel = ylabel('Accuracy(%)');
    
    hLegend = legend(           ...
        [nmf, gnmf, gnmfd]      , ...
        'NMF'                   , ...
        'GNMF'                  , ...
        'GNMFO'                 , ...
        'location', 'SouthEast' );
    
    set(gcf, 'PaperPositionMode', 'auto');
    outfilename = sprintf(outfilebasestr, percent);
    fprintf('outfile: %s\n',fullfile(outfiledir,outfilename));
    print(gcf, '-depsc2', fullfile(outfiledir,outfilename));
%     print -depsc2 outfiledir/sorlk1e4allbest.eps
    pause(5)
end