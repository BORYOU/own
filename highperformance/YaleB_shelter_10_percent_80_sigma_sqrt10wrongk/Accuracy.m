function [Accu] = Accuracy(fold,A,Y,H_final)

% 分类： SVM 分类器
% fold :决定测试个体和训练个体数量的参数，其中测试个体数量为 总个体数/fold
% Y ; 类别下标
% H_final = H_final./repmat(sqrt(sum(H_final.^2,1)),size(H_final,1),1);
GroupNum = length(unique(Y)); %提取数据的组数
TrLabel = Y'; %将类别下标转置
% fold = 2; %决定测试个体和训练个体数量的参数，其中测试个体数量为 总个体数/fold，向下取整
% if isempty(set)
%     set = 'ORL';
% end

addpath('Liblinear\matlab');
for SVM_num = 1:100  % 
    [AT,AR,YT,YR,testDI,trainDI] = Create10foldData(A',TrLabel,fold); %按Y与fold随机生成训练样本和测试样本的个体下标集合
    %length(testDI)
    %length(trainDI)
%     ntest = length(YT);
    
%     switch set
%         case 'ORL'
%             t=10;obj=40;
%         case 'Yale'
%             t=11;obj=15;
%     end
%     %t = 10;
%     options = ['-c ' num2str(t)];
    H_all = H_final; %总体样本
    H_train = H_all(:,trainDI); %训练样本
%     model2 = train(double(YR), sparse(H_train'), options);
    model = train(double(YR), sparse(H_train'),'-q');
    H_test = H_all(:,testDI); %测试样本
    [~,accu] = predict(YT, sparse(H_test'), model);
%     [C,accu2] = predict(YT, sparse(H_test'), model2);
%     rec_num = 0;
%     num = ntest/obj;
%     for i=1:ntest
%         if ceil(i/num) == C(i)
%             rec_num = rec_num+1;
%         end
%     end
    acc(SVM_num) = accu;
%     acc2(SVM_num) = accu2;
end

Accu.acc = mean(acc);
Accu.max = max(acc);
Accu.min = min(acc);

vari1 = acc - Accu.acc;
Accu.var = sum(vari1.^2)/100;

% Accu.acc2 = mean(acc2);
% Accu.max2 = max(acc2);
% Accu.min2 = min(acc2);
% 
% vari2 = acc2 - Accu.acc2;
% Accu.var2 = sum(vari1.^2)/20


function [AT,AR,YT,YR,testDI,trainDI] = Create10foldData(A,Y,fold)

%m number of region
%k number of annotation
%n number of image

[n,m]=size(A);

%number of classes
le = length(unique(Y));

%The number of training data is 1/fold of the whole data set

NDperC = zeros(le,1);
for i=1:le
    NDperC(i) = size( find(Y==i),1 ); %提取第i个类别中的个体数
    testDIn(i)= floor(NDperC(i)/fold); %计算第i个类别的用作测试的个体数
end

%Randomly creates 10 times for 10-fold cross validation

testDI=[]; % 测试集下标
trainDI=[];
current=0;
for j=1:le
    testDIj = rd(testDIn(j),NDperC(j))+current;
    current = current + NDperC(j);
    testDI = [testDI testDIj'];
end
for i=1:n
    if sum(testDI==i)>0
        trainDI(i)=0;
    else
        trainDI(i)=i;
    end
end
trainDI = find(trainDI>0);

lentestDI = length(testDI);
lentrainDI = length(trainDI);
AT=A(testDI,:);
AR=A(trainDI,:);
YT=Y(testDI);
YR=Y(trainDI);
