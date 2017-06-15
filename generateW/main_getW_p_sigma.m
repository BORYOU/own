
for database = {'OA'} % {'Y1','Y4'} %{'O9'}%{'l'} %{'Y5'}%{'Y3','Y4'}%{'O6','O7'}%{'O5'}%{'Y1','Y2'}%{'O1','O2','O3','O4'}
    for p = 2:10 %3:3:30 %
        for sigma = [sqrt(10)] %][sqrt(2),sqrt(5),sqrt(10),sqrt(15),sqrt(20)]
            outfile = GetW_caideng(database, p, sigma)
        end
    end
end
