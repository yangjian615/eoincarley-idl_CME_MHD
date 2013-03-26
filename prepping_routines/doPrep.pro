function doPrep,p

p=1
fls = file_search('*.fts')

for i =0,212,3 do secchi_prep,fls[i:i+2],savepath='/Users/eoincarley/data/secchi_l1/cor1_wholeday/a',/write_fts,$
    /rotate_on,/rotinterp_on,/polariz_on,/smask_on,/fill_mean

 
end    