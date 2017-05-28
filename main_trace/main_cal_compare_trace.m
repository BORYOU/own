% calculate trace for GNMF, GNMFO  
% calculate similar matrix number for correct size minus wrong size
% load file from 'I:\Face Recognition\highperform\12_1\' + data  

data = 'orl30new'; Wfile = 'W_cai_sOrl30.mat';
dirname = fullfile('F:\\','Face Recognition','highperform','12_1',data);
aAll = [0.1,0.3,0.5,0.7,0.9,3,5,7,9,11];

load(fullfile(dirname, Wfile));
W1 = W_hk_c; W2 = W_diff_c; N = size(W_hk_c,1);
DCol = full(sum(W1,2)); D = spdiags(DCol,0,N,N); L = D - W1;
DCol = full(sum(W2,2)); D = spdiags(DCol,0,N,N); Ld = D - W2;


WAll = cell(length(aAll),1);
LaAll = cell(length(aAll),1);

for aIndex = 1:length(aAll)
a = aAll(aIndex);
W = W1 + a*W2;
DCol = full(sum(W,2)); D = spdiags(DCol,0,N,N); La = D - W;
WAll{aIndex,1} = W;
LaAll{aIndex,1} = La;
end

TraceGL = zeros(10,10);  % gamma * k
TraceGLd = zeros(10,10);
TraceGdL = zeros(10,10,10);  % gamma * k * alpha
TraceGdLd = zeros(10,10,10);

c_m_w_Gall = zeros(10,10);
c_m_w_Gdall = zeros(10,10,10);
w_Gall = zeros(10,10);
w_Gdall = zeros(10,10,10);

tic
for kIndex = 1:10
    for gammaIndex = 1:10
        for alphaIndex = 1:10
            i = 100*(kIndex-1) + 10*(gammaIndex-1) + alphaIndex
            load(fullfile(dirname,['sORL30allbest',num2str(i),'.mat']));
            if alphaIndex == 1
                TraceGL(gammaIndex,kIndex) = trace(HG*L*HG');
                TraceGLd(gammaIndex,kIndex,alphaIndex) = trace(HG*Ld*HG');
                
%                 [c_m_w_G, w_G] = calculate_similarMatrix_number(W1);  %% GNMF
%                 c_m_w_Gall(gammaIndex,kIndex) = c_m_w_G;
%                 w_Gall(gammaIndex,kIndex) = w_G;
                
            end
            La = LaAll{alphaIndex,1};
            TraceGdL(gammaIndex,kIndex,alphaIndex) = trace(HGd*L*HGd');
            TraceGdLd(gammaIndex,kIndex,alphaIndex) = trace(HGd*Ld*HGd');
            
%             [c_m_w_Gd, w_Gd] = calculate_similarMatrix_number(W1);  %% GNMFO
%             c_m_w_Gdall(gammaIndex,kIndex) = c_m_w_Gd;
%             w_Gdall(gammaIndex,kIndex) = w_Gd;
        end
    end
end


toc
save(['trace_','Face Recognition','highperform','12_1',data],'TraceGL','TraceGLd','TraceGdL','TraceGdLd');

i= 10； %% alpah 大的时候会好
figure
hold on
surf(TraceGL,'FaceColor','g');
surf(TraceGdLd(:,:,i),'FaceColor','r');

figure
hold on
surf(TraceGLd,'FaceColor','g');
surf(TraceGdLd(:,:,i),'FaceColor','r');
