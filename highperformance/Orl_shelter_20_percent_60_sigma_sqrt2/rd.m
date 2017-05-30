function [num]=rd(n,maxi)
%随机生成n个不同的整数值，区域在[1，maxi]
num=zeros(n,1);
i=1;
while i<=n
    a=ceil(rand(1,1)*maxi);
    if a~=0
        b=0;
        for j=1:i
            if a==num(j)
               b=b+1;
               break;
            end
        end
        if b==0
            num(i,1)=a;
            i=i+1;
        end
    end
end   
num=sort(num);
