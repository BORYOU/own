asacc = {5};
pgacc = {5};
muacc = {5};
astime = {5};
pgtime = {5};
mutime = {5};
ascgstoptime = zeros(5,1);
pgstoptime = zeros(5,1);
mustoptime = zeros(5,1);

for i = 1 : 5,
    
    filename = ['sORL50acc',num2str(i),'.mat'];
    load(filename,'AccuracyGNMFD_AS3','GdASCG','AccuracyGNMFD_PG3','GdPG',...
        'AccuracyGNMFD_MU3','T_execution','V_fval');
    asacc{i} = AccuracyGNMFD_AS3';
    astime{i} = GdASCG.T_execution;
    pgacc{i} =  AccuracyGNMFD_PG3';
    pgtime{i} = GdPG.T_execution;
    muacc{i} = AccuracyGNMFD_MU3';
    mutime{i} = T_execution;
    for j = 1: length(GdASCG.V_fval)-1
        if (GdASCG.V_fval(j)-GdASCG.V_fval(j+1))/GdASCG.V_fval(j) <= 0
            continue
        end
        if (GdASCG.V_fval(j)-GdASCG.V_fval(j+1))/GdASCG.V_fval(j) < 1e-4
            break
        end
    end
    ascgstoptime(i) = GdASCG.T_execution(j);
    for j = 1: length(GdPG.V_fval)-1
        if (GdPG.V_fval(j)-GdPG.V_fval(j+1))/GdPG.V_fval(j) <= 0
            continue
        end
        if (GdPG.V_fval(j)-GdPG.V_fval(j+1))/GdPG.V_fval(j) < 1e-4
            break
        end
    end
    pgstoptime(i) = GdPG.T_execution(j);
    for j = 1: length(V_fval)-1
        if (V_fval(j)-V_fval(j+1))/V_fval(j) <= 0
            continue
        end
        if (V_fval(j)-V_fval(j+1))/V_fval(j) < 1e-4
            break
        end
    end
    mustoptime(i) = T_execution(j);
    
end

ascgstoptimeave = mean(ascgstoptimeave);
pgstoptimeave = mean(pgstoptimeave);
mustoptimeave = mean(mustoptimeave);

timelimit = 1500;

[asavertime,asaveracc] = averagespeed(asacc, astime, timelimit);
[pgavertime,pgaveracc] = averagespeed(pgacc, pgtime, timelimit);
[muavertime,muaveracc] = averagespeed(muacc, mutime, timelimit);

for i = 1:length(asavertime)
    if asavertime(i) > ascgstoptimeave
        p = i-1;
        break
    end
end
for i = 1:length(pgavertime)
    if pgavertime(i) > pgstoptimeave
        q = i-1;
        break
    end
end
for i = 1:length(muavertime)
    if muavertime(i) > mustoptimeave
        r = i-1;
        break
    end
end

figure
hold on
as = plot(asavertime,asaveracc,'k.-','MarkerSize',8);
pg = plot(pgavertime,pgaveracc, 'm^-', 'MarkerSize',5);
mu = plot(muavertime,muaveracc,'b+-','MarkerSize',3);
plot(asavertime(p),asaveracc(p),'o');
plot(pgavertime(q),pgaveracc(q),'o');
plot(muavertime(r),muaveracc(r),'o');

xlim([0,900]);
xlabel('Time(s)');
ylabel('Accuracy(%)');
legend([as,pg,mu],'ASCG','PG','MU','Location','SouthEast');


