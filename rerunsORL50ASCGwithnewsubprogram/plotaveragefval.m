asfval = {5};
pgfval = {5};
mufval = {5};
astime = {5};
pgtime = {5};
mutime = {5};
for i = 1 : 5,
    
    filename = ['sORL50acc',num2str(i),'.mat'];
    load(filename,'GdASCG','GdPG','T_execution','V_fval');
    asfval{i} = GdASCG.V_fval;
    astime{i} = GdASCG.T_execution;
    pgfval{i} =  GdPG.V_fval;
    pgtime{i} = GdPG.T_execution;
    mufval{i} = V_fval;
    mutime{i} = T_execution;
end

timelimit = 1500;

[asavertime,asaverfval] = averagespeed(asfval, astime, timelimit);
[pgavertime,pgaverfval] = averagespeed(pgfval, pgtime, timelimit);
[muavertime,muaverfval] = averagespeed(mufval, mutime, timelimit);
figure
hold on
as = plot(asavertime,asaverfval,'k.-','MarkerSize',8);
pg = plot(pgavertime,pgaverfval, 'm^-', 'MarkerSize',5);
mu = plot(muavertime,muaverfval,'b+-','MarkerSize',3);
xlim([0,900]);
xlabel('Time(s)');
ylabel('Objective function value');
legend([as,pg,mu],'ASCG','PG','MU','Location','NorthEast');
