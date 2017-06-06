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