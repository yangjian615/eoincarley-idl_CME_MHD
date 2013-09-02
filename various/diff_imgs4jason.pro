pro diff_imgs4jason

cd,'~/Data/22sep2011_event/AIA'
;read_sdo, 'aia.lev1.211A_2011-09-22T11_09_27.51Z.image_lev1.fits', he_aia_pre, data_aia_pre
;read_sdo, 'aia.lev1.211A_2011-09-22T11_10_00.62Z.image_lev1.fits', he_aia, data_aia

i=180
f = findfile('*.fits')
read_sdo, f[i], he_aia, data_aia
read_sdo, f[i-5], he_aia_pre, data_aia_pre
index2map, he_aia_pre, smooth(data_aia_pre,5)/he_aia_pre.exptime, map_aia_pre, outsize = 1024
index2map, he_aia, smooth(data_aia,5)/he_aia.exptime, map_aia, outsize = 1024
;map_c2_aia = merge_map(temporary(c2_mass_map), temporary(diff_aia),  use_min=0, /add)

;loadct,1
;plot_map, diff_aia, dmin=-4.0, dmax=5.0, fov = [120.0, 120.0], $
;center = [-1000.0, 0.0], position=pos, /normal, /noerase, /square,$
;title=' '
diff_map = diff_map(map_aia, map_aia_pre)
loadct,1
plot_map, diff, $
dmin = -5.0, dmax = 5.0  ;usually dmin=-6, dmax=3

set_line_color
plot_helio, he_aia.date_obs, gstyle=0, gthick=1.0, gcolor=1, grid_spacing=15.0, /over

window,1
img = diff_map.data >(-5) <5
plot_image, img

save, img, diff_map, he_aia, he_aia_pre, filename='rd_aia_20110922_111048.sav'
;


;----------------------------------------------------;
;	       Now plot just the COR1 data			  	 ;
cd,'~/Data/22sep2011_event/secchi/EUVI/b/34687667/l1'
files = findfile('*.fts')
pre = sccreadfits(files[0], he_euvi_pre)
data = sccreadfits(files[14], he_euvi)

index2map, he_euvi_pre, temporary(pre), map_euvi_pre
index2map, he_euvi, temporary(data) , map_euvi
diff_euvi = diff_map(map_euvi, map_euvi_pre)
diff_euvi.data = disk_nrgf(diff_euvi.data, he_euvi, 0, 0)
print,''
print,he_euvi.date_obs
print,''

diff_euvi.data = (diff_euvi.data - mean(diff_euvi.data))/stdev(diff_euvi.data) 


plot_map, diff_euvi, dmin=-4.0, dmax=4.0
set_line_color
plot_helio, he_euvi.date_obs, /over, gstyle=0, gthick=2.0, gcolor=1, grid_spacing=15.0

window,2

img   = diff_euvi.data >(-4.0) <4.0
diff_map = diff_euvi
plot_image, img
save, img, diff_map, he_euvi, he_euvi_pre, filename='bd_nrgf_20110922_111048.sav'



END