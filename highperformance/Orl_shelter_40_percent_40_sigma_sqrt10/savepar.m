function savepar(filename,H,HG,HGd,Wcell,fval)
fvalH = fval(1);
fvalHG = fval(2);
fvalHGd = fval(3);
save(filename,'H','HG','HGd','Wcell','fvalH','fvalHG','fvalHGd');

end