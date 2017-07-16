function W = constructW(fea,options)
%	Usage:
%	W = constructW(fea,options)
%
%	fea: Rows of vectors of data points. Each row is x_i
%   options: Struct value in Matlab. The fields in options that can be set:
%                  
%           NeighborMode -  Indicates how to construct the graph. Choices
%                           are: [Default 'KNN']
%                'KNN'            -  k = 0
%                                       Complete graph
%                                    k > 0
%                                      Put an edge between two nodes if and
%                                      only if they are among the k nearst
%                                      neighbors of each other. You are
%                                      required to provide the parameter k in
%                                      the options. Default k=5.
%               'Supervised'      -  k = 0
%                                       Put an edge between two nodes if and
%                                       only if they belong to same class. 
%                                    k > 0
%                                       Put an edge between two nodes if
%                                       they belong to same class and they
%                                       are among the k nearst neighbors of
%                                       each other. 
%                                    Default: k=0
%                                   You are required to provide the label
%                                   information gnd in the options.
%                                              
%           WeightMode   -  Indicates how to assign weights for each edge
%                           in the graph. Choices are:
%               'Binary'       - 0-1 weighting. Every edge receiveds weight
%                                of 1. 
%               'HeatKernel'   - If nodes i and j are connected, put weight
%                                W_ij = exp(-norm(x_i - x_j)/2t^2). You are 
%                                required to provide the parameter t. [Default One]
%               'Cosine'       - If nodes i and j are connected, put weight
%                                cosine(x_i,x_j). 
%               
%            k         -   The parameter needed under 'KNN' NeighborMode.
%                          Default will be 5.
%            gnd       -   The parameter needed under 'Supervised'
%                          NeighborMode.  Colunm vector of the label
%                          information for each data point.
%            bLDA      -   0 or 1. Only effective under 'Supervised'
%                          NeighborMode. If 1, the graph will be constructed
%                          to make LPP exactly same as LDA. Default will be
%                          0. 
%            t         -   The parameter needed under 'HeatKernel'
%                          WeightMode. Default will be 1
%         bNormalized  -   0 or 1. Only effective under 'Cosine' WeightMode.
%                          Indicates whether the fea are already be
%                          normalized to 1. Default will be 0
%      bSelfConnected  -   0 or 1. Indicates whether W(i,i) == 1. Default 0
%                          if 'Supervised' NeighborMode & bLDA == 1,
%                          bSelfConnected will always be 1. Default 0.
%            bTrueKNN  -   0 or 1. If 1, will construct a truly kNN graph
%                          (Not symmetric!). Default will be 0. Only valid
%                          for 'KNN' NeighborMode
%
%
%    Examples:
%
%       fea = rand(50,15);
%       options = [];
%       options.NeighborMode = 'KNN';
%       options.k = 5;
%       options.WeightMode = 'HeatKernel';
%       options.t = 1;
%       W = constructW(fea,options);
%       
%       
%       fea = rand(50,15);
%       gnd = [ones(10,1);ones(15,1)*2;ones(10,1)*3;ones(15,1)*4];
%       options = [];
%       options.NeighborMode = 'Supervised';
%       options.gnd = gnd;
%       options.WeightMode = 'HeatKernel';
%       options.t = 1;
%       W = constructW(fea,options);
%       
%       
%       fea = rand(50,15);
%       gnd = [ones(10,1);ones(15,1)*2;ones(10,1)*3;ones(15,1)*4];
%       options = [];
%       options.NeighborMode = 'Supervised';
%       options.gnd = gnd;
%       options.bLDA = 1;
%       W = constructW(fea,options);      
%       
%
%    For more details about the different ways to construct the W, please
%    refer:
%       Deng Cai, Xiaofei He and Jiawei Han, "Document Clustering Using
%       Locality Preserving Indexing" IEEE TKDE, Dec. 2005.
%    
%
%    Written by Deng Cai (dengcai2 AT cs.uiuc.edu), April/2004, Feb/2006,
%                                             May/2007
% 

bSpeed  = 1;

if ~isfield(options,'bNormalized')
    options.bNormalized = 0;
end

bBinary = 0;
bCosine = 0;
bBinary = 1;

options.bSelfConnected = 0;

%=================================================
nSmp = size(fea,1);

maxM = 62500000; %500M
BlockSize = floor(maxM/(nSmp*3));

G = zeros(nSmp*(options.k+1),3);
for i = 1:ceil(nSmp/BlockSize)
    if i == ceil(nSmp/BlockSize)
        smpIdx = (i-1)*BlockSize+1:nSmp;
        dist = EuDist2(fea(smpIdx,:),fea,0);
        
        if bSpeed
            nSmpNow = length(smpIdx);
            dump = zeros(nSmpNow,options.k+1);
            idx = dump;
            for j = 1:options.k+1
                [dump(:,j),idx(:,j)] = min(dist,[],2);
                temp = (idx(:,j)-1)*nSmpNow+[1:nSmpNow]';
                dist(temp) = 1e100;
            end
        else
            [dump idx] = sort(dist,2); % sort each row
            idx = idx(:,1:options.k+1);
            dump = dump(:,1:options.k+1);
        end
        
        if ~bBinary
            if bCosine
                dist = Normfea(smpIdx,:)*Normfea';
                dist = full(dist);
                linidx = [1:size(idx,1)]';
                dump = dist(sub2ind(size(dist),linidx(:,ones(1,size(idx,2))),idx));
            else
                dump = exp(-dump/(2*options.t^2));
            end
        end
        
        G((i-1)*BlockSize*(options.k+1)+1:nSmp*(options.k+1),1) = repmat(smpIdx',[options.k+1,1]);
        G((i-1)*BlockSize*(options.k+1)+1:nSmp*(options.k+1),2) = idx(:);
        if ~bBinary
            G((i-1)*BlockSize*(options.k+1)+1:nSmp*(options.k+1),3) = dump(:);
        else
            G((i-1)*BlockSize*(options.k+1)+1:nSmp*(options.k+1),3) = 1;
        end
    else
        smpIdx = (i-1)*BlockSize+1:i*BlockSize;
        
        dist = EuDist2(fea(smpIdx,:),fea,0);
        
        if bSpeed
            nSmpNow = length(smpIdx);
            dump = zeros(nSmpNow,options.k+1);
            idx = dump;
            for j = 1:options.k+1
                [dump(:,j),idx(:,j)] = min(dist,[],2);
                temp = (idx(:,j)-1)*nSmpNow+[1:nSmpNow]';
                dist(temp) = 1e100;
            end
        else
            [dump idx] = sort(dist,2); % sort each row
            idx = idx(:,1:options.k+1);
            dump = dump(:,1:options.k+1);
        end
        
        if ~bBinary
            if bCosine
                dist = Normfea(smpIdx,:)*Normfea';
                dist = full(dist);
                linidx = [1:size(idx,1)]';
                dump = dist(sub2ind(size(dist),linidx(:,ones(1,size(idx,2))),idx));
            else
                dump = exp(-dump/(2*options.t^2));
            end
        end
        
        G((i-1)*BlockSize*(options.k+1)+1:i*BlockSize*(options.k+1),1) = repmat(smpIdx',[options.k+1,1]);
        G((i-1)*BlockSize*(options.k+1)+1:i*BlockSize*(options.k+1),2) = idx(:);
        if ~bBinary
            G((i-1)*BlockSize*(options.k+1)+1:i*BlockSize*(options.k+1),3) = dump(:);
        else
            G((i-1)*BlockSize*(options.k+1)+1:i*BlockSize*(options.k+1),3) = 1;
        end
    end
end

W = sparse(G(:,1),G(:,2),G(:,3),nSmp,nSmp);

if bBinary
    W(logical(W)) = 1;
end

if isfield(options,'bSemiSupervised') && options.bSemiSupervised
    tmpgnd = options.gnd(options.semiSplit);
    
    Label = unique(tmpgnd);
    nLabel = length(Label);
    G = zeros(sum(options.semiSplit),sum(options.semiSplit));
    for idx=1:nLabel
        classIdx = tmpgnd==Label(idx);
        G(classIdx,classIdx) = 1;
    end
    Wsup = sparse(G);
    if ~isfield(options,'SameCategoryWeight')
        options.SameCategoryWeight = 1;
    end
    W(options.semiSplit,options.semiSplit) = (Wsup>0)*options.SameCategoryWeight;
end

if ~options.bSelfConnected
    W = W - diag(diag(W));
end

if isfield(options,'bTrueKNN') && options.bTrueKNN
    
else
    W = max(W,W');
end

return;


% strcmpi(options.NeighborMode,'KNN') & (options.k == 0)
% Complete Graph

switch lower(options.WeightMode)
    case {lower('Binary')}
        error('Binary weight can not be used for complete graph!');
    case {lower('HeatKernel')}
        W = EuDist2(fea,[],0);
        W = exp(-W/(2*options.t^2));
    case {lower('Cosine')}
        W = full(Normfea*Normfea');
    otherwise
        error('WeightMode does not exist!');
end

if ~options.bSelfConnected
    for i=1:size(W,1)
        W(i,i) = 0;
    end
end

W = max(W,W');


function D = EuDist2(fea_a,fea_b,bSqrt)
%EUDIST2 Efficiently Compute the Euclidean Distance Matrix by Exploring the
%Matlab matrix operations.
%
%   D = EuDist(fea_a,fea_b)
%   fea_a:    nSample_a * nFeature
%   fea_b:    nSample_b * nFeature
%   D:      nSample_a * nSample_a
%       or  nSample_a * nSample_b
%
%    Examples:
%
%       a = rand(500,10);
%       b = rand(1000,10);
%
%       A = EuDist2(a); % A: 500*500
%       D = EuDist2(a,b); % D: 500*1000
%
%   version 2.1 --November/2011
%   version 2.0 --May/2009
%   version 1.0 --November/2005
%
%   Written by Deng Cai (dengcai AT gmail.com)


if ~exist('bSqrt','var')
    bSqrt = 1;
end

if (~exist('fea_b','var')) || isempty(fea_b)
    aa = sum(fea_a.*fea_a,2);
    ab = fea_a*fea_a';
    
    if issparse(aa)
        aa = full(aa);
    end
    
    D = bsxfun(@plus,aa,aa') - 2*ab;
    D(D<0) = 0;
    if bSqrt
        D = sqrt(D);
    end
    D = max(D,D');
else
    aa = sum(fea_a.*fea_a,2);
    bb = sum(fea_b.*fea_b,2);
    ab = fea_a*fea_b';

    if issparse(aa)
        aa = full(aa);
        bb = full(bb);
    end

    D = bsxfun(@plus,aa,bb') - 2*ab;
    D(D<0) = 0;
    if bSqrt
        D = sqrt(D);
    end
end



