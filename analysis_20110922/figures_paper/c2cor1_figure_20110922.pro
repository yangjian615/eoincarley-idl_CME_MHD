pro c2cor1_figure_20110922, toggle=toggle

cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/L0.5/L1'
IF keyword_set(toggle) THEN BEGIN
	set_plot,'ps'
	!p.font=0
	device, filename='c2_aia_cor1_euvi.ps', /helvetica, /color, /inches, /landscape, /encapsulate,$
	xs=10, ys=10, bits_per_pixel=8, yoffset=10
ENDIF ELSE BEGIN
	window,0,xs=1000,ys=1000
ENDELSE
!y.ticklen=-0.02
!x.ticklen=-0.02
;--------------- LASCO C2 -------------------;

files = findfile('*.fts')
pre = lasco_readfits(files[0], he_pre)
mask = lasco_get_mask(he_pre)

img = lasco_readfits(files[5], c2hdr)
img = temporary(img)
img = temporary(img) - pre
mass_image = scc_calc_cme_mass(img,c2hdr, /all, pos=0.0)
mass_image = mass_image/stdev(mass_image)
mass_image = mass_image*temporary(mask)

index2map, c2hdr, temporary(mass_image), c2_mass_map


;---------------- AIA 211 --------------------;

cd,'~/Data/22sep2011_event/AIA'
read_sdo, 'aia.lev1.211A_2011-09-22T10_57_51.83Z.image_lev1.fits', he_aia_pre, data_aia_pre
read_sdo, 'aia.lev1.211A_2011-09-22T10_58_48.62Z.image_lev1.fits', he_aia, data_aia


index2map, he_aia_pre, smooth(temporary(data_aia_pre), 7)/he_aia_pre.exptime, map_aia_pre, outsize = 1024
index2map, he_aia, smooth(temporary(data_aia), 7)/he_aia.exptime, map_aia, outsize = 1024
diff_aia = diff_map(temporary(map_aia), temporary(map_aia_pre))
map_c2_aia = merge_map(temporary(c2_mass_map), temporary(diff_aia),  use_min=0, /add)

loadct,1
pos = [0.14, 0.5, 0.54, 0.9]
plot_map, map_c2_aia, dmin=-4.0, dmax=5.0,fov = [120.0, 120.0], $
center = [-1000.0, 0.0], position=pos, /normal, /noerase, /square,$
title=' '

set_line_color
plot_helio, he_aia.date_obs, /over, gstyle=0, gthick=2.0, gcolor=1, grid_spacing=15.0

xyouts, pos[0]+0.01, pos[1]+0.025, 'LASCO C2 '+anytim(c2hdr.date_obs, /yoh, /trun, /time_only)+' UT', /normal, charthick=3, color=1
xyouts, pos[0]+0.01, pos[1]+0.01, 'AIA 21.1 nm '+anytim(he_aia.date_obs, /yoh, /trun, /time_only)+' UT', /normal, charthick=3, color=1
xyouts, pos[2]-0.01, pos[3] - 0.02, 'a', /normal, alignment=1.0, charthick=3, color=1


;-------------- STEREO COR1 -----------------;
cd,'~/Data/22sep2011_event/secchi/COR1/b/24540411/l1_new'
files = findfile('*.fts')
pre = sccreadfits(files[5],he_pre)
data = sccreadfits(files[13],he)

;----------- remove nans --------------
remove_nans, pre, junk, junk, nan_pos
pre[nan_pos[*]] = 0.0
remove_nans, data, junk, junk, nan_pos
data[nan_pos[*]] = 0.0



img = data - pre
mask = get_smask(he)
img  = (img /stdev(img))*mask

index2map, he, temporary(img), cor1b_map

cor1b_map.data = (cor1b_map.data - mean(cor1b_map.data))/stdev(cor1b_map.data)



;------------ STEREO EUVI ------------------;
cd,'~/Data/22sep2011_event/secchi/EUVI/b/34687667/l1'
files = findfile('*.fts')
pre = sccreadfits(files[0], he_euvi_pre)
data = sccreadfits(files[13], he_euvi)

index2map, he_euvi_pre, temporary(pre), map_euvi_pre
index2map, he_euvi, temporary(data) , map_euvi
diff_euvi = diff_map(map_euvi, map_euvi_pre)
diff_euvi.data = disk_nrgf(diff_euvi.data, he_euvi, 0, 0)
print,''
print,he_euvi.date_obs
print,''

diff_euvi.data = (diff_euvi.data - mean(diff_euvi.data))/stdev(diff_euvi.data) 
pos = [ 0.55, 0.5, 0.95, 0.9]
cor1_euvi_map = merge_map(temporary(cor1b_map), diff_euvi,  use_min=0, /add)
plot_map, cor1_euvi_map, dmin=-4.0, dmax=4.0, center=[0.0, 0.0], fov = [120.0, 120.0],$
position=pos, /normal, /noerase, /square, title='', ytitle='',$
ytickname=[' ',' ',' ']
set_line_color
plot_helio, he_euvi.date_obs, /over, gstyle=0, gthick=2.0, gcolor=1, grid_spacing=15.0

;plot_wl_shock, he

xyouts, pos[0]+0.01, pos[1]+0.025, 'COR1-B '+anytim(he.date_obs, /yoh, /trun, /time_only)+' UT', /normal, charthick=3, color=1
xyouts, pos[0]+0.01, pos[1]+0.01, 'EUV-B 19.5 nm '+anytim(he_euvi.date_obs, /yoh, /trun, /time_only)+' UT', /normal, charthick=3, color=1
xyouts, pos[2]-0.01, pos[3] - 0.02, 'b', /normal, alignment=1.0, charthick=3, color=1


pos = [0.54, 0.75, 0.69, 0.9]
bg = fltarr(10, 10)
reverse_ct
bg[*,*] = 254
plot_image, bg, position = pos ,/noerase, /normal, xstyle=4, ystyle=4
date = anytim(file2time('20110922_103000'), /yoh)
pos = [pos[0], pos[1]-0.015, pos[2]+0.01, pos[3]-0.015]
scc_plot_where_edit, date, pos=pos, /white


set_line_color
;C2 arrows
arrow, 0.351, 0.563, 0.309, 0.599, color=1, /normal, thick=4, /solid, hthick=2
xyouts, 0.352, 0.558, 'WL Shock', /normal, color=1

arrow, 0.195, 0.588, 0.237, 0.61, color=1, /normal, thick=4, /solid, hthick=2
xyouts, 0.195, 0.572, 'CME front', /normal, alignment=0.5, color=1

arrow, 0.393, 0.62, 0.358, 0.656, color=1, /normal, thick=4, /solid, hthick=2
xyouts, 0.394, 0.615, 'CBF', /normal, color=1

;COR1 arrows
arrow, 0.869, 0.652, 0.852, 0.652, color=1, /normal, thick=4, /solid, hthick=2
xyouts, 0.87, 0.648, 'CME front', /normal, color=1

arrow, 0.84, 0.56, 0.824, 0.595, color=1, /normal, thick=4, /solid, hthick=2
xyouts, 0.84, 0.55, 'WL Shock', /normal, alignment=0.5, color=1



;---------------------------------------------------------;
;----------------- Plot Shock Zoom-ins -------------------;
;---------------------------------------------------------;

loadct,1
y1 = 0.22
y2 = 0.42
pos = [0.22, y1, 0.42, y2]
plot_cor1_zooms, 13, pos,  tag='c', ytitle='Y (arcsecs)', ytickn=['-3000', '-2000', '-1000', '0'], $
time = '11:05:53'
plot_wl_shock, he, 'circle_params_2011-09-22T11:05:53.890.sav'

pos = [0.45, y1, 0.65, y2 ]
plot_cor1_zooms, 14, pos,  tag='d', ytitle='', ytickn=[' ', ' ', ' ', ' '], time = '11:10:53'
plot_wl_shock, he, 'circle_params_2011-09-22T11:10:53.875.sav'

pos = [0.68, y1, 0.88, y2 ]
plot_cor1_zooms, 15, pos,  tag='e', ytitle='', ytickn=[' ', ' ', ' ', ' '], time = '11:15:53'
plot_wl_shock, he, 'circle_params_2011-09-22T11:15:53.891.sav'


IF keyword_set(toggle) THEN BEGIN
device,/close
set_plot,'x'
ENDIF


END

;---------------------------------------------------------;
;------------------------ WL Shock stuff -----------------;
;---------------------------------------------------------;

pro plot_wl_shock, he, save_file
	cd,'~/Data/22sep2011_event/secchi/COR1/b/24540411/l1_new'
	restore, save_file, /verb

	suncen = scc_SUN_CENTER(he)

	xcenter = circle_fit_result[0]
	ycenter = circle_fit_result[1]
	xcen = xcenter - suncen.xcen
	ycen = ycenter - suncen.ycen

	xcen = xcen*he.cdelt1
	ycen = ycen*he.cdelt2
	PLOTSYM, 0, /fill
	plots, [xcen, ycen], psym=8, color=4, symsize=1.0, /data, thick=0.5

	circle_radius = circle_fit_result[2]*he.cdelt1
	angles = dindgen(360) + 1.0
	x_sim = xcen + circle_radius*cos(!DTOR*angles)
	y_sim = ycen + circle_radius*sin(!DTOR*angles)
	oplot, x_sim, y_sim, color=4, linestyle=1, thick=7

	hyp = sqrt((xcenter - suncen.xcen)^2.0 + (ycenter - suncen.ycen)^2.0)
	op = sqrt((xcenter - xcenter)^2.0 + (ycenter - suncen.ycen)^2.0)
	angle = asin( op/hyp )
	angle = 360*!DTOR - angle
	;plots, sun.xcen, sun.ycen, psym=2, color=5, symsize=2
	rhos = findgen(280)
	xline = (COS(angle) * rhos + 0.0)*he.cdelt1
	yline = (SIN(angle) * rhos + 0.0)*he.cdelt1
	plots, xline, yline, color=4, thick=4
	
	PLOTSYM, 4, /fill
	apex_x = xcen + circle_radius*cos(angle)
	apex_y = ycen + circle_radius*sin(angle)
	plots, apex_x, apex_y, color=4, psym=8, thick=5, symsize=1.3 

	x_so = (x_so - suncen.xcen)*he.cdelt1
	y_so = (y_so - suncen.ycen)*he.cdelt2
	plots, x_so, y_so, psym=1, color=4, symsize=1.5, thick=3
END

;---------------------------------------------------------;
;------------------ Plot COR1 Zooms ----------------------;
;---------------------------------------------------------;

pro plot_cor1_zooms, i, pos, tag=tag, ytitle=ytitle, ytickn=ytickn, time=time

	;-------------- STEREO COR1 -----------------;
	cd,'~/Data/22sep2011_event/secchi/COR1/b/24540411/l1_new'
	files = findfile('*.fts')
	pre = sccreadfits(files[5],he_pre)
	data = sccreadfits(files[i],he)

	;----------- remove nans --------------
	remove_nans, pre, junk, junk, nan_pos
	pre[nan_pos[*]] = 0.0
	remove_nans, data, junk, junk, nan_pos
	data[nan_pos[*]] = 0.0

	img = data - pre
	mask = get_smask(he)
	img  = (img /stdev(img))*mask

	index2map, he, temporary(img), cor1b_map
	cor1b_map.data = (cor1b_map.data - mean(cor1b_map.data))/stdev(cor1b_map.data)

	;------------ STEREO EUVI ------------------;
	cd,'~/Data/22sep2011_event/secchi/EUVI/b/34687667/l1'
	files = findfile('*.fts')
	pre = sccreadfits(files[0], he_euvi_pre)
	data = sccreadfits(files[i], he_euvi)

	index2map, he_euvi_pre, temporary(pre), map_euvi_pre
	index2map, he_euvi, temporary(data) , map_euvi
	diff_euvi = diff_map(map_euvi, map_euvi_pre)
	diff_euvi.data = disk_nrgf(diff_euvi.data, he_euvi, 0, 0)
	print,''
	print,he_euvi.date_obs
	print,''

	diff_euvi.data = (diff_euvi.data - mean(diff_euvi.data))/stdev(diff_euvi.data) 
	cor1_euvi_map = merge_map(temporary(cor1b_map), diff_euvi,  use_min=0, /add)
	plot_map, cor1_euvi_map, dmin=-2.0, dmax=2.0, center=[1400.0, -1400.0], fov = [62.0, 62.0],$
	position=pos, /normal, /noerase, /square, title='', ytitle=ytitle, ytickname= ytickn
	
	set_line_color
	plot_helio, he_euvi.date_obs, /over, gstyle=0, gthick=2.0, gcolor=1, grid_spacing=15.0
	
	xyouts, pos[2]-0.01, pos[3] - 0.02, tag, /normal, alignment=1.0, charthick=3, color=1
	xyouts, pos[0]+0.008, pos[1] + 0.016, 'COR1-B '+time+' UT', /normal, charthick=3, color=1, charsize=0.8
	xyouts, pos[0]+0.008, pos[1] + 0.004, 'EUVI-B '+anytim(he_euvi.date_obs, /yoh, /time_only, /trun)+' UT', $
		/normal, charthick=3, color=1, charsize=0.8
END

