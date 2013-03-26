
files30=sock_find('http://stereo-ssc.nascom.nasa.gov/','*n4*.fts',path='data/ins_data/secchi/L0/b/img/euvi/20071230')
for i=750,N_ELEMENTS(files30)-1 do begin sock_copy,files30[i],/verb
sccingest,files=file_search('*.fts')
files=scc_read_summary(date='30-dec-2007')
files171=where(files.value eq 171)
for i =0,N_ELEMENTS(files171)-1 do secchi_prep,sccfindfits(files[files171[i]].filename),in,da,savepath='/Users/eoincarley/data/secchi_l1',/write_fts,/rotate_on,/rotinterp_on


files195=where(files.value eq 195)
for i =0,N_ELEMENTS(files195)-1 do secchi_prep,sccfindfits(files[files195[i]].filename),in,da,savepath='/Users/mcateer/Work/claire/195',/write_fts,/rotate_on,/rotinterp_on


files31=sock_find('http://stereo-ssc.nascom.nasa.gov/','*n4*.fts',path='data/ins_data/secchi/L0/b/img/euvi/20071231')
for i=0,349 do begin sock_copy,files31[i],/verbs
sccingest,files=file_search('*.fts')
files=scc_read_summary(date='31-dec-2007')
files171=where(files.value eq 171)
for i =0,N_ELEMENTS(files171)-1 do secchi_prep,sccfindfits(files[files171[i]].filename),in,da,savepath='/Users/mcateer/Work/claire/171',/write_fts,/rotate_on,/rotinterp_on
files195=where(files.value eq 195)
for i =0,N_ELEMENTS(files195)-1 do secchi_prep,sccfindfits(files[files195[i]].filename),in,da,savepath='/Users/mcateer/Work/claire/195',/write_fts,/rotate_on,/rotinterp_on


files_cor1=sock_find('http://stereo-ssc.nascom.nasa.gov/','*s4*.fts',path='data/ins_data/secchi/L0/b/seq/cor1/20071231')
for i=0,99 do begin sock_copy,files_cor1[i],/verb
sccingest,files=file_search('*.fts')
files=scc_read_summary(date='31-dec-2007')
filescor1=where(files.telescope eq 'COR1')
for i =0,95,3 do secchi_prep,sccfindfits(files[filescor1[i:i+2]].filename),in,da,savepath='/Users/mcateer/Work/claire/cor1',/write_fts,$
    /rotate_on,/rotinterp_on,/polariz_on,/smask_on,/fill_mean,/calfac_off


files_cor2=sock_find('http://stereo-ssc.nascom.nasa.gov/','*n4*.fts',path='data/ins_data/secchi/L0/b/seq/cor2/20071231')
for i=0,N_ELEMENTS(files_cor2)-1 do begin sock_copy,files_cor2[i],/verb
sccingest,files=file_search('*.fts')
files=scc_read_summary(date='31-dec-2007')
filescor2=where(files.telescope eq 'COR2')
for i =0,61,3 do secchi_prep,sccfindfits(files[filescor2[i:i+2]].filename),in,da,savepath='/Users/mcateer/Work/claire/cor2',/write_fts,$
    /rotate_on,/rotinterp_on,/polariz_on,/smask_on,/fill_mean,/calfac_off


;some COR2 data fiddling - change to COR2 folder
fls=file_search('*.fts')
for i=0,20 do begin & $
    da=sccreadfits(fls[i],in) & $
    da[where(da LT 0)] = 0. & $
    sccwritefits,fls[i],da,in & $
endfor


;-- read EUVI image

st=obj_new('secchi')
st->read,euvi_file

;-- read EIT image

et=obj_new('eit')
et->read, eit_file

;-- plot EUVI image and overlay EIT image

st->plot
et->plot,/over,/drot

;get COR1-HT
fls=file_search('cor1/*.fts')
da=sccreadfits(fls,he)

cme_heights_cor1=fltarr(9,5)

;FOR j=9,17 do begin
j=18

hd1=fitshead2wcs(he[j])
sc=wcs_get_pixel(hd1,[0,0])

sc=scc_sun_center(he[j])
plot_image,(da[*,*,j]-da[*,*,j-1])^0.2,xrange=[0,500],yrange=[0,500]
hts=fltarr(2,5)

tst1=mark2()
tst2=mark2()
tst3=mark2()
tst4=mark2()
tst5=mark2()

hts=[[tst1],[tst2],[tst3],[tst4],[tst5]]
hts=wcs_get_coord(hd1,[hts])
radial_hts = fltarr(5)
for i=0,4 do radial_hts[i]=sqrt(hts[0,i]^2 + hts[1,i]^2) * 696000/he[9].rsun
cme_heights_cor1[j-9,*]=radial_hts

print,cme_heights_cor1
cme_times_cor1=he[9:17].date_obs

