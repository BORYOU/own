function savepar(filename,H,HG,HGd,fval)
fvalH = fval(1);
fvalHG = fval(2);
fvalHGd = fval(3);
save(filename,'H','HG','HGd','fvalH','fvalHG','fvalHGd');

end