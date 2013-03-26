pro cme_analysis_20110607

;Used this to get diff images right.

;cd,'/Users/eoincarley/Data/secchi_l1/20110607/cor2/'
cd,'/Users/eoincarley/Data/secchi_lz/L0/a/20110607/cor2/30738614'
files = findfile('*.fts')
i=2
data0 = sccreadfits(files[i], he)
mask = get_smask(he)
data0 = data0*mask

hist = HISTOGRAM(data0,binsize=1.0) 
bins = FINDGEN(N_ELEMENTS(hist)) + MIN(data0)
plot,bins,hist, /xlog, xr=[2.0e3, 1.0e4], yr=[0,3e4], charsize=1.5, /xs, /ys,$
title=he.date_obs


cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor2a/normal_images'
files = findfile('*.fts')

data1 = sccreadfits(files[i], he)
mask = get_smask(he)
data1 = data1*mask

hist = HISTOGRAM(data1,binsize=1.0) 
bins = FINDGEN(N_ELEMENTS(hist)) + MIN(data1)
window,1
plot,bins,hist, /xlog, xr=[2.0e3, 1.0e4], yr=[0,3e4], charsize=1.5, /xs, /ys,$
title=he.date_obs

cd,'/Users/eoincarley/Data/secchi_lz/L0/a/20110607/cor2/30738614'
files = findfile('*.fts')
SECCHI_PREP, files[0:2], he0, img0, /polariz_on, /calfac_on
mask = get_smask(he)
img0 = img0*mask
window,3
plot_image, bytscl(img0, 0.0, 5.0e-9)

SECCHI_PREP, files[6:8], he1, img1, /polariz_on, /calfac_on
mask = get_smask(he)
img1 = img1*mask
window,4
plot_image, bytscl(img1, 0.0, 5.0e-9)


img_bs = img1 - img0

plot_image, bytscl(img_bs,-2.0e-10, 0.8e-9), title=he1.date_obs

stop
END
;/Users/eoincarley/Data/secchi_lz/L0/a/20110607/cor2/30738614