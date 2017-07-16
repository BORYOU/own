function [Accu] = Accuracy(fold,A,Y,H_final)

% ���ࣺ SVM ������
% fold :�������Ը����ѵ�����������Ĳ��������в��Ը�������Ϊ �ܸ�����/fold
% Y ; ����±�
% H_final = H_final./repmat(sqrt(sum(H_final.^2,1)),size(H_final,1),1);
GroupNum = length(unique(Y)); %��ȡ���ݵ�����
TrLabel = Y'; %������±�ת��
% fold = 2; %�������Ը����ѵ�����������Ĳ��������в��Ը�������Ϊ �ܸ�����/fold������ȡ��
% if isempty(set)
%     set = 'ORL';
% end

addpath('Liblinear\matlab');
for SVM_num = 1:100  % 
    [AT,AR,YT,YR,testDI,trainDI] = Create10foldData(A',TrLabel,fold); %��Y��fold�������ѵ�������Ͳ��������ĸ����±꼯��
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
    H_all = H_final; %��������
    H_train = H_all(:,trainDI); %ѵ������
%     model2 = train(double(YR), sparse(H_train'), options);
    model = train(double(YR), sparse(H_train'),'-q');
    H_test = H_all(:,testDI); %��������
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
    NDperC(i) = size( find(Y==i),1 ); %��ȡ��i������еĸ�����
    testDIn(i)= floor(NDperC(i)/fold); %�����i�������������Եĸ�����
end

%Randomly creates 10 times for 10-fold cross validation

testDI=[]; % ���Լ��±�
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