function outfilename = addshelter(database, percent, shelter)
% add shelter on database in percent, out file name is data_shelter_shelter_percent_percent.mat
% database:
%           'Y': 'YaleB_c.mat'
%           'O': 'Orl.mat'
% percent: 87 means 87%
% shelter: 20 means 20 * 20 shelter

    if database == 'Y'
        data = 'YaleB_c';
        %载入数据：A：原始数据矩阵，1024*2414；Y：分类下标，1*2414，一个人有越64张脸部图�?图片的尺寸为 32*32
        facem = 32;
        facen = 32;
    elseif database == 'O'
        data = 'Orl';
        %载入数据：A：原始数据矩阵，10304*400；Y：分类下标，1*400，一个人有十张脸部图�?图片的尺寸为 112*92
        facem = 112;
        facen = 92;
    end
    load([data, '.mat'])
    [M,N] = size(A);
    picNum = size(Y, 2);
    peopleNum = size(unique(Y), 2);
    for i = 1 : peopleNum
        % get pic coll number of this person
        y = find(Y==i);
        firstInd = min(y);
        lastInd = max(y);
        personNum = lastInd - firstInd + 1;
        % calculate shelter coll number
        shelterNum = round((personNum * percent / 100))
        try
            addList = randperm(personNum, shelterNum) + (firstInd - 1);
        catch
            randlist = randperm(personNum);
            addList = randlist(1:shelterNum) + (firstInd - 1);
        end
        for coll = addList
            a = A(:,coll);
            face = reshape(a,facem,facen);
            lm = round((facem-shelter)*rand)+1;
            ln = round((facen-shelter)*rand)+1;
            face(lm:lm+shelter-1,ln:ln+shelter-1) = 0;
            %imagesc(face);
            %colormap('gray')
            %pause(1)
            a = reshape(face,M,1);
            A(:,coll) = a/sum(a);
        end
    end
    outfilename = [data,'_shelter_',num2str(shelter),'_percent_',num2str(percent),'.mat'];
    save(outfilename,'A','Y');