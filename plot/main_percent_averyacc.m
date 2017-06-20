clear all; clc; close all;

datadir = '../highperformance/accuracy';
datafilebasestr = 'Orl_shelter_40_percent_%d_sigma_sqrt10allbestfinal1to13.mat';
outfiledir = 'fig';
outfilename = 'sOrl40_percent_aver_kallbest.eps';
if ~exist(outfiledir,'dir')
    mkdir(outfiledir);
end

AccuracyN_ASCG_aver = zeros(6,1);
AccuracyG_ASCG_aver = zeros(6,1);
AccuracyGd_ASCG_aver = zeros(6,1);
i = 1;
load(fullfile(datadir,'ORLallbestfinal1to13.mat'),'AccuracyN_ASCG','AccuracyG_ASCG','AccuracyGd_ASCG');
AccuracyN_ASCG_aver(i) = mean(AccuracyN_ASCG);
AccuracyG_ASCG_aver(i) = mean(AccuracyG_ASCG);
AccuracyGd_ASCG_aver(i) = mean(AccuracyGd_ASCG);

for percent = 20:20:80
    i = i + 1;
    if percent == 80
        break
    end
    filename = sprintf(datafilebasestr, percent);
    fprintf('file: %s\n',filename);
    load(fullfile(datadir,filename),'AccuracyN_ASCG','AccuracyG_ASCG','AccuracyGd_ASCG');
    AccuracyN_ASCG_aver(i) = mean(AccuracyN_ASCG);
    AccuracyG_ASCG_aver(i) = mean(AccuracyG_ASCG);
    AccuracyGd_ASCG_aver(i) = mean(AccuracyGd_ASCG);
end
i = i + 1;
load(fullfile(datadir,'sORL40allbestfinal1to13.mat'),'AccuracyN_ASCG','AccuracyG_ASCG','AccuracyGd_ASCG');
AccuracyN_ASCG_aver(i) = mean(AccuracyN_ASCG);
AccuracyG_ASCG_aver(i) = mean(AccuracyG_ASCG);
AccuracyGd_ASCG_aver(i) = mean(AccuracyGd_ASCG);

figure;
hold on;
nmf = line(0:20:100,AccuracyN_ASCG_aver);
gnmf = line(0:20:100,AccuracyG_ASCG_aver);
gnmfd = line(0:20:100,AccuracyGd_ASCG_aver);
ylim([60,100]);
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

hXLabel = xlabel('Percent of shelter(%)');
hYLabel = ylabel('Accuracy(%)');

hLegend = legend(           ...
    [nmf, gnmf, gnmfd]      , ...
    'NMF'                   , ...
    'GNMF'                  , ...
    'GNMFO'                 , ...
    'location', 'SouthEast' );

set(gcf, 'PaperPositionMode', 'auto');
fprintf('outfile: %s\n',fullfile(outfiledir,outfilename));
print(gcf, '-depsc2', fullfile(outfiledir,outfilename));