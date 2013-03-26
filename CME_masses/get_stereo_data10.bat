files30=sock_find('http://stereo-ssc.nascom.nasa.gov/','*n4*.fts',path='data/ins_data/secchi/L0/b/img/euvi/20071230')
for i=750,N_ELEMENTS(files30)-1 do begin sock_copy,files30[i],/verb
sccingest,files=file_search('*.fts')
files=scc_read_summary(date='30-dec-2007')
files171=where(files.value eq 171)
for i =0,N_ELEMENTS(files171)-1 do secchi_prep,sccfindfits(files[files171[i]].filename),in,da,savepath='/Users/eoincarley/data/secchi_l1',/write_fts,/rotate_on,/rotinterp_on
