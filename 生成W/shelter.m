load('Orlinit.mat'); %�������ݣ�A��ԭʼ���ݾ���10304*400��Y�������±꣬400*1��һ������ʮ������ͼƬ,ͼƬ�ĳߴ�Ϊ 112*92
[M,N] = size(A); % M*N Ϊ����A��ά��
A_new = A; % ��һ���֣�80%����Ƭ������ڵ����Ϊ 30*40
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