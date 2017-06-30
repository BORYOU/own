function [diffXA, diffYA] = getDiffXY(A, len_row, len_colunm)

N = size(A,2);
diffXA = zeros(len_row*(len_colunm-1),N);
diffYA = zeros((len_row-1)*len_colunm,N);
for i=1:N
    pic = reshape(A(:,i),len_row,len_colunm);    % initial pic
    [diffxpic,diffypic] = getdiffpic(pic);
    diffXA(:,i) = reshape(diffxpic,len_row*(len_colunm-1),1);
    diffYA(:,i) = reshape(diffypic,(len_row-1)*len_colunm,1);
end

function [diffxpic,diffypic] = getdiffpic(pic)

[picM,picN] = size(pic);
diffxpic = zeros(picM, picN-1);
diffypic = zeros(picM-1, picN);
for i = 1:picN-1
    diffxpic(:,i) = pic(:,i)-pic(:,i+1);
end
for i = 1:picM-1
    diffypic(i,:) = pic(i,:)-pic(i+1,:);
end
