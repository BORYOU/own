load('Orlinit.mat'); %载入数据：A：原始数据矩阵，10304*400；Y：分类下标，400*1，一个人有十张脸部图片,图片的尺寸为 112*92
[M,N] = size(A); % M*N 为矩阵A的维数
A_new = A; % 给一部分（80%）照片加随机遮挡规格为 30*40
for i=1:400
   if mod(i,10) < 3
       continue;
   end
   a = A(:,i);
   face = reshape(a,112,92);
   lm = round(80*rand)+1;
   ln = round(50*rand)+1;
   face(lm:lm+29,ln:ln+39) = 0;
   a = reshape(face,10304,1);
   A_new(:,i) = a;
end
A = A_new;
save('Orlinit_shelter','A','Y');