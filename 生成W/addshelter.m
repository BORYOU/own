function addshelter(database, percent, shelter)
% database:
%           'Y': 'YaleB_c.mat'
%           'O': 'Orl.mat'
% percent: 87 means 87%
% shelter: 20 means 20 * 20 shelter
    if database == 'Y'
        load('YaleB_c.mat','A','Y');
    elseif database == 'O'
        load('Orl.mat')
        %载入数据：A：原始数据矩阵，10304*400；Y：分类下标，400*1，一个人有十张脸部图片,图片的尺寸为 112*92
    end

    [M,N] = size(A);
    picNum = size(Y);
    personNum = size(unique(Y));
    A_new = A;
    for i = 1 : personNum
        
        if mod(i,10) < 3
            continue;
        end
        a = A(:,i);
        face = reshape(a,112,92);
        lm = round(80*rand)+1;
        ln = round(50*rand)+1;
        face(lm:lm+29,ln:ln+39) = 0;
        a = reshape(face,10304,1);
        A_new(:,i) = a/sum(a);
    end
    for i=1:2414
    %    if mod(i,10) < 3
    %        continue;
    %    end
        a = A(:,i);
        face = reshape(a,32,32);
        lm = round(15*rand)+1;
        ln = round(15*rand)+1;
        face(lm:lm+14,ln:ln+14) = 0;
    %    imagesc(face);colormap(gray);
        a = reshape(face,1024,1);
        A_new(:,i) = a/sum(a);
    end
    
    save('YaleB_c_shelter','A','Y');