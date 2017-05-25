
for database = {'O2','O3','O4'}
    for p = 2:10
        for sigma = [sqrt(2),sqrt(5),sqrt(10),sqrt(15),sqrt(20)]
            outfile = GetW_caideng(database, p, sigma)
        end
    end
end
